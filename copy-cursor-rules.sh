#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository URL
REPO_URL="https://github.com/tekdi/tekdi-cursor-rules.git"

# Create temporary directory for cloning
TMP_DIR=$(mktemp -d)
SCRIPT_DIR="$TMP_DIR/tekdi-cursor-rules"

# Cleanup function
cleanup() {
    if [[ -d "$TMP_DIR" ]]; then
        print_info "Cleaning up temporary directory..."
        rm -rf "$TMP_DIR"
    fi
}

# Set trap to cleanup on exit (ensure temporary files are removed even if script is interrupted)
trap cleanup EXIT

# Function to print colored output
print_info() {
    printf "${BLUE}[INFO] %s${NC}\n" "$1"
}

print_success() {
    printf "${GREEN}[SUCCESS] %s${NC}\n" "$1"
}

print_warning() {
    printf "${YELLOW}[WARNING] %s${NC}\n" "$1"
}

print_error() {
    printf "${RED}[ERROR] %s${NC}\n" "$1"
}

# Function to validate directory path
validate_path() {
    local path="$1"
    if [[ ! -d "$path" ]]; then
        print_error "Directory '$path' does not exist."
        return 1
    fi
    return 0
}

# Function to clone the repository
clone_repository() {
    print_info "Cloning tekdi-cursor-rules repository..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install git to use this script."
        exit 1
    fi
    
    # Clone the repository
    if git clone "$REPO_URL" "$SCRIPT_DIR" &> /dev/null; then
        print_success "Repository cloned successfully to temporary directory"
    else
        print_error "Failed to clone repository from $REPO_URL"
        print_error "Please check your internet connection and try again."
        exit 1
    fi
}

# Function to get repository path
get_repo_path() {
    while true; do
        echo
        print_info "Enter the path of the repository where you want to copy cursor rules:"
        read -r repo_path
        
        # Expand tilde to home directory
        repo_path="${repo_path/#\~/$HOME}"
        
        # Convert to absolute path
        repo_path="$(cd "$repo_path" 2>/dev/null && pwd)"
        
        if validate_path "$repo_path"; then
            return 0
        fi
        
        print_warning "Please enter a valid directory path."
    done
}

# Function to get project type (backend/frontend)
get_project_type() {
    while true; do
        echo
        print_info "Is this a backend or frontend repository?"
        echo "1) backend"
        echo "2) frontend"
        read -r choice
        
        case $choice in
            1|backend|Backend|BACKEND)
                project_type="backend"
                return 0
                ;;
            2|frontend|Frontend|FRONTEND)
                project_type="frontend"
                return 0
                ;;
            *)
                print_error "Invalid input. Please enter 'backend' or 'frontend' (or 1/2)."
                ;;
        esac
    done
}

# Function to get language
get_language() {
    local proj_type="$1"
    
    while true; do
        echo
        print_info "Which programming language are you using?"
        
        if [[ "$proj_type" == "backend" ]]; then
            echo "Supported languages: java, php, python, nodejs"
        else
            echo "Supported languages: javascript, html, css"
        fi
        
        read -r language
        
        case $language in
            java|php|python|nodejs|javascript|html|css)
                return 0
                ;;
            *)
                print_error "Invalid language. Please enter one of the supported languages."
                ;;
        esac
    done
}

# Function to get framework
get_framework() {
    local proj_type="$1"
    local lang="$2"
    
    echo
    print_info "Which framework are you using? (Press Enter to skip if not using any specific framework)"
    
    # Show available frameworks based on project type and language
    if [[ "$proj_type" == "backend" ]]; then
        case $lang in
            nodejs)
                echo "Available frameworks: nestjs"
                ;;
            python)
                echo "Available frameworks: fastapi, django"
                ;;
            *)
                echo "Available frameworks: (framework-specific rules may not be available)"
                ;;
        esac
    else
        case $lang in
            javascript)
                echo "Available frameworks: reactjs, angular"
                ;;
            *)
                echo "Available frameworks: (framework-specific rules may not be available)"
                ;;
        esac
    fi
    
    read -r framework
}

# Function to backup existing file if it exists
backup_file_if_exists() {
    local dest_file="$1"
    local backup_dir="$2"
    
    if [[ -f "$dest_file" ]]; then
        local filename=$(basename "$dest_file")
        mkdir -p "$backup_dir"
        cp "$dest_file" "$backup_dir/"
        print_info "Backed up existing file: $filename"
        return 0
    fi
    return 1
}

# Function to copy files matching pattern
copy_files_matching() {
    local source_dir="$1"
    local dest_dir="$2"
    local pattern="$3"
    local description="$4"
    
    if [[ ! -d "$source_dir" ]]; then
        print_warning "Source directory '$source_dir' not found, skipping $description"
        return
    fi
    
    local files_found=false
    
    # Find files matching the pattern
    while IFS= read -r file; do
        if [[ -f "$file" && ! "$file" =~ \.DS_Store$ && ! "$file" =~ \.gitkeep$ ]]; then
            local dest_file="$dest_dir/$(basename "$file")"
            backup_file_if_exists "$dest_file" "$backup_dir"
            cp "$file" "$dest_dir/"
            print_success "Copied $(basename "$file")"
            files_found=true
        fi
    done <<< "$(find "$source_dir" -name "*$pattern*" -type f)"
    
    if [[ "$files_found" == false ]]; then
        print_warning "No files found matching pattern '$pattern' in $source_dir"
    fi
}

# Function to copy all files from directory
copy_all_files() {
    local source_dir="$1"
    local dest_dir="$2"
    local description="$3"
    
    if [[ ! -d "$source_dir" ]]; then
        print_warning "Source directory '$source_dir' not found, skipping $description"
        return
    fi
    
    local files_found=false
    
    # Copy all files (excluding .DS_Store and .gitkeep)
    for file in "$source_dir"/*; do
        if [[ -f "$file" && ! "$file" =~ \.DS_Store$ && ! "$file" =~ \.gitkeep$ ]]; then
            local dest_file="$dest_dir/$(basename "$file")"
            backup_file_if_exists "$dest_file" "$backup_dir"
            cp "$file" "$dest_dir/"
            print_success "Copied $(basename "$file")"
            files_found=true
        fi
    done
    
    if [[ "$files_found" == false ]]; then
        print_warning "No files found in $source_dir"
    fi
}

# Main function
main() {
    echo
    print_info "=== Cursor Rules Copy Script ==="
    print_info "This script will clone the tekdi-cursor-rules repository and copy the appropriate rules to your project."
    
    # Clone the repository first
    clone_repository
    
    # Get user inputs
    get_repo_path
    get_project_type
    get_language "$project_type"
    get_framework "$project_type" "$language"
    
    # Create destination directory
    dest_dir="$repo_path/.cursor/rules"
    mkdir -p "$dest_dir"
    
    # Create backup directory with timestamp
    backup_timestamp=$(date +"%Y%m%d_%H%M%S")
    backup_dir="$repo_path/.cursor_rule_backup_$backup_timestamp"
    
    print_info "Destination directory: $dest_dir"
    print_info "Backup directory (if needed): $backup_dir"
    
    echo
    print_info "Starting file copy process"
    
    # 1. Copy all files from 1-tekdi folder
    echo
    print_info "1. Copying Tekdi common rules..."
    copy_all_files "$SCRIPT_DIR/1-tekdi" "$dest_dir" "Tekdi common rules"
    
    # 2. Copy files from 2-common folder based on project type
    echo
    print_info "2. Copying common $project_type rules..."
    copy_files_matching "$SCRIPT_DIR/2-common" "$dest_dir" "$project_type" "common $project_type rules"
    
    # 3. Copy files from appropriate folder based on project type and language
    echo
    print_info "3. Copying $language rules for $project_type..."
    
    if [[ "$project_type" == "backend" ]]; then
        # Copy general backend files matching language
        # copy_files_matching "$SCRIPT_DIR/5-backend" "$dest_dir" "$language" "backend $language rules"
        copy_files_matching "$SCRIPT_DIR/5-backend" "$dest_dir" "backend" "backend $language rules"

        # Copy language-specific files
        if [[ "$language" == "nodejs" ]]; then
            copy_all_files "$SCRIPT_DIR/5-backend/nodejs" "$dest_dir" "NodeJS backend rules"
            
            # Copy framework-specific files
            if [[ -n "$framework" ]]; then
                copy_all_files "$SCRIPT_DIR/5-backend/nodejs/$framework" "$dest_dir" "$framework framework rules"
            fi
        elif [[ "$language" == "python" ]]; then
            copy_all_files "$SCRIPT_DIR/5-backend/python" "$dest_dir" "Python backend rules"
            
            # Copy framework-specific files
            if [[ -n "$framework" ]]; then
                copy_all_files "$SCRIPT_DIR/5-backend/python/$framework" "$dest_dir" "$framework framework rules"
            fi
        fi
    else
        # Frontend
        #copy_files_matching "$SCRIPT_DIR/4-frontend" "$dest_dir" "$language" "frontend $language rules"
        copy_files_matching "$SCRIPT_DIR/4-frontend" "$dest_dir" "frontend" "frontend $language rules"

        
        # Copy language-specific files
        if [[ "$language" == "javascript" ]]; then
            if [[ -n "$framework" ]]; then
                copy_all_files "$SCRIPT_DIR/4-frontend/$framework" "$dest_dir" "$framework framework rules"
            fi
        elif [[ -d "$SCRIPT_DIR/4-frontend/$language" ]]; then
            copy_all_files "$SCRIPT_DIR/4-frontend/$language" "$dest_dir" "$language frontend rules"
        fi
    fi
    
    echo
    print_success "=== Copy process completed! ==="
    print_info "Rules have been copied to: $dest_dir"
    print_info "You can now use these cursor rules in your project."
    print_info "Temporary files will be cleaned up automatically."
    
    # Show summary
    echo
    print_info "=== Summary ==="
    print_info "Repository: $repo_path"
    print_info "Project Type: $project_type"
    print_info "Language: $language"
    if [[ -n "$framework" ]]; then
        print_info "Framework: $framework"
    fi
    
    # Count copied files
    file_count=$(find "$dest_dir" -type f | wc -l)
    print_info "Total files copied: $file_count"
    
    # Show backup information if backup directory exists
    if [[ -d "$backup_dir" ]]; then
        backup_count=$(find "$backup_dir" -type f | wc -l)
        print_info "Files backed up: $backup_count (in $backup_dir)"
    else
        print_info "No existing files were backed up"
    fi
}

# Run the main function
main "$@" 