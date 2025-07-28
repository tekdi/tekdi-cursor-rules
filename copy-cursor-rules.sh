#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository URL
REPO_URL="https://github.com/tekdi/tekdi-cursor-rules.git"

# Global variables
DEBUG_MODE=false
SCRIPT_DIR=""

# Create temporary directory for cloning (only if not in debug mode)
TMP_DIR=""

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --debug|-d)
                DEBUG_MODE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --debug, -d    Enable debug mode (use local files instead of cloning)"
    echo "  --help, -h     Show this help message"
    echo ""
    echo "Debug mode:"
    echo "  When debug mode is enabled, the script will use the local repository"
    echo "  files instead of cloning from GitHub. Make sure you have the"
    echo "  tekdi-cursor-rules repository cloned locally in the same directory"
    echo "  as this script."
}

# Initialize directories based on mode
initialize_directories() {
    if [[ "$DEBUG_MODE" == true ]]; then
        print_info "Debug mode enabled - using local files"
        # Use local directory (assume script is in the repository or adjacent to it)
        local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        
        # Check if we're inside the repository
        if [[ -d "$current_dir/1-tekdi" ]]; then
            SCRIPT_DIR="$current_dir"
        # Check if repository is in the same parent directory
        elif [[ -d "$current_dir/tekdi-cursor-rules" ]]; then
            SCRIPT_DIR="$current_dir/tekdi-cursor-rules"
        # Check if we're in a parent directory and repository is a subdirectory
        elif [[ -d "$current_dir/../tekdi-cursor-rules" ]]; then
            SCRIPT_DIR="$(cd "$current_dir/../tekdi-cursor-rules" && pwd)"
        else
            print_error "Local repository not found. Please ensure tekdi-cursor-rules repository is available locally."
            print_error "Expected locations:"
            print_error "  - Current directory: $current_dir"
            print_error "  - Sibling directory: $current_dir/tekdi-cursor-rules"
            print_error "  - Parent directory: $current_dir/../tekdi-cursor-rules"
            exit 1
        fi
        
        print_success "Using local repository at: $SCRIPT_DIR"
    else
        # Create temporary directory for cloning
        TMP_DIR=$(mktemp -d)
        SCRIPT_DIR="$TMP_DIR/tekdi-cursor-rules"
    fi
}

# Cleanup function
cleanup() {
    if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
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
    if [[ "$DEBUG_MODE" == true ]]; then
        print_info "Debug mode: Skipping repository clone, using local files"
        return 0
    fi
    
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
        print_info "Is this a backend, frontend, or mobile-app repository?"
        echo "1) backend"
        echo "2) frontend"
        echo "3) mobile-app"
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
            3|mobile-app|mobile-app|Mobile-app|Mobile-app|MOBILE-APP|MOBILE-APP)
                project_type="mobile-app"
                return 0
                ;;
            *)
                print_error "Invalid input. Please enter 'backend', 'frontend', or 'mobile-app' (or 1/2/3)."
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
            echo "1) java"
            echo "2) php" 
            echo "3) python"
            echo "4) nodejs"
        elif [[ "$proj_type" == "mobile-app" ]]; then
            echo "1) kotlin"
            echo "2) swift"
            echo "3) dart"
            echo "4) javascript"
        else
            echo "1) javascript"
            echo "2) html"
            echo "3) css"
        fi
        
        read -r language_input
        
        if [[ "$proj_type" == "backend" ]]; then
            case $language_input in
                1|java|Java|JAVA)
                    language="java"
                    return 0
                    ;;
                2|php|PHP|Php)
                    language="php"
                    return 0
                    ;;
                3|python|Python|PYTHON)
                    language="python"
                    return 0
                    ;;
                4|nodejs|node|Node|NodeJS|NODE|NODEJS)
                    language="nodejs"
                    return 0
                    ;;
                *)
                    print_error "Invalid language. Please enter a number (1-4) or one of: java, php, python, nodejs"
                    ;;
            esac
        elif [[ "$proj_type" == "mobile-app" ]]; then
            case $language_input in
                1|kotlin|Kotlin|KOTLIN)
                    language="kotlin"
                    return 0
                    ;;
                2|swift|Swift|SWIFT)
                    language="swift"
                    return 0
                    ;;
                3|dart|Dart|DART)
                    language="dart"
                    return 0
                    ;;
                4|javascript|js|JavaScript|JS|JAVASCRIPT)
                    language="javascript"
                    return 0
                    ;;
                *)
                    print_error "Invalid language. Please enter a number (1-4) or one of: kotlin, swift, dart, javascript"
                    ;;
            esac
        else
            case $language_input in
                1|javascript|js|JavaScript|JS|JAVASCRIPT)
                    language="javascript"
                    return 0
                    ;;
                2|html|HTML|Html)
                    language="html"
                    return 0
                    ;;
                3|css|CSS|Css)
                    language="css"
                    return 0
                    ;;
                *)
                    print_error "Invalid language. Please enter a number (1-3) or one of: javascript, html, css"
                    ;;
            esac
        fi
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
                echo "Available frameworks:"
                echo "1) nestjs"
                ;;
            python)
                echo "Available frameworks:"
                echo "1) fastapi"
                echo "2) django"
                ;;
            *)
                echo "Available frameworks: (framework-specific rules may not be available)"
                ;;
        esac
    elif [[ "$proj_type" == "mobile-app" ]]; then
        case $lang in
            javascript)
                echo "Available frameworks:"
                echo "1) react-native"
                echo "2) ionic"
                ;;
            dart)
                echo "Available frameworks:"
                echo "1) flutter"
                ;;
            kotlin)
                echo "Available frameworks:"
                echo "1) android-native"
                echo "2) compose"
                ;;
            swift)
                echo "Available frameworks:"
                echo "1) ios-native"
                echo "2) swiftui"
                ;;
            *)
                echo "Available frameworks: (framework-specific rules may not be available)"
                ;;
        esac
    else
        case $lang in
            javascript)
                echo "Available frameworks:"
                echo "1) reactjs"
                echo "2) angular"
                ;;
            *)
                echo "Available frameworks: (framework-specific rules may not be available)"
                ;;
        esac
    fi
    
    read -r framework_input
    
    # Handle framework selection based on project type and language
    if [[ "$proj_type" == "backend" ]]; then
        case $lang in
            nodejs)
                case $framework_input in
                    1|nestjs|NestJS|NESTJS)
                        framework="nestjs"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            python)
                case $framework_input in
                    1|fastapi|FastAPI|FASTAPI)
                        framework="fastapi"
                        ;;
                    2|django|Django|DJANGO)
                        framework="django"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            *)
                framework="$framework_input"
                ;;
        esac
    elif [[ "$proj_type" == "mobile-app" ]]; then
        case $lang in
            javascript)
                case $framework_input in
                    1|react-native|react_native|React-Native|React_Native|REACT-NATIVE|REACT_NATIVE)
                        framework="react-native"
                        ;;
                    2|ionic|Ionic|IONIC)
                        framework="ionic"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            dart)
                case $framework_input in
                    1|flutter|Flutter|FLUTTER)
                        framework="flutter"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            kotlin)
                case $framework_input in
                    1|android-native|android_native|Android-Native|Android_Native|ANDROID-NATIVE|ANDROID_NATIVE)
                        framework="android-native"
                        ;;
                    2|compose|Compose|COMPOSE)
                        framework="compose"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            swift)
                case $framework_input in
                    1|ios-native|ios_native|iOS-Native|iOS_Native|IOS-NATIVE|IOS_NATIVE)
                        framework="ios-native"
                        ;;
                    2|swiftui|SwiftUI|SWIFTUI)
                        framework="swiftui"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            *)
                framework="$framework_input"
                ;;
        esac
    else
        # Frontend
        case $lang in
            javascript)
                case $framework_input in
                    1|reactjs|react|React|ReactJS|REACT|REACTJS)
                        framework="reactjs"
                        ;;
                    2|angular|Angular|ANGULAR)
                        framework="angular"
                        ;;
                    3|react-native|react_native|React-Native|React_Native|REACT-NATIVE|REACT_NATIVE)
                        framework="react-native"
                        ;;
                    "")
                        framework=""
                        ;;
                    *)
                        framework="$framework_input"
                        ;;
                esac
                ;;
            *)
                framework="$framework_input"
                ;;
        esac
    fi
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
    # Parse command line arguments first
    parse_arguments "$@"
    
    echo
    print_info "=== Cursor Rules Copy Script ==="
    if [[ "$DEBUG_MODE" == true ]]; then
        print_info "Running in DEBUG MODE - using local files"
    fi
    print_info "This script will copy the appropriate cursor rules to your project."
    
    # Initialize directories based on mode
    initialize_directories
    
    # Clone the repository (or skip if debug mode)
    clone_repository
    
    # Validate that the script directory exists and has the expected structure
    if [[ ! -d "$SCRIPT_DIR/1-tekdi" ]]; then
        print_error "Repository structure invalid. Missing '1-tekdi' directory."
        print_error "Script directory: $SCRIPT_DIR"
        exit 1
    fi
    
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
    if [[ "$DEBUG_MODE" == true ]]; then
        print_info "Source directory: $SCRIPT_DIR"
    fi
    
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
    elif [[ "$project_type" == "mobile-app" ]]; then
        # Copy general mobile-app files
        copy_files_matching "$SCRIPT_DIR/6-mobile-app" "$dest_dir" "mobile-app" "mobile-app $language rules"
        
        # Copy language-specific files
        if [[ "$language" == "javascript" ]]; then
            copy_all_files "$SCRIPT_DIR/6-mobile-app/javascript" "$dest_dir" "JavaScript mobile-app rules"
            
            # Copy framework-specific files
            if [[ -n "$framework" ]]; then
                if [[ "$framework" == "react-native" || "$framework" == "ionic" ]]; then
                    # For React Native: copy from both hybrid-frontend and react-native folders
                    echo
                    print_info "Processing React Native framework..."
                    print_info "Copying hybrid-frontend rules for React Native..."
                    copy_all_files "$SCRIPT_DIR/6-mobile-app/javascript/hybrid-frontend" "$dest_dir" "hybrid-frontend rules"
                fi
                print_info "Copying $framework specific rules..."
                copy_all_files "$SCRIPT_DIR/6-mobile-app/javascript/$framework" "$dest_dir" "$framework framework rules"
            else
                print_info "No framework specified, skipping framework-specific rules."
            fi
        elif [[ "$language" == "dart" ]]; then
            copy_all_files "$SCRIPT_DIR/6-mobile-app/dart" "$dest_dir" "Dart mobile-app rules"
            
            # Copy framework-specific files
            if [[ -n "$framework" ]]; then
                copy_all_files "$SCRIPT_DIR/6-mobile-app/dart/$framework" "$dest_dir" "$framework framework rules"
            fi
        elif [[ "$language" == "kotlin" ]]; then
            copy_all_files "$SCRIPT_DIR/6-mobile-app/kotlin" "$dest_dir" "Kotlin mobile-app rules"
            
            # Copy framework-specific files
            if [[ -n "$framework" ]]; then
                copy_all_files "$SCRIPT_DIR/6-mobile-app/kotlin/$framework" "$dest_dir" "$framework framework rules"
            fi
        elif [[ "$language" == "swift" ]]; then
            copy_all_files "$SCRIPT_DIR/6-mobile-app/swift" "$dest_dir" "Swift mobile-app rules"
            
            # Copy framework-specific files
            if [[ -n "$framework" ]]; then
                copy_all_files "$SCRIPT_DIR/6-mobile-app/swift/$framework" "$dest_dir" "$framework framework rules"
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
    if [[ "$DEBUG_MODE" == false ]]; then
        print_info "Temporary files will be cleaned up automatically."
    fi
    
    # Show summary
    echo
    print_info "=== Summary ==="
    print_info "Mode: $([ "$DEBUG_MODE" == true ] && echo "DEBUG (local files)" || echo "NORMAL (cloned repository)")"
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

# Run the main function with all arguments
main "$@" 