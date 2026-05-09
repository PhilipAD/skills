---
name: fast-mac-deploy
description: Fast macOS app deployment via SSH ControlMaster — single-command execution, no new keys, ssh mac alias only. Use for building, codesigning, notarizing, and launching macOS apps on a remote Mac from any Linux/Windows orchestrator with Tailscale access.
version: 1.0
author: PhilipAD
tags: [macos, deployment, ssh, xcode, codesign, swift, tailscale]
---

Use this skill by default for ANY task that needs to run on the Mac.

# fast-mac-deploy

Deploy macOS apps to a remote Mac via SSH ControlMaster multiplexing. Single bash command from any Linux/Windows orchestrator with Tailscale VPN.

## When to use

- Building Swift/AppKit apps remotely and launching on Mac screen
- Deploying `.app` bundles with codesign + `open`
- Xcode command-line builds (`xcodebuild`)
- Any task requiring zero-trust sudo on a remote Mac

## Prerequisites

### Orchestrator side
- SSH key at `~/.ssh/id_ed25519` (existing key — **never generate new ones**)
- SSH alias `mac` in `~/.ssh/config` pointing to the Mac's Tailscale IP
- ControlMaster configured in `~/.ssh/config`

### Mac side
- SSH key in `~/.ssh/authorized_keys` (the orchestrator's public key)
- Passwordless sudo enabled for the SSH user

### Setup (one-time)

**1. On the orchestrator, add to `~/.ssh/config`:**
```
Host mac
    HostName <mac-tailscale-ip>
    User <mac-username>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    ServerAliveInterval 60
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
```

**2. Create the socket directory:**
```bash
mkdir -p ~/.ssh/sockets
```

**3. Add your public key to the Mac:**
```bash
cat ~/.ssh/id_ed25519.pub | ssh mac "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**4. Confirm sudo access:**
```bash
ssh mac "sudo whoami"  # should return "root"
```

### Verify setup

```bash
ssh mac "echo '✅ SSH connected' && whoami && sw_vers"
```

---

## Single-Command Deployment Pattern

Never split into multiple `ssh mac` calls. Write one command that does everything:

```bash
ssh mac "cd ~/Desktop/AppName && swiftc -o App.app/Contents/MacOS/AppName main.swift 2>&1 && find App.app -exec xattr -c {} \; 2>/dev/null; codesign --force --deep --sign - App.app 2>&1 && open App.app && echo '✅ Deployed'"
```

### Anatomy
| Step | Command |
|------|---------|
| Navigate | `cd ~/Desktop/AppName` |
| Compile | `swiftc -o App.app/Contents/MacOS/AppName main.swift` |
| Strip extended attrs | `find App.app -exec xattr -c {} \;` (avoids codesign detritus error) |
| Code sign (ad-hoc) | `codesign --force --deep --sign - App.app` |
| Launch | `open App.app` |

---

## Common Deployment Recipes

### Hello World App (AppKit + Swift)
```bash
ssh mac "mkdir -p ~/Desktop/HermesHello/HermesHello.app/Contents/MacOS ~/Desktop/HermesHello/HermesHello.app/Contents/Resources && cat > ~/Desktop/HermesHello/main.swift << 'SWIFT'
import AppKit
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(contentRect: NSRect(x:0,y:0,width:600,height:200),
                          styleMask:[.titled,.closable,.miniaturizable],
                          backing:.buffered, defer:false)
        window.title = \"Hello from Hermes!\"
        window.center()
        let label = NSTextField(labelWithString:\"Full access confirmed!\")
        label.font = .systemFont(ofSize:16, weight:.medium)
        label.alignment = .center
        window.contentView = label
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps:true)
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender:NSApplication)->Bool{true}
}
let app = NSApplication.shared
app.delegate = AppDelegate()
app.setActivationPolicy(.regular)
app.run()
SWIFT
swiftc -o HermesHello.app/Contents/MacOS/HermesHello main.swift
find HermesHello.app -exec xattr -c {} \; 2>/dev/null
codesign --force --deep --sign - HermesHello.app
open HermesHello.app"
```

### Full Xcode Build
```bash
ssh mac "cd ~/path && xcodebuild -scheme AppName build CODE_SIGN_IDENTITY='-' CODE_SIGNING_REQUIRED=NO 2>&1 && open -a AppName.app"
```

### Xcode + Codesign + Distribute
```bash
ssh mac "cd ~/path && xcodebuild -scheme AppName -configuration Release archive 2>&1 && xcodebuild -exportArchive -archivePath build/Release/AppName.xcarchive -exportPath build/Release -exportOptionsPlist exportOptions.plist 2>&1"
```

---

## File Transfer

### Copy to Mac
```bash
scp -o ControlMaster=auto local.file mac:~/remote/path/
```

### Copy from Mac
```bash
scp -o ControlMaster=auto mac:~/remote/file.txt ./
```

### Rsync (faster for large dirs)
```bash
rsync -avz --rsync-path='sudo rsync' ./local-dir/ mac:~/remote-dir/
```

---

## Troubleshooting

### "Permission denied (publickey)"
→ Orchestrator's public key not in Mac's `~/.ssh/authorized_keys`. Add with:
```bash
cat ~/.ssh/id_ed25519.pub | ssh mac "cat >> ~/.ssh/authorized_keys"
```

### "Host key verification failed"
→ Mac's host key not in `known_hosts`. Fix with:
```bash
ssh-keyscan -H <mac-tailscale-ip> >> ~/.ssh/known_hosts
```

### "Too many authentication failures"
→ Too many keys offered. Use `IdentitiesOnly yes` in config or:
```bash
ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes mac "echo connected"
```

### "resource fork, Finder information, or similar detritus not allowed"
→ Extended attributes blocking codesign. Fix with:
```bash
find App.app -exec xattr -c {} \; 2>/dev/null
```

### "codesign: ambiguous argument"
→ Wrong path. Use absolute path from user home:
```bash
codesign --force --deep --sign - ~/Desktop/AppName/App.app
```

---

## Permanent Rules (hard-coded)

1. **SSH alias `mac` only** — never use raw IP or `user@host`
2. **Existing SSH key only** — `~/.ssh/id_ed25519`. Never run `ssh-keygen`
3. **ControlMaster multiplexing** — already configured, use it
4. **Single-script execution** — one `ssh mac "..."` call per task
5. **Passwordless sudo** — use `sudo` freely
6. **File transfer** — `scp` or `rsync` over SSH to `mac:`

---

## Skill Metadata

| Field | Value |
|-------|-------|
| Name | fast-mac-deploy |
| Version | 1.0 |
| Author | PhilipAD |
| Platforms | linux, macos, windows (with WSL) |
| Requirements | SSH key, Tailscale, sudo on Mac |