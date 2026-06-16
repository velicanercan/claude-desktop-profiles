# Claude Desktop Profiles

Run fully isolated **Work** and **Personal** Claude Desktop profiles on macOS.

> **TL;DR**
>
> Claude Desktop currently supports a single local profile.
>
> This guide shows how to create multiple isolated profiles by separating:
>
> - Claude Desktop application data
> - Claude Code configuration (`CLAUDE_CONFIG_DIR`)
> - Claude Code history
> - Cowork history

---

## Tested With

- macOS
- Claude Desktop
- Claude Code

### Tested Launchers

| Launcher | Status |
|----------|--------|
| Parall | ✅ Tested |
| Others | ⚪ Should work (manual setup required) |

> This guide uses **Parall** as an example because it supports isolated application data and custom environment variables.
>
> The concepts described here are launcher-agnostic and should work with any launcher that provides similar capabilities.

---

# Architecture

```text
Claude Work
├── Application Support
└── CLAUDE_CONFIG_DIR
    └── ~/AI-Profiles/Work/.claude

Claude Personal
├── Application Support
└── CLAUDE_CONFIG_DIR
    └── ~/AI-Profiles/Personal/.claude
```

---

## Step 1

Create separate Claude Code configuration directories.

```bash
mkdir -p ~/AI-Profiles/Work/.claude
mkdir -p ~/AI-Profiles/Personal/.claude
```

---

## Step 2

Copy your existing Claude Code configuration.

```bash
cp -R ~/.claude ~/AI-Profiles/Work/.claude

cp -R ~/.claude ~/AI-Profiles/Personal/.claude
```

---

## Step 3

Configure your launcher.

Work

```text
CLAUDE_CONFIG_DIR=/Users/YOUR_USER/AI-Profiles/Work/.claude
```

Personal

```text
CLAUDE_CONFIG_DIR=/Users/YOUR_USER/AI-Profiles/Personal/.claude
```

Verify inside Claude Code:

```bash
echo "$CLAUDE_CONFIG_DIR"
```

---

## Step 4 (Optional)

### Migrate Claude Code History

Close every Claude Desktop instance.

Replace the destination `claude-code-sessions` directory.

```bash
rm -rf \
"$HOME/Library/Application Support/Parall/Claude Work/claude-code-sessions"

cp -R \
"$HOME/Library/Application Support/Claude/claude-code-sessions" \
"$HOME/Library/Application Support/Parall/Claude Work/"
```

Launch Claude Desktop again.

Your previous conversations should now appear in the **Code** tab.

---

## Step 5 (Optional)

### Migrate Cowork History

Cowork history is stored separately from Claude Code.

Typical directory structure:

```text
local-agent-mode-sessions
└── <ACCOUNT_ID>
    └── <PROFILE_ID>
        ├── spaces/
        ├── spaces.json
        ├── local_*
        ├── local_*.json
        ├── cowork-clientdata-cache.json
        └── cowork-gb-cache.json
```

The most important files are:

- `spaces/`
- `spaces.json`
- `local_*`
- `local_*.json`

Example:

```bash
SRC="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/<ACCOUNT_ID>/<PROFILE_ID>"

DST="$HOME/Library/Application Support/Parall/Claude Work/local-agent-mode-sessions/<ACCOUNT_ID>/<PROFILE_ID>"

cp -R "$SRC/spaces" "$DST/"
cp "$SRC/spaces.json" "$DST/"
cp -R "$SRC"/local_* "$DST/"
```

Launch Claude Desktop again.

Your previous Cowork workspaces and history should now appear in the **Cowork** tab.

---

# Optional: Migration Script (Parall)

If you're using **Parall**, this repository includes a helper script that automates the migration process described above.

```bash
./scripts/parall-migrate.sh
```

The script currently targets Parall's default directory structure.

If you're using another launcher, simply follow the manual migration steps above or use the script as a reference and adapt it to your own launcher.

---

# Storage Reference

| Component | Purpose |
|-----------|---------|
| `CLAUDE_CONFIG_DIR` | Claude Code configuration |
| `projects/` | Memories |
| `plans/` | Plans |
| `tasks/` | Tasks |
| `skills/` | Skills |
| `claude-code-sessions` | Code history |
| `local-agent-mode-sessions` | Cowork history |
| `spaces.json` | Cowork workspaces |

---

# Do Not Copy

Unless you know exactly why, avoid copying:

- Cookies
- IndexedDB
- Local Storage
- Session Storage
- claude-code
- claude-code-vm
- vm_bundles
- Cache

These directories primarily contain login state, caches, or runtime binaries and are not required for normal profile migration.

---

# Credits

This guide was created by reverse engineering Claude Desktop's local storage on macOS and validating each migration step experimentally.

If you discover changes in future Claude Desktop releases or test additional launchers, contributions are welcome.