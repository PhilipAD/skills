---
name: hetzner-ubuntu-gui-server
description: Operates Ubuntu on Hetzner (or similar) with TigerVNC remote GUI, SSH access, UFW, zram, and optional GNOME tuning. Use when provisioning or troubleshooting headless Ubuntu with VNC, replacing xrdp, resetting passwords from rescue, fixing zram on Ubuntu 24.04, or handing off server changes to DevOps.
---

# Hetzner / Ubuntu GUI server runbook

## When this applies

- Ubuntu **22.04/24.04** on **Hetzner** (Cloud or dedicated), **no physical display**.
- Remote desktop via **TigerVNC** (not xrdp), **SSH** for admin.
- Goal: **repeatable** firewall, session, and handoff patterns—**not** secrets in chat.

## SSH

- Prefer **ed25519 key** + `~/.ssh/config` `Host` block (`IdentityFile`, `IdentitiesOnly yes`).
- **Do not** rely on storing login passwords in `ssh_config`; keys are the supported “no prompt” path.
- If **TCP 22** fails from one network but works from another, suspect **cloud firewall**, **host firewall**, or **fail2ban**—not always `sshd` down.

## TigerVNC (systemd)

- Typical unit: `vncserver@.service`, user session, `ExecStart=/usr/bin/vncserver -localhost no -geometry 1920x1080 -depth 24 :%i` (or `-localhost yes` + **SSH tunnel** if exposing `5901` is unacceptable).
- **Open UFW** only if listening on `0.0.0.0` (e.g. `ufw allow 5901/tcp`).
- **`~/.vnc/xstartup`:** XFCE vs **Ubuntu GNOME** command lines and **`.bak`** naming—see **TigerVNC + GNOME session (paths)** below.
- **VNC password** is **`~/.vnc/passwd`** (vncpasswd)—independent of Linux PAM unless you integrate them.
- Automated VNC auth probes can trigger **“Too many security failures”** (no challenge returned); fix with **time**, **restart `vncserver@`**, or avoid brute probes.

## xrdp removal (cleanup)

- `apt purge xrdp xorgxrdp` + `apt autoremove --purge`.
- Remove **UFW 3389**; remove leftover **`/etc/X11/xrdp`**, **`/etc/X11/Xsession.d/*xrdp*`** if present.

## zram (`zram-tools`) on Ubuntu 24.04

- If **`modprobe zram`** says module missing despite `CONFIG_ZRAM=m`, install **`linux-modules-extra-$(uname -r)`** (e.g. on **6.8.0-110-generic**, `zram.ko` lived only there—not in `linux-modules-*` alone).
- Set **`PERCENT=50`** in **`/etc/default/zramswap`** (overrides static `SIZE` when set); `systemctl restart zramswap`; expect something like **`/dev/zram0` ~15G @ swapon priority 100** on a **~32G RAM** host, **plus** existing **`/swapfile`** (e.g. **2G**, lower priority)—confirm with **`swapon --show`**.

## GNOME desktop stack (packages + keys)

Apply **`gsettings`** as the **GUI user** (e.g. **`rdpuser`**): wrap in **`sudo -u rdpuser dbus-run-session -- bash -c '...'`** so **`dconf`** activates without a full graphical login.

### Animations off (GNOME)

- **Schema/key:** `org.gnome.desktop.interface` → **`enable-animations`** → **`false`**
- **Example:** `gsettings set org.gnome.desktop.interface enable-animations false`

### Tweaks + Extension Manager (apt)

- **`gnome-tweaks`**
- **`gnome-shell-extension-manager`**

### Metapackages / Ubuntu-bundled extensions

- **`ubuntu-desktop-minimal`** pulls **GNOME Shell**, **`ubuntu-session`**, **`gnome-shell-extension-ubuntu-dock`**, **`gnome-shell-extension-appindicator`**, **`gnome-shell-extension-desktop-icons-ng`** (**ding@rastersoft.com**), **`gnome-shell-extension-ubuntu-tiling-assistant`** (**tiling-assistant@ubuntu.com**), **`gnome-shell-extensions`**, **`chrome-gnome-shell`** / **browser connector** for extensions.gnome.org integration.
- **`xubuntu-desktop`** alongside minimal: **XFCE** session available; **default display manager** stays **`lightdm`**—check **`/etc/X11/default-display-manager`**. At a **physical/lightdm** login, use the **session menu** for **Ubuntu** vs **Xubuntu**.

### `org.gnome.shell enabled-extensions` (example policy)

- **Turn off `ubuntu-dock@ubuntu.com`** when using **Dash to Panel** (both fight for a taskbar).
- **From extensions.gnome.org** (match **Shell** version, e.g. **46**): **Dash to Panel** **`dash-to-panel@jderose9.github.com`** (UUID ends **`github.com`**, not **`github.io`**); **ArcMenu** **`arcmenu@arcmenu.com`**.
- **Include `user-theme@gnome-shell-extensions.gcampax.github.com`** so **shell** themes in **Tweaks → Appearance** work after a theme is installed.
- **Typical enabled set (illustrative):** `dash-to-panel@jderose9.github.com`, `arcmenu@arcmenu.com`, `ubuntu-appindicators@ubuntu.com`, `ding@rastersoft.com`, `user-theme@gnome-shell-extensions.gcampax.github.com`, `tiling-assistant@ubuntu.com`—**omit** `ubuntu-dock@ubuntu.com`.

### Title bar buttons

- **Schema/key:** `org.gnome.desktop.wm.preferences` → **`button-layout`**
- **Value:** `appmenu:minimize,maximize,close`
- **Example:** `gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'`

### Caffeine

- **Package:** **`caffeine`** (desktop app for “don’t idle / fullscreen” behavior)—**not** a separate GNOME Shell extension from apt on stock Noble.

### Housekeeping

- Run **`apt autoremove`** after large meta installs; **“0 to remove”** is normal if already clean.

### Not fully automated (by design / repos)

- **Orchis / WhiteSur–style themes:** no stock **`apt`** packages; install via **zip / PPA / upstream** then select in **Tweaks → Appearance** (User Themes extension must stay enabled).
- **“Dash to Dock”** as its own extension: often **absent** from **24.04** repos; **Dash to Panel** is the usual **taskbar** substitute.
- **First VNC GNOME login:** if layout/extensions look wrong, **disconnect/reconnect** once or open **Extension Manager** and confirm **Dash to Panel** / **ArcMenu** are enabled.

## TigerVNC + GNOME session (paths)

- **`~/.vnc/xstartup`** for **Ubuntu GNOME over X11:** end with **`exec dbus-run-session -- gnome-session --session=ubuntu`** (set **`XDG_SESSION_TYPE=x11`** if needed).
- **Backup before switching from XFCE:** e.g. **`~/.vnc/xstartup.xfce.bak`** (copy of **`dbus-run-session -- startxfce4`** version).
- After edits: **`systemctl restart vncserver@1`** (or the instance you use, e.g. **`:1` → port 5901**).

## Password / rescue

- **Live passwords are not recoverable** from `/etc/shadow` (hashes only).
- **Hetzner Rescue:** mount real root (e.g. `/dev/sda3`—confirm with `lsblk -f`), then:
  - `awk -F: '($3>=1000||$1=="root"){print $1 ":NEWPASS"}' /mnt/etc/passwd | chpasswd -R /mnt`
- **Caveat:** UID **≥ 1000** often includes **`nobody`** (65534)—scope resets deliberately.
- After resets, verify **SSH** and **VNC** separately.

## Firewall audit (on box)

- Collect: `ufw status verbose`, `ss -tlnp`, `nft list ruleset` (root), `fail2ban-client status sshd`.
- Optional script pattern: enumerate listeners, compare **22 vs 5901** (or tunnel-only VNC).

## DevOps handoff

- One concise bullet list: **ports**, **DE/session** (GNOME vs XFCE), **VNC vs SSH**, **keys vs passwords**, **packages added**, **services enabled**, **known risks** (public VNC, pasted secrets).

## Anti-patterns

- Posting **root/VNC passwords** in tickets or chat—rotate if leaked.
- **Public VNC** without IP restriction or tunnel—high brute-force noise.
- Assuming **`linux-modules`** alone provides all `*.ko`; check **`linux-modules-extra`** when `modprobe` fails.
