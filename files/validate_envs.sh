#!/bin/bash
set -e
set -o pipefail

unset ACTION_TYPE
unset FILE

usage() {
  cat <<EOM
    Usage:
    tf_validations.sh -a|--action validate_duplicate_env validationtype to run -f|--file fullpath to json file or -j|--json for json object
    tf_validations.sh -a|--action validate_duplicate_index validationtype to run -f|--file fullpath to json file or -j|--json for json object
    tf_validations.sh -a|--action validate_env_name validationtype to run -f|--file fullpath to json file or -j|--json for json object -r|--regex  regexe pattern list
    tf_validations.sh -a|--action validate_min_max_index to run -f|--file fullpath to json file or -j|--json for json object -m|--max max index allowed 
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
    -j|--json)
      JSON="$2"
      shift # past argument
      shift # past value
      ;;
    -a|--action)
      ACTION_TYPE="$2"
      shift # past argument
      shift # past value
      ;;
    -m|--max)
      MAX_INDEX=`sed -e 's/^"//' -e 's/"$//' <<<"$2"`
      shift # past argument
      shift # past value
      ;;
    -r|--regex)
      IFS=', ' read -r -a REGEX_PATTERN <<< "$2"
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
if [ -z $FILE ]; then 
  echo "$JSON" > ./environment.json
  export FILE="./environment.json"
fi
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
      jq -n  --arg has_duplicate "$has_duplicate" '{"valid":"false","message": $has_duplicate }'
else
      jq -n '{"valid":"true"}'
fi
}

validate_duplicate_index() {
  documentsJson=""  
  jsonStrings=$(cat "$FILE" | jq -c '.')
  while IFS= read -r document; do
    app_env=$(echo "$document" | jq -r 'keys[] as $parent | "\($parent)"')
  done <<< $jsonStrings
  declare -a app_envs=($app_env)
  declare -a all_envs=()
  for i in "${app_envs[@]}"
  do
  jsonStrings=$(cat "$FILE" | i="$i" jq -c '.[env.i]')
    while IFS= read -r document; do
    env_index=$(echo "$document" | jq -c '.env_index')
	  IFS=',' read -ra ADDR <<< "$env_index"
      for a_env in "${ADDR[@]}"; do
          all_envs+=("env_index $a_env appears under two environments, env_index must be unique per app environment")
      done
    done <<< $jsonStrings
  done
  has_duplicate=$(printf '%s\n' "${all_envs[@]}"|awk '!($0 in seen){seen[$0];next} 1')
  if [[ !  -z "$has_duplicate" ]]; then
      jq -n --arg has_duplicate "$has_duplicate" '{"valid":"false", "message": $has_duplicate }'
  else

      jq -n '{"valid":"true"}'
  fi
}

validate_min_max_index() {
  documentsJson=""  
  jsonStrings=$(cat "$FILE" | jq -c '.')
  while IFS= read -r document; do
    app_env=$(echo "$document" | jq -r 'keys[] as $parent | "\($parent)"')
  done <<< $jsonStrings
  declare -a app_envs=($app_env)
  declare -a all_envs=()
  for i in "${app_envs[@]}"
  do
  jsonStrings=$(cat "$FILE" | i="$i" jq -c '.[env.i]')
    while IFS= read -r document; do
      env_index=$(echo "$document" | jq -c '.env_index')
      IFS=',' read -ra ADDR <<< "$env_index"
      for a_env in "${ADDR[@]}"; do
        re='^[0-9]+$'
        a_env=`sed -e 's/^"//' -e 's/"$//' <<<"$a_env"`
        if [[ $((a_env)) =~ ^[\-0-9]+$ ]] && (( a_env <= -1)); then
          is_error="env_index cannot be a negative number"
        elif [[ $((a_env)) =~ ^[\-0-9]+$ ]] && (( a_env > MAX_INDEX )); then
          is_error="env_index cannot be greater then $MAX_INDEX"
        elif ! [[ $a_env =~ $re ]] ; then
          is_error="env_index must be an integer"
        fi
      done
    done <<< $jsonStrings
  done
  if [[ !  -z "$is_error" ]]; then
      jq -n --arg is_error "$is_error" '{"valid":"false", "message": $is_error }'
  else
      jq -n '{"valid":"true"}'
  fi
}

validate_env_name() {
  documentsJson=""  
  jsonStrings=$(cat "$FILE" | jq -c '.')
  while IFS= read -r document; do
    app_env=$(echo "$document" | jq -r 'keys[] as $parent | "\($parent)"')
  done <<< $jsonStrings
  declare -a app_envs=($app_env)
  declare -a all_envs=()
  for i in "${app_envs[@]}"
  do
    for x in "${REGEX_PATTERN[@]}"
    do
    if [[ "$i" == *"$x"* ]]; then
      not_valid="$i cannot contain any of the following expressions: ${REGEX_PATTERN[@]}"
    fi
    done
  done
  if [[ !  -z "$not_valid" ]]; then
      jq -n --arg not_valid "$not_valid" '{"valid":"false", "message": $not_valid }'
  else
      jq -n '{"valid":"true"}'
  fi
}

$ACTION_TYPE

