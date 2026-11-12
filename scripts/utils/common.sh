#!/usr/bin/env bash

readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_NC='\033[0m'

# These are initialized in the calling scripts but used by shared functions:
# DRY_RUN - boolean for dry-run mode
# REPO_ROOT - root directory of the repository
# SELECTED_IMAGES - array of selected images
# IMAGE_PATHS - associative array mapping image names to directories
# BATCH_GOLANG - global for batch golang updates

# log_info: Print cyan info message | $1: message
log_info() {
    echo -e "${COLOR_CYAN}ℹ ${1}${COLOR_NC}"
}

# log_success: Print green success message | $1: message
log_success() {
    echo -e "${COLOR_GREEN}✓ ${1}${COLOR_NC}"
}

# log_error: Print red error message | $1: message
log_error() {
    echo -e "${COLOR_RED}✗ ${1}${COLOR_NC}"
}

# log_warning: Print yellow warning message | $1: message
log_warning() {
    echo -e "${COLOR_YELLOW}⚠ ${1}${COLOR_NC}"
}

# check_dependencies: Verify required tools are installed | $@: space-separated tool names
check_dependencies() {
    local deps=("$@")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Please install the missing dependencies and try again."
        exit 1
    fi
    
    log_success "All required dependencies are installed"
}

# discover_images: Find all Docker images with tag-config.yaml files
discover_images() {
    log_info "Discovering Docker images..."
    
    local count=0
    while IFS= read -r config_file; do
        local image_dir=$(dirname "$config_file")
        local image_name="${image_dir#$REPO_ROOT/}"
        local component_count=$(yq eval '.components | length' "$config_file" 2>/dev/null)
        # Validate component_count is a number before comparison
        if [[ "$component_count" =~ ^[0-9]+$ ]] && [[ "$component_count" -gt 0 ]]; then
            IMAGE_PATHS[$image_name]="$image_dir"
            ((count++))
        fi
    done < <(find "$REPO_ROOT" -name "tag-config.yaml" -type f | sort)
    
    if [[ $count -eq 0 ]]; then
        log_error "No tag-config.yaml files with components found!"
        exit 1
    fi
    
    log_success "Discovered $count Docker image(s)"
}

# has_golang_component: Check if image has a golang component | $1: image name
has_golang_component() {
    local image=$1
    local config="${IMAGE_PATHS[$image]}/tag-config.yaml"
    yq eval '.components[] | select(.name == "golang")' "$config" 2>/dev/null | grep -q .
}

# show_menu: Display available images and prompt for selection
show_menu() {
    log_info "Available Docker images:"
    echo ""
    
    local index=1
    local images_array=()
    
    for image in $(printf '%s\n' "${!IMAGE_PATHS[@]}" | sort); do
        images_array+=("$image")
        printf "  %2d) %-40s\n" "$index" "$image"
        ((index++))
    done
    
    # Check if there are Go-based images
    local has_go_images=false
    for image in "${images_array[@]}"; do
        if has_golang_component "$image"; then
            has_go_images=true
            break
        fi
    done
    
    echo ""
    echo "  Options:"
    echo "    Enter numbers (space, comma, or range: e.g., '1 3 5-7' or '1,3,5-7')"
    echo "    'a' = Select all images"
    if [[ "$has_go_images" == true ]]; then
        echo "    'g' = Select all Go-based images"
    fi
    echo "    'q' = Quit"
    echo ""
    
    read -p "Select images: " -r selection
    
    case "${selection,,}" in
        a)
            SELECTED_IMAGES=("${images_array[@]}")
            ;;
        g)
            select_go_images "${images_array[@]}"
            if [[ ${#SELECTED_IMAGES[@]} -eq 0 ]]; then
                log_error "No Go-based images found"
                exit 1
            fi
            ;;
        q)
            log_info "Exiting..."
            exit 0
            ;;
        *)
            parse_selection "$selection" "${images_array[@]}"
            ;;
    esac
    
    if [[ ${#SELECTED_IMAGES[@]} -eq 0 ]]; then
        log_error "No images selected"
        exit 1
    fi
    
    log_success "Selected ${#SELECTED_IMAGES[@]} image(s)"
}

# select_go_images: Select all images with golang component | $@: array of available images
select_go_images() {
    local images_array=("$@")
    
    for image in "${images_array[@]}"; do
        if has_golang_component "$image"; then
            SELECTED_IMAGES+=("$image")
        fi
    done
}

# parse_selection: Parse user input for image selection (ranges, lists) | $1: selection string, $@: image array
parse_selection() {
    local selection=$1
    shift
    local images_array=("$@")
    
    selection="${selection//,/ }"
    
    for item in $selection; do
        if [[ $item =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local start=${BASH_REMATCH[1]}
            local end=${BASH_REMATCH[2]}
            for num in $(seq "$start" "$end"); do
                if [[ $num -ge 1 && $num -le ${#images_array[@]} ]]; then
                    SELECTED_IMAGES+=("${images_array[$((num-1))]}");
                fi
            done
        elif [[ $item =~ ^[0-9]+$ ]]; then
            if [[ $item -ge 1 && $item -le ${#images_array[@]} ]]; then
                SELECTED_IMAGES+=("${images_array[$((item-1))]}");
            fi
        fi
    done
}

# confirm_update: Prompt user to confirm update for an image | $1: image name | Returns 0 to continue, 1 to skip
confirm_update() {
    local image=$1
    echo ""
    log_info "Ready to update: $image"
    read -p "Continue? (Enter to continue, 'n' to skip): " -r confirm
    if [[ -n "$confirm" && "${confirm,,}" != "y" ]]; then
        log_warning "Skipping $image"
        return 1
    fi
    return 0
}

# show_summary: Display update summary with success/skipped/failed counts | $1: total, $2: success, $3: skipped, $4: failed
show_summary() {
    local total=$1
    local success=$2
    local skipped=$3
    local failed=$4
    echo ""
    log_info "========== Update Summary =========="
    log_info "Total images: $total"
    log_success "Successful: $success"
    if [[ $skipped -gt 0 ]]; then
        log_warning "Skipped: $skipped"
    fi
    if [[ $failed -gt 0 ]]; then
        log_error "Failed: $failed"
    fi
    echo ""
}
