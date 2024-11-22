#!/bin/bash

# Exit immediately on failure
set -e

# Configuration
CONFIG_FILE="ci-reporter.conf"                # Configuration file to store repo info
CI_DIR="ci-reports"                           # Directory for CI artifacts
RUN_NAME=""                                   # Randomly generated run name
TARGET_REPO=""                                # Repository URL (to be loaded from config)
LAST_RUN_FILE="ci-reports/last-run.json"      # File to track the last run metadata

# Function to generate a random run name
generate_run_name() {
    ADJECTIVES=("blue" "fast" "quiet" "shiny" "lucky" "bright" "fuzzy" "sunny" "stormy" "dark")
    NOUNS=("mountain" "ocean" "forest" "river" "desert" "valley" "sky" "rainbow" "cloud" "star")
    RANDOM_ADJECTIVE=${ADJECTIVES[$RANDOM % ${#ADJECTIVES[@]}]}
    RANDOM_NOUN=${NOUNS[$RANDOM % ${#NOUNS[@]}]}
    RANDOM_NUMBER=$((1000 + RANDOM % 9000))
    RUN_NAME="$RANDOM_ADJECTIVE-$RANDOM_NOUN-$RANDOM_NUMBER"
    echo "Generated Run Name: $RUN_NAME"
}

# Function to display usage information
usage() {
    echo "Usage: $0 [--setup]"
    echo ""
    echo "Options:"
    echo "  --setup    Configure the script with a GitHub repository URL"
    echo "  --help     Show this help message"
    exit 1
}

# Function to set up the script with a repository
setup_script() {
    echo "🔧 Configuring CI Reporter..."
    read -p "Enter the GitHub repository URL: " TARGET_REPO
    if [[ -z "$TARGET_REPO" ]]; then
        echo "❌ Error: Repository URL cannot be empty."
        exit 1
    fi
    echo "REPO_URL=$TARGET_REPO" > "$CONFIG_FILE"
    echo "✅ Configuration saved to $CONFIG_FILE."
}

# Function to load the repository URL from the configuration file
load_configuration() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Error: Configuration file not found. Run the script with --setup to configure it."
        exit 1
    fi
    source "$CONFIG_FILE"
    TARGET_REPO=$REPO_URL
    if [[ -z "$TARGET_REPO" ]]; then
        echo "❌ Error: Repository URL not found in the configuration file."
        exit 1
    fi
}

# Function to save the current run metadata
save_last_run() {
    echo "📝 Saving metadata for the current run..."
    mkdir -p "$CI_DIR"
    echo "{
  \"run_name\": \"$RUN_NAME\",
  \"timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\",
  \"status\": \"success\",
  \"ci_dir\": \"$CI_DIR/$RUN_NAME\"
}" > "$LAST_RUN_FILE"
}

# Function to push artifacts to the main branch
push_artifacts() {
    echo "🌐 Preparing to push CI artifacts to repository: $TARGET_REPO"
    if ! command -v gh &> /dev/null; then
        echo "❌ Error: GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/"
        exit 1
    fi

    gh repo clone "$TARGET_REPO" temp-repo
    cd temp-repo

    # Sync CI artifacts and last-run.json
    mkdir -p "$CI_DIR"
    cp -r ../"$CI_DIR/$RUN_NAME" "$CI_DIR/"
    cp ../"$LAST_RUN_FILE" "$LAST_RUN_FILE"
    git add "$CI_DIR" "$LAST_RUN_FILE"
    git commit -m "CI Artifacts and metadata for $RUN_NAME"
    git push origin main
    cd ..
    rm -rf temp-repo
    echo "✅ Artifacts pushed successfully to the main branch in $TARGET_REPO."
}

# Main function to orchestrate the CI pipeline
main() {
    if [[ "$1" == "--setup" ]]; then
        setup_script
        exit 0
    fi

    load_configuration
    generate_run_name
    save_last_run
    push_artifacts
    echo "🎉 CI pipeline completed successfully."
    echo "Logs and artifacts are available in the $CI_DIR/$RUN_NAME folder on the main branch."
}
main "$@"

