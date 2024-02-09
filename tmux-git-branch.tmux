#!/bin/bash

PATH="/usr/local/bin:$PATH:/usr/sbin"

get_tmux_option() {
  local option_name="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv $option_name)"

  if [ -z "$option_value" ]; then
    echo -n "$default_value"
  else
    echo -n "$option_value"
  fi
}

set_tmux_option() {
  local option_name="$1"
  local option_value="$2"
  $(tmux set-option -gq $option_name "$option_value")
}


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

replace_placeholder_in_status_line() {
    local placeholder="\#{$1}"
    local script="#($2)"
    local status_line_side=$3
    local old_status_line=$(get_tmux_option $status_line_side)
    local new_status_line=${old_status_line/$placeholder/$script}

    $(set_tmux_option $status_line_side "$new_status_line")
}

main(){
    local value="$(git rev-parse --abbrev-ref "HEAD")"
    replace_placeholder_in_status_line "git_branch" "$value" "status-right"
}
# local update_interval=10; #$((60 * $(get_tmux_option "@tmux-weather-interval" 15)))
# local current_time=$(date "+%s")
# local previous_update=$(get_tmux_option "@git-branch-previous-update-time")
# local delta=$((current_time - previous_update))
#
# if [ -z "$previous_update" ] || [ $delta -ge $update_interval ]; then
#   local value=$(git rev-parse --abbrev-ref "HEAD")
#   if [ "$?" -eq 0 ]; then
#     $(set_tmux_option "@git-branch-previous-update-time" "$current_time")
#     $(set_tmux_option "@git-branch-previous-value" "$value")
#   fi
# fi
#
# echo -n $(get_tmux_option "@git-branch-previous-value")

main
