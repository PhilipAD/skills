# Open Skillkit

Portable **[Cursor Agent Skills](https://cursor.com/docs/context/skills)** (`SKILL.md` bundles) shared as open source. Each skill is a small playbook the agent reads when a task matches its `description`.

## Skill catalog

| Skill | What it does |
|-------|----------------|
| [**hetzner-ubuntu-gui-server**](skills/hetzner-ubuntu-gui-server/SKILL.md) | Hetzner / Ubuntu headless GUI: TigerVNC, SSH, UFW, zram (`linux-modules-extra` on 24.04), GNOME tuning, xrdp removal, rescue passwords, DevOps handoff patterns. |

More skills can be added under `skills/<name>/SKILL.md` (see **Contributing**).

## Install (pick one)

### A. Copy into global Cursor skills (recommended)

Cursor loads skills from **`~/.cursor/skills/<skill-name>/SKILL.md`** ([docs](https://cursor.com/docs/context/skills)).

```bash
git clone https://github.com/<you>/open-skillkit.git
cp -r open-skillkit/skills/* ~/.cursor/skills/
# restart Cursor
```

### B. One skill only

```bash
mkdir -p ~/.cursor/skills/hetzner-ubuntu-gui-server
cp open-skillkit/skills/hetzner-ubuntu-gui-server/SKILL.md ~/.cursor/skills/hetzner-ubuntu-gui-server/
```

### C. Project-only (commit in your repo)

```bash
mkdir -p .cursor/skills
cp -r open-skillkit/skills/hetzner-ubuntu-gui-server .cursor/skills/
```

### D. Symlink (stay synced with `git pull`)

```bash
ln -s "$(pwd)/open-skillkit/skills/hetzner-ubuntu-gui-server" ~/.cursor/skills/hetzner-ubuntu-gui-server
```

### E. Cursor “Remote Rule (GitHub)”

Some teams pin repo-wide rules via **Settings → Rules → Add Rule → Remote Rule (GitHub)** ([docs](https://cursor.com/docs/context/skills)). That path targets **rules** workflows; **skills** are still standard `SKILL.md` trees. Prefer **A–D** for skills unless Cursor’s UI explicitly imports your layout—when in doubt, use **copy** or **symlink**.

### F. `install.sh` (copy all skills)

```bash
./scripts/install-to-cursor.sh        # default: ~/.cursor/skills
CURSOR_SKILLS_DIR=/path ./scripts/install-to-cursor.sh
```

## Point your AI at a skill (no install)

Useful for one-off chats or sharing with someone who doesn’t want files on disk yet:

1. **@ reference in Cursor chat**  
   Add the file: `@skills/hetzner-ubuntu-gui-server/SKILL.md` (if the repo is open), or `@` → attach the file from disk.

2. **Paste a raw GitHub URL** (after you publish the repo)  
   Example pattern:  
   `https://raw.githubusercontent.com/<you>/open-skillkit/main/skills/hetzner-ubuntu-gui-server/SKILL.md`  
   Ask the agent: *“Follow the instructions in this skill:”* and paste the URL. The agent should fetch or you attach the downloaded file.

3. **Explicit instruction**  
   *“Read and follow `SKILL.md` in this repo under `skills/hetzner-ubuntu-gui-server/`.”*

Discovered skills (in `~/.cursor/skills` or `.cursor/skills`) are injected automatically when the agent judges the `description` relevant; **@** / URL is for forcing context.

## Layout

```
open-skillkit/
├── README.md                 # this file
├── LICENSE
├── scripts/
│   └── install-to-cursor.sh
└── skills/
    └── <skill-name>/
        └── SKILL.md          # YAML frontmatter: name, description
```

Each `SKILL.md` must start with:

```yaml
---
name: kebab-case-name
description: Third-person WHAT and WHEN (helps the agent decide to apply it).
---
```

## Contributing

1. Add `skills/<new-skill>/SKILL.md`.
2. Add a row to the **Skill catalog** in this README.
3. Keep each skill focused; link extra detail from `reference.md` in the same folder if needed.

## License

MIT — see [LICENSE](LICENSE).
