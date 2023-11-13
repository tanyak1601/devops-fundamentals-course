#!/bin/bash

if [ "$1" = "--help" ]
then
  echo "How to use the script:"
  echo "./<script_path> ./<source_JSON_file_path>
    --configuration <value> 
    --owner <value> 
    --branch <value> 
    --poll-for-source-changes <value>"

  exit 0
fi

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
source_pipeline_file=$1
updated_pipeline_file=$SCRIPT_DIR/pipeline-$(date +%Y-%m-%d).json

branch="main"
poll_for_source_changes="false"

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq not found. Please install"
    echo "Install using sudo apt-get install jq (Debian/Ubuntu)"
    echo "Install using sudo dnf install jq (Fedora)"
    echo "Install using sudo zypper install jq (openSUSE)"
    echo "Install using sudo pacman -S jq (Arch)"
    exit 1
fi

#validate if the path to the pipeline definition JSON file is provided
if ! [[ -f "$source_pipeline_file" ]]
then
  echo "The first parameter is not a valid path to a file."
  exit 1
fi


# Check that necessary properties are present in the given JSON definition
if jq -e 'select(.pipeline.stages[] | select(.name == "Source") | .actions[0].configuration.Branch == null)' "$source_pipeline_file" > /dev/null
then
    echo "ERROR: Required 'Branch' field not specified in source JSON"
    exit 1
elif jq -e 'select(.pipeline.stages[] | select(.name == "Source") | .actions[0].configuration.Owner == null)' "$source_pipeline_file" > /dev/null
then
    echo "ERROR: Required 'Owner' field not specified in source JSON"
    exit 1
elif jq -e 'select(.pipeline.stages[] | select(.name == "Source") | .actions[0].configuration.Repo == null)' "$source_pipeline_file" > /dev/null
then
    echo "ERROR: Required 'Repo' field not specified in source JSON"
    exit 1
elif jq -e 'select(.pipeline.stages[] | select(.name == "Source") | .actions[0].configuration.PollForSourceChanges == null)' "$source_pipeline_file" > /dev/null
then
    echo "ERROR: Required 'PollForSourceChanges' field not specified in source JSON"
    exit 1
elif jq -e 'select(.pipeline.stages[] | select(.name == "QualityGate") | .actions[0].configuration.EnvironmentVariables == null)' "$source_pipeline_file" > /dev/null
then
    echo "ERROR: Required 'EnvironmentVariables' field for QualityGate stage not specified in source JSON"
    exit 1
elif jq -e 'select(.pipeline.stages[] | select(.name == "Build") | .actions[0].configuration.EnvironmentVariables == null)' "$source_pipeline_file" > /dev/null
then
    echo "ERROR: Required 'EnvironmentVariables' field for Build stage not specified in source JSON"
    exit 1
fi

# Assign flag values to variables
while [ "$#" -gt 0 ]; do
  case "$1" in
    --branch)
      branch="$2"
      shift 2
      ;;
    --owner)
      owner="$2"
      shift 2
      ;;
    --repo)
      repo="$2"
      shift 2
      ;;
    --poll_for_source_changes)
      poll_for_source_changes="$2"
      shift 2
      ;;
    --configuration)
      configuration="$2"
      shift 2
      ;;
    *)
      shift 1
      ;;
  esac
done

cp "$source_pipeline_file" "$updated_pipeline_file"

# Remove metadata
temp_file=$(mktemp)
jq 'del(.metadata)' "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

# Increment version
pipeline_version=$(jq '.pipeline.version' "$updated_pipeline_file") 
(( ++pipeline_version ))

temp_file=$(mktemp)
jq ".pipeline.version = ${pipeline_version}" "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

# Set Branch
temp_file=$(mktemp)
jq -r --arg branch "$branch" '.pipeline.stages |= (
    map(
        if .name == "Source" then 
            (.actions[0].configuration.Branch |= $branch)
        else
            . 
        end
    )
)' "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

# Set Owner
temp_file=$(mktemp)
jq -r --arg owner "$owner" '.pipeline.stages |= (
    map(
        if .name == "Source" then 
            (.actions[0].configuration.Owner |= $owner)
        else
            . 
        end
    )
)' "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

# Set Repo
temp_file=$(mktemp)
jq -r --arg repo "$repo" '.pipeline.stages |= (map(
    if .name == "Source" then 
        (.actions[0].configuration.Repo |= $repo) 
    else 
        . 
    end
))' "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

# Set PollForSourceChanges
temp_file=$(mktemp)
jq -r --arg poll_for_source_changes "$poll_for_source_changes" '.pipeline.stages |= (
    map(
        if .name == "Source" then 
            (.actions[0].configuration.PollForSourceChanges |= $poll_for_source_changes)
        else
            . 
        end
    )
)' "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

# Set EnvironmentVariables
temp_file=$(mktemp)
jq --arg configuration "$configuration" '.pipeline.stages |= (
  map(.actions |= (
    map(
      if .configuration.EnvironmentVariables then
        .configuration.EnvironmentVariables |= (fromjson | map(
          if .name == "BUILD_CONFIGURATION" then .value |= $configuration else . end
        ) | tojson)
      else
        .
      end
    )
  ))
)' "$updated_pipeline_file" > "$temp_file"
mv "$temp_file" "$updated_pipeline_file"

