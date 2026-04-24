# Open Skillkit

<p align="center">
  <img src="assets/banner.png" alt="OPEN SKILLKIT — Open Skillkit banner" width="1200" />
</p>

> **Weave the unseen. Layer the infinite. Illuminate with elegance.**

[Cursor skills](https://cursor.com/docs/context/skills): each `skills/<name>/SKILL.md` loads when the task fits its `description`. Cursor reads **`~/.cursor/skills/`** or **`.cursor/skills/`**.

## Skills

| Skill | Summary |
|-------|---------|
| [aetherweave-design-system](skills/aetherweave-design-system/SKILL.md) | Aetherweave UI (`--aw-*`, glass, type, motion, a11y). Full detail: [design.md](design.md). |
| [hetzner-ubuntu-gui-server](skills/hetzner-ubuntu-gui-server/SKILL.md) | Hetzner Ubuntu, TigerVNC, SSH, UFW, zram, GNOME, rescue / handoff. |

`./scripts/install-to-cursor.sh` copies skills into `~/.cursor/skills/` and pulls [design.md](design.md) in for the Aetherweave skill.

## Install

```bash
git clone https://github.com/PhilipAD/open-skillkit.git
./open-skillkit/scripts/install-to-cursor.sh   # or: cp -r open-skillkit/skills/* ~/.cursor/skills/
```

Restart Cursor. One skill: `ln -s "$(pwd)/open-skillkit/skills/<name>" ~/.cursor/skills/<name>`

## Without installing

- **@** `skills/<name>/SKILL.md` in chat, or paste a raw GitHub `SKILL.md` URL.

## Contribute a skill

Add `skills/<name>/SKILL.md` (YAML `name` + `description`). Optional `references/`. Update the table. MIT — [LICENSE](LICENSE).
