# Editor Rules

This repository contains standardized editor rules for Tekdi projects, organized by technology stack and framework. Rules are available for both **Cursor** and **Antigravity** editors.

## Setup Instructions

### Prerequisites

- Git installed on your system
- Bash shell (available on macOS, Linux, and Windows with WSL/Git Bash)
- Internet connection to clone the repository

### Running the Script

1. **Download the script:**

   ```bash
   wget https://raw.githubusercontent.com/tekdi/tekdi-cursor-rules/main/copy-editor-rules.sh
   ```

   or

   ```bash
   curl -O https://raw.githubusercontent.com/tekdi/tekdi-cursor-rules/main/copy-editor-rules.sh
   ```

2. **Make it executable:**

   ```bash
   chmod +x copy-editor-rules.sh
   ```

3. **Run the script:**
   ```bash
   ./copy-editor-rules.sh
   ```

### What the Script Does

The script will:

1. Clone this repository to a temporary directory
2. Ask you to select your **editor** (cursor or antigravity)
3. Ask you for your project's directory path
4. Prompt you to select:
   - Project type (backend/frontend)
   - Programming language
   - Framework (if applicable)
5. Copy the appropriate rules to your project's rules directory
6. Create backups of any existing rules
7. Clean up temporary files automatically

### Interactive Prompts

The script will guide you through several prompts:

**Editor Selection:**

```
Which editor are you setting up rules for?
1) cursor
2) antigravity
```

**Project Path:**

```
Enter the path of the repository where you want to copy editor rules:
/path/to/your/project
```

**Project Type:**

```
Is this a backend or frontend repository?
1) backend
2) frontend
```

**Language Selection:**

- **Backend:** java, php, python, nodejs
- **Frontend:** javascript, html, css

**Framework Selection (optional):**

- **Backend Node.js:** nestjs
- **Backend Python:** fastapi, django
- **Frontend JavaScript:** reactjs, angular

### Example Usage

```bash
$ ./copy-editor-rules.sh

[INFO] === Editor Rules Copy Script ===
[INFO] This script will clone the tekdi-cursor-rules repository and copy the appropriate rules to your project.
[INFO] Cloning tekdi-cursor-rules repository...
[SUCCESS] Repository cloned successfully to temporary directory

[INFO] Which editor are you setting up rules for?
1) cursor
2) antigravity
1

[INFO] Enter the path of the repository where you want to copy editor rules:
/Users/developer/my-project

[INFO] Is this a backend or frontend repository?
1) backend
2) frontend
1

[INFO] Which programming language are you using?
Supported languages: java, php, python, nodejs
nodejs

[INFO] Which framework are you using? (Press Enter to skip if not using any specific framework)
Available frameworks: nestjs
nestjs

[INFO] Destination directory: /Users/developer/my-project/.cursor/rules
[INFO] Starting file copy process

[SUCCESS] === Copy process completed! ===
[INFO] Rules have been copied to: /Users/developer/my-project/.cursor/rules
[INFO] Total files copied: 12
```

### Destination Directories

| Editor      | Destination              |
| ----------- | ------------------------ |
| cursor      | `$PROJECT/.cursor/rules` |
| antigravity | `$PROJECT/.agent/rules`  |

### File Organization

The script copies rules in the following order:

1. **Tekdi common rules** (from `cursor-rules/1-tekdi/`)
2. **Project type rules** (from `cursor-rules/2-common/`)
3. **Product rules** (from `cursor-rules/3-products/`)
4. **Language & framework-specific rules**:
   - **cursor**: copied from `cursor-rules/4-frontend/` or `cursor-rules/5-backend/`
   - **antigravity**: copied from `antigravity-rules/4-frontend/` or `antigravity-rules/5-backend/`

### Backup and Safety

- Existing rules are automatically backed up to `.editor_rule_backup_[timestamp]`
- The script validates all paths before making changes
- Temporary files are cleaned up automatically, even if the script is interrupted

### Troubleshooting

**Git not found:**

```
[ERROR] Git is not installed. Please install git to use this script.
```

Install Git from [git-scm.com](https://git-scm.com/)

**Network issues:**

```
[ERROR] Failed to clone repository from https://github.com/tekdi/tekdi-cursor-rules.git
```

Check your internet connection and try again.

**Invalid directory:**

```
[ERROR] Directory '/path/to/project' does not exist.
```

Ensure the directory path exists and is accessible.

### Repository Structure

```
tekdi-cursor-rules/
├── cursor-rules/         # Rules for Cursor editor
│   ├── 1-tekdi/          # Common Tekdi rules
│   ├── 2-common/         # Backend/Frontend common rules
│   ├── 3-products/       # Product-specific rules
│   ├── 4-frontend/       # Frontend language/framework rules
│   └── 5-backend/        # Backend language/framework rules
├── antigravity-rules/    # Editor-specific rules for Antigravity
│   ├── 4-frontend/       # Frontend language/framework rules
│   └── 5-backend/        # Backend language/framework rules
└── copy-editor-rules.sh  # Automated setup script
```

## Editor Rules Usage Guide

Learn more how to use these rules selectively

- [Frontend Rules Usage Guide](docs/frontend-cursor-rules-guide.md)
- [Backend Rules Usage Guide](docs/backend-cursor-rules-guide.md)

## Claude Skills & Subagents

This repository also ships reusable **Claude Code** skills (`claude-skills/`) and subagents
(`claude-subagents/`) for feature development, requirement-to-task planning, code review, and QA
testing. They ship stack-agnostic — each one only becomes specific to *your* product's codebase
after you run it through the **`update-skill-subagent`** subagent
(`claude-subagents/update-skill-subagent.md`), which reads your repo's actual conventions (via an
existing LLM-native wiki at `docs/wiki/<service>/` if one exists, or a direct repo scan otherwise)
and rewrites the target skill/subagent in place to match.

Copy `claude-skills/` and `claude-subagents/` into your project (e.g. under `.claude/skills/` and
`.claude/agents/`), then ask Claude Code to tailor each one to your stack before first use.

### 1. `brd-task-creator`

Turns a business requirement into a reviewed plan and a task list of user stories/acceptance
criteria/test plans, grounded in your repo's actual routing, data, and integration conventions.

```
Update the brd-task-creator skill to suit the tech stack of this codebase.
```

Once tailored, use it directly on a requirement:

```
Use brd-task-creator to turn this requirement into a task list:
"Allow a project owner to invite a collaborator by email."
```

### 2. `fullstack-developer`

Guides a feature from data layer → route/API layer → integration layer → frontend, following the
conventions your codebase actually uses instead of generic framework advice.

```
Update the fullstack-developer skill to suit the tech stack of this codebase.
```

Once tailored:

```
Use fullstack-developer to add a "resend invite" endpoint and wire it into the collaborators page.
```

### 3. `code-reviewer`

Reviews your pending diff against this repo's own conventions (auth pattern, data-layer
conventions, integration retry pattern, frontend approach) before you raise a PR. Read-only —
reports findings, doesn't edit files.

```
Update the code-reviewer subagent to suit the tech stack of this codebase.
```

Once tailored:

```
Run code-reviewer on my current diff before I raise this PR.
```

### 4. `qa-tester`

Writes and actually runs test cases — happy path, negative, boundary, auth, error-handling — for a
change, using whatever test framework and mocking style your repo already has, and reports real
pass/fail results plus coverage gaps.

```
Update the qa-tester subagent to suit the tech stack of this codebase.
```

Once tailored:

```
Use qa-tester to test the "resend invite" endpoint I just added.
```

### Notes

- Run `update-skill-subagent` once per skill/subagent per repo (or again after a stack migration).
  It reuses findings from any sibling skill/subagent already tailored in the same repo, so tailoring
  the second, third, and fourth one is faster than the first.
- If it can't find `docs/wiki/<service>/`, it will ask whether to generate one first (e.g. via an
  `llm-wiki`-style skill) or proceed with a direct repo scan — it won't silently guess.
- It reports what it could **not** confirm as an explicit gap rather than fabricating a convention.

## Contributing

To add new rules or modify existing ones:

1. Fork this repository
2. Create a new branch for your changes
3. Add your editor rules in the appropriate directory
4. Submit a pull request

## Support

For issues or questions:

- Create an issue in this repository
- Contact the Tekdi development team
