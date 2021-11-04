#!/bin/bash
set -e
set -o pipefail

unset ACTION_TYPE
unset FILE

usage() {
  cat <<EOM
    Usage:
    tf_validations.sh -a|--action validate_duplicate_env validationtype to run -f|--file fullpath to json file
EOM
    exit 1
}

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -f|--file)
      FILE="$2"
      shift # past argument
      shift # past value
      ;;
    -a|--action)
      ACTION_TYPE="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
        usage
        shift # past argument
        shift # past value
      ;;
    *)    # unknown option
      echo "Error in command line parsing: unknown parameter ${*}" >&2
      exit 1
  esac
done
: ${ACTION_TYPE:?Missing -a|--action type -h for help}
validate_duplicate_env() {
documentsJson=""  
    jsonStrings=$(cat "$FILE" | jq -c '.')
    while IFS= read -r document; do

	data_env=$(echo "$document" | jq -r 'keys[] as $parent | "\($parent)"')
   done <<< $jsonStrings
declare -a data_envs=($data_env)
declare -a all_envs=()
for i in "${data_envs[@]}"
do
jsonStrings=$(cat "$FILE" | i="$i" jq -c '.[env.i]')
    while IFS= read -r document; do
    allowed_envs=$(echo "$document" | jq -c '.allowed_envs')
	allowed_envs=$(echo "$allowed_envs" | sed 's/\[//g' | sed 's/\]//g')
    IFS=',' read -ra ADDR <<< "$allowed_envs"
    for a_env in "${ADDR[@]}"; do
        all_envs+=("$a_env app appears in more then one data environment, please make sure the same app environment does not populate more then one data environment")
    done
    done <<< $jsonStrings
done
has_duplicate=$(printf '%s\n' "${all_envs[@]}"|awk '!($0 in seen){seen[$0];next} 1')
if [[ !  -z "$has_duplicate" ]]; then
echo "$has_duplicate"
    exit 1
else
    exit 0
fi

}

$ACTION_TYPE