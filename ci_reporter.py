import os
import shutil
import json
import subprocess
from datetime import datetime, timezone
import random

# Configuration
CONFIG_FILE = "ci_reporter.conf"
CI_DIR = "ci-reports"
LAST_RUN_FILE = os.path.join(CI_DIR, "last-run.json")
TEMP_REPO_DIR = "temp-repo"

# Function to generate a random run name
def generate_run_name():
    adjectives = ["blue", "fast", "quiet", "shiny", "lucky", "bright", "fuzzy", "sunny", "stormy", "dark"]
    nouns = ["mountain", "ocean", "forest", "river", "desert", "valley", "sky", "rainbow", "cloud", "star"]
    run_name = f"{random.choice(adjectives)}-{random.choice(nouns)}-{random.randint(1000, 9999)}"
    print(f"Generated Run Name: {run_name}")
    return run_name

# Function to load repository configuration
def load_configuration():
    if not os.path.exists(CONFIG_FILE):
        print("❌ Configuration file not found. Please run the script with --setup to configure it.")
        exit(1)

    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)

    if "REPO_URL" not in config:
        print("❌ Repository URL not found in the configuration file.")
        exit(1)

    return config["REPO_URL"]

# Function to run a shell command and capture its output
def run_command(command, log_file):
    print(f"🔧 Running command: {' '.join(command)}")
    try:
        with open(log_file, "w") as f:
            subprocess.run(command, stdout=f, stderr=subprocess.STDOUT, check=True)
        return "success"
    except subprocess.CalledProcessError:
        return "failure"

# Function to execute build and test commands
def execute_build_and_test(run_name):
    run_dir = os.path.join(CI_DIR, run_name)
    os.makedirs(run_dir, exist_ok=True)

    # Build command
    build_log = os.path.join(run_dir, "build-log.txt")
    build_status = run_command(["swift", "build"], build_log)

    # Test command
    test_log = os.path.join(run_dir, "test-log.txt")
    test_status = run_command(["swift", "test"], test_log)

    return build_status, test_status

# Function to save metadata for the current run
def save_last_run(run_name, build_status, test_status):
    print("📝 Saving metadata for the current run...")
    run_dir = os.path.join(CI_DIR, run_name)

    metadata = {
        "run_name": run_name,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "build_status": build_status,
        "test_status": test_status,
        "ci_dir": run_dir
    }

    os.makedirs(CI_DIR, exist_ok=True)
    with open(LAST_RUN_FILE, "w") as f:
        json.dump(metadata, f, indent=4)

# Function to push artifacts to the repository
def push_artifacts(repo_url, run_name):
    print(f"🌐 Preparing to push CI artifacts to repository: {repo_url}")

    # Ensure GitHub CLI is installed
    if shutil.which("gh") is None:
        print("❌ GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/")
        exit(1)

    # Clean up any existing temp-repo directory
    if os.path.exists(TEMP_REPO_DIR):
        print("🧹 Cleaning up existing temp-repo directory...")
        shutil.rmtree(TEMP_REPO_DIR)

    # Clone the repository
    subprocess.run(["gh", "repo", "clone", repo_url, TEMP_REPO_DIR], check=True)

    # Copy artifacts into the repository
    run_dir = os.path.join(CI_DIR, run_name)
    dest_dir = os.path.join(TEMP_REPO_DIR, CI_DIR)
    os.makedirs(dest_dir, exist_ok=True)
    shutil.copytree(run_dir, os.path.join(dest_dir, run_name), dirs_exist_ok=True)
    shutil.copy(LAST_RUN_FILE, TEMP_REPO_DIR)

    # Commit and push changes
    os.chdir(TEMP_REPO_DIR)
    try:
        subprocess.run(["git", "add", "."], check=True)
        subprocess.run(["git", "commit", "-m", f"CI Artifacts and metadata for {run_name}"], check=True)
        subprocess.run(["git", "push", "origin", "main"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to push changes: {e}")
        exit(1)
    finally:
        os.chdir("..")
        shutil.rmtree(TEMP_REPO_DIR)
    print(f"✅ Artifacts pushed successfully to the main branch in {repo_url}.")

# Main function
def main():
    import argparse
    parser = argparse.ArgumentParser(description="CI Reporter for managing and pushing CI artifacts.")
    parser.add_argument("--setup", action="store_true", help="Set up the script with a GitHub repository URL.")
    args = parser.parse_args()

    if args.setup:
        print("🔧 Configuring CI Reporter...")
        repo_url = input("Enter the GitHub repository URL: ").strip()
        if not repo_url:
            print("❌ Error: Repository URL cannot be empty.")
            exit(1)

        with open(CONFIG_FILE, "w") as f:
            json.dump({"REPO_URL": repo_url}, f)
        print(f"✅ Configuration saved to {CONFIG_FILE}.")
        return

    # Load configuration and proceed with CI processing
    repo_url = load_configuration()
    run_name = generate_run_name()
    build_status, test_status = execute_build_and_test(run_name)
    save_last_run(run_name, build_status, test_status)
    push_artifacts(repo_url, run_name)
    print("🎉 CI pipeline completed successfully.")

if __name__ == "__main__":
    main()
