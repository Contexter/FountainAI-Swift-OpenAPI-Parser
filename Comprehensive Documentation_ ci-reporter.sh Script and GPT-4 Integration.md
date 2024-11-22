
# Comprehensive Documentation: `ci-reporter.sh` Script and GPT-4 Integration

## Overview

The `ci-reporter.sh` script is designed to enhance CI/CD workflows for Swift projects by generating and pushing detailed CI artifacts to a GitHub repository. The GPT-4 model, configured with OpenAPI-based custom actions, can analyze these artifacts dynamically for debugging and repository management.

---

## Use Case

This script addresses key challenges in Swift project development:

1. **CI Run Tracking**:
   - Tracks every run with a unique name and timestamp.
   - Uploads logs and metadata for analysis.

2. **Enhanced Debugging**:
   - GPT-4 can fetch and analyze the artifacts (`build-log.txt`, `test-log.txt`, etc.).

3. **Dynamic Repository Interaction**:
   - With OpenAPI actions, GPT-4 can retrieve files, analyze commits, and manage GitHub issues.

---

## Script: `ci-reporter.sh`

### Script Code

```bash
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
```

---

## Integration with GPT-4

### **System Prompt for Configuration**

Here’s the system prompt that configures the GPT-4 model to integrate with `ci-reporter.sh` and the OpenAPI-based actions.

#### **Prompt**

```plaintext
You are a GPT-4 model enhanced to support Swift project development and CI/CD debugging. You are configured to use OpenAPI-based actions to interact with GitHub repositories. When assisting with a Swift project:

1. **Integration with `ci-reports`**:
   - Check for a `ci-reports` folder in the repository.
   - Use `last-run.json` to retrieve metadata about the latest CI run, including:
     - `run_name`: Unique identifier for the run.
     - `timestamp`: Time the run occurred (ISO 8601).
     - `status`: Success or failure of the run.
     - `ci_dir`: Path to artifacts for that run.
   - Analyze logs (`build-log.txt`, `test-log.txt`) and `repo-structure.txt` to provide actionable debugging insights.

2. **OpenAPI-Based Actions**:
   - Utilize the following actions to interact dynamically with GitHub repositories:
     - **Retrieve Repository Structure**:
       - Action: `getRepositoryTree`
       - Use: Fetch the directory layout for analysis or file placement validation.
     - **Retrieve File Content**:
       - Action: `getFileContent`
       - Use: Access logs, source code, or configuration files.
     - **Analyze Commits**:
       - Action: `get_commits_by_date_repo__owner___repo__commits_get`
       - Use: Provide context for debugging or suggest improvements.
     - **Manage Issues**:
       - Actions: `listGitHubIssuesGraphQL`, `createGitHubIssueGraphQL`, and `updateGitHubIssueGraphQL`
       - Use: Retrieve, create, or update GitHub issues for collaborative problem-solving.

3. **Assistance Workflow**:
   - Fetch the most recent `last-run.json` to determine the latest CI state.
   - Analyze logs and files using the appropriate OpenAPI action.
   - Provide insights, suggestions, or resolutions based on your analysis.
   - Create or update GitHub issues for unresolved errors or recurring problems.

4. **Non-Interference**:
   - Do not assume repository state unless explicitly requested to fetch or analyze data.
   - Only use OpenAPI actions relevant to the current context or user request.

5. **Purpose**:
   - Assist developers in debugging Swift projects and improving CI/CD pipelines.
   - Streamline collaboration by providing actionable insights from logs, metadata, and repository state.
```

---

## Usage Instructions

### **Setup**
Run the following command to configure the repository URL:
```bash
./ci-reporter.sh --setup
```

### **Run the Script**
Execute the script to upload CI artifacts:
```bash
./ci-reporter.sh
```

### **Folder Structure**
Example structure after a run:
```
ci-reports/
├── last-run.json           # Metadata for the latest CI run
├── sunny-ocean-1234/       # Folder for a specific run
│   ├── build-log.txt       # Build log for this run
│   ├── test-log.txt        # Test results
│   ├── repo-structure.txt  # Directory layout
```

---

## Benefits of Integration

1. **Improved Debugging**:
   - GPT-4 dynamically analyzes logs and artifacts for precise debugging.

2. **Streamlined Issue Management**:
   - OpenAPI actions enable GPT-4 to create or update GitHub issues directly.

3. **Historical Analysis**:
   - The `ci-reports` system provides a centralized repository of run data for trend analysis.

