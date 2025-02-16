# favorite-dirs.plugin.zsh
# A Zsh plugin for managing favorite directories with keyboard shortcuts

# Configuration file location
FAVDIRS_CONFIG="${HOME}/.favdirs"

# Initialize favorite directories file if it doesn't exist
if [[ ! -f "${FAVDIRS_CONFIG}" ]]; then
    touch "${FAVDIRS_CONFIG}"
fi

# Function to add current directory to favorites
add_favorite() {
    local slot="$1"
    if [[ ! "$slot" =~ ^[0-9]+$ ]]; then
        echo "Error: Slot must be a number"
        return 1
    fi

    local current_dir="$(pwd)"
    local temp_file="${FAVDIRS_CONFIG}.tmp"

    # Remove existing entry for this slot if it exists
    grep -v "^${slot}:" "${FAVDIRS_CONFIG}" > "${temp_file}"
    # Add new entry
    echo "${slot}:${current_dir}" >> "${temp_file}"
    # Sort by slot number
    sort -n "${temp_file}" > "${FAVDIRS_CONFIG}"
    rm "${temp_file}"

    echo "Added current directory to slot ${slot}"
}

# Function to jump to favorite directory
goto_favorite() {
    local slot="$1"
    if [[ ! "$slot" =~ ^[0-9]+$ ]]; then
        echo "Error: Slot must be a number"
        return 1
    fi

    local dir=$(grep "^${slot}:" "${FAVDIRS_CONFIG}" | cut -d: -f2)
    if [[ -z "${dir}" ]]; then
        echo "No directory assigned to slot ${slot}"
        return 1
    elif [[ ! -d "${dir}" ]]; then
        echo "Directory ${dir} no longer exists"
        return 1
    fi

    cd "${dir}"
}

# Function to list all favorite directories
list_favorites() {
    if [[ ! -s "${FAVDIRS_CONFIG}" ]]; then
        echo "No favorite directories configured"
        return 0
    fi

    echo "Favorite Directories:"
    echo "---------------------"
    while IFS=: read -r slot dir; do
        if [[ -d "${dir}" ]]; then
            echo "${slot}: ${dir}"
        else
            echo "${slot}: ${dir} (NOT FOUND)"
        fi
    done < "${FAVDIRS_CONFIG}"
}

# Function to remove a favorite directory
remove_favorite() {
    local slot="$1"
    if [[ ! "$slot" =~ ^[0-9]+$ ]]; then
        echo "Error: Slot must be a number"
        return 1
    fi

    local temp_file="${FAVDIRS_CONFIG}.tmp"
    grep -v "^${slot}:" "${FAVDIRS_CONFIG}" > "${temp_file}"
    mv "${temp_file}" "${FAVDIRS_CONFIG}"
    echo "Removed favorite directory from slot ${slot}"
}

# Function to redraw prompt
redraw-prompt() {
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
  done
  p10k display -r
}

# Define aliases for easy access
alias fav='add_favorite'
alias favlist='list_favorites'
alias favrem='remove_favorite'

# Create widgets for each slot
for i in {1..9}; do
    eval "
        goto-favorite-${i}-widget() {
            zle -I  # Invalidate current prompt
            goto_favorite $i
	    if [[ $ZSH_THEME =~ "powerlevel10k" ]]; then
		    redraw-prompt
	    else
            	    zle reset-prompt
	    fi
        }
        zle -N goto-favorite-${i}-widget
    "
done

# Bind keys to widgets
bindkey "^[1" goto-favorite-1-widget  # Alt+1
bindkey "^[2" goto-favorite-2-widget  # Alt+2
bindkey "^[3" goto-favorite-3-widget  # Alt+3
bindkey "^[4" goto-favorite-4-widget  # Alt+4
bindkey "^[5" goto-favorite-5-widget  # Alt+5
bindkey "^[6" goto-favorite-6-widget  # Alt+6
bindkey "^[7" goto-favorite-7-widget  # Alt+7
bindkey "^[8" goto-favorite-8-widget  # Alt+8
bindkey "^[9" goto-favorite-9-widget  # Alt+9
