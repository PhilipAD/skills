# Open Skillkit

<p align="center">
  <img src="https://raw.githubusercontent.com/PhilipAD/open-skillkit/main/assets/banner.png" alt="Open Skillkit banner" width="1200" />
</p>

OSS **[Cursor skills](https://cursor.com/docs/context/skills)** — each folder under `skills/` is a `SKILL.md` the agent uses when the task fits its `description`.

| Skill | Summary |
|-------|---------|
| [hetzner-ubuntu-gui-server](skills/hetzner-ubuntu-gui-server/SKILL.md) | Hetzner Ubuntu + TigerVNC, SSH, UFW, zram (24.04 extras), GNOME tweaks, xrdp cleanup, rescue / handoff. |

## Install

Skills load from **`~/.cursor/skills/<name>/SKILL.md`** or **`.cursor/skills/`** in a project.

```bash
git clone https://github.com/PhilipAD/open-skillkit.git
cp -r open-skillkit/skills/* ~/.cursor/skills/   # then restart Cursor
```

One skill, symlink, or script:

```bash
cp open-skillkit/skills/hetzner-ubuntu-gui-server/SKILL.md ~/.cursor/skills/hetzner-ubuntu-gui-server/
ln -s "$(pwd)/open-skillkit/skills/hetzner-ubuntu-gui-server" ~/.cursor/skills/hetzner-ubuntu-gui-server
./open-skillkit/scripts/install-to-cursor.sh
```

*(“Remote Rule (GitHub)” in Cursor is for rules workflows; for skills, copy/symlink is the straightforward path.)*

## Point your AI at a skill (no install)

Useful for one-off chats or sharing with someone who doesn’t want files on disk yet:

**@ reference in Cursor chat**  
Add the file: `@skills/hetzner-ubuntu-gui-server/SKILL.md` (if the repo is open), or **@** → attach the file from disk.

**Paste a raw GitHub URL**  
Hetzner / Ubuntu GUI skill (branch `main`): [raw `SKILL.md`](https://raw.githubusercontent.com/PhilipAD/open-skillkit/main/skills/hetzner-ubuntu-gui-server/SKILL.md)  
Ask the agent: *“Follow the instructions in this skill:”* and paste that URL (or download and **@** attach the file).

**Explicit instruction**  
*“Read and follow `SKILL.md` in this repo under `skills/hetzner-ubuntu-gui-server/`.”*

Skills under `~/.cursor/skills` or `.cursor/skills` are picked up automatically when the agent thinks the `description` fits; **@** / URL forces the context.

## Add a skill

New folder: `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description` — third person, **what + when**). Add a row to the table above. MIT — [LICENSE](LICENSE).
