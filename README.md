# Skills

<p align="center">
  <img src="assets/banner.png" alt="SKILLS — Portable AI Agent SKILL.md Pack" width="1200" />
</p>

> **Weave the unseen. Layer the infinite. Illuminate with elegance.**

Portable AI agent skills — each `skills/<name>/SKILL.md` loads when the task fits its `description`. Works with any agent that reads `SKILL.md` files from a skills directory.

## Skills

| Skill | Summary |
|-------|---------|
| [aetherweave-design-system](skills/aetherweave-design-system/SKILL.md) | Aetherweave UI (`--aw-*`, glass, type, motion, a11y). Full detail: [design.md](design.md). |
| [hetzner-ubuntu-gui-server](skills/hetzner-ubuntu-gui-server/SKILL.md) | Hetzner Ubuntu, TigerVNC, SSH, UFW, zram, GNOME, rescue / handoff. |

## Install

### Cursor
```bash
git clone https://github.com/PhilipAD/skills.git
./skills/scripts/install-to-cursor.sh   # or: cp -r skills/* ~/.cursor/skills/
```
Restart Cursor. One skill: `ln -s "$(pwd)/skills/<name>" ~/.cursor/skills/<name>`

### Other agents
Copy or symlink `skills/<name>/` into your agent's skills directory. Each skill lives at `skills/<name>/SKILL.md` with optional `references/` alongside.

## Without installing

- **@** `skills/<name>/SKILL.md` in chat, or paste a raw GitHub `SKILL.md` URL.

## Contribute a skill

Add `skills/<name>/SKILL.md` (YAML `name` + `description`). Optional `references/`. Update the table. MIT — [LICENSE](LICENSE).
