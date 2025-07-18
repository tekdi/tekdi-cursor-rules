# Cursor Rules

This repository contains standardized cursor rules for Tekdi projects, organized by technology stack and framework.

##  Setup Instructions

### Prerequisites

- Git installed on your system
- Bash shell (available on macOS, Linux, and Windows with WSL/Git Bash)
- Internet connection to clone the repository

### Running the Script

1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/tekdi/tekdi-cursor-rules/main/copy-cursor-rules.sh
   ```
   or
   ```bash
   curl -O https://raw.githubusercontent.com/tekdi/tekdi-cursor-rules/main/copy-cursor-rules.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x copy-cursor-rules.sh
   ```

3. **Run the script:**
   ```bash
   ./copy-cursor-rules.sh
   ```

### What the Script Does

The script will:
1. Clone this repository to a temporary directory
2. Ask you for your project's directory path
3. Prompt you to select:
   - Project type (backend/frontend)
   - Programming language
   - Framework (if applicable)
4. Copy the appropriate cursor rules to your project's `.cursor/rules` directory
5. Create backups of any existing rules
6. Clean up temporary files automatically

### Interactive Prompts

The script will guide you through several prompts:

**Project Path:**
```
Enter the path of the repository where you want to copy cursor rules:
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
$ ./copy-cursor-rules.sh

[INFO] === Cursor Rules Copy Script ===
[INFO] This script will clone the tekdi-cursor-rules repository and copy the appropriate rules to your project.
[INFO] Cloning tekdi-cursor-rules repository...
[SUCCESS] Repository cloned successfully to temporary directory

[INFO] Enter the path of the repository where you want to copy cursor rules:
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

### File Organization

The script copies rules in the following order:
1. **Tekdi common rules** (from `1-tekdi/`)
2. **Project type rules** (from `2-common/`)
3. **Language-specific rules** (from `4-frontend/` or `5-backend/`)
4. **Framework-specific rules** (if applicable)

### Backup and Safety

- Existing cursor rules are automatically backed up to `.cursor_rule_backup_[timestamp]`
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
├── 1-tekdi/              # Common Tekdi rules
├── 2-common/             # Backend/Frontend common rules
├── 3-products/           # Product-specific rules
├── 4-frontend/           # Frontend language/framework rules
├── 5-backend/            # Backend language/framework rules
└── copy-cursor-rules.sh  # Automated setup script
```

## Cursor Guide
Learn more how to use these rules selectively 
- [Frontend Rules Usage Guide](docs/frontend-cursor-rules-guide.md)
- [Backend Rules Usage Guide](docs/backend-cursor-rules-guide.md)

## Contributing

To add new rules or modify existing ones:
1. Fork this repository
2. Create a new branch for your changes
3. Add your cursor rules in the appropriate directory
4. Submit a pull request

## Support

For issues or questions:
- Create an issue in this repository
- Contact the Tekdi development team
