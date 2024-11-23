import os
import json
import subprocess
from datetime import datetime, timezone
import random

# Configuration
CONFIG_FILE = "ci_reporter.conf"
CI_DIR = "ci-reports"
LAST_RUN_FILE = os.path.join(CI_DIR, "last-run.json")

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

    if "LOCAL_REPO_PATH" not in config:
        print("❌ Local repository path not found in the configuration file.")
        exit(1)

    return config["LOCAL_REPO_PATH"]

# Function to run a shell command and capture its output
def run_command(command, log_file, cwd=None):
    print(f"🔧 Running command: {' '.join(command)}")
    try:
        with open(log_file, "w") as f:
            subprocess.run(command, stdout=f, stderr=subprocess.STDOUT, check=True, cwd=cwd)
        return "success"
    except subprocess.CalledProcessError:
        return "failure"

# Function to execute build and test commands
def execute_build_and_test(repo_path, run_name):
    run_dir = os.path.join(repo_path, CI_DIR, run_name)
    os.makedirs(run_dir, exist_ok=True)

    # Build command
    build_log = os.path.join(run_dir, "build-log.txt")
    build_status = run_command(["swift", "build"], build_log, cwd=repo_path)

    # Test command
    test_log = os.path.join(run_dir, "test-log.txt")
    test_status = run_command(["swift", "test"], test_log, cwd=repo_path)

    return build_status, test_status

# Function to save metadata for the current run
def save_last_run(repo_path, run_name, build_status, test_status):
    print("📝 Saving metadata for the current run...")
    run_dir = os.path.join(repo_path, CI_DIR, run_name)

    metadata = {
        "run_name": run_name,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "build_status": build_status,
        "test_status": test_status,
        "ci_dir": run_dir
    }

    os.makedirs(os.path.join(repo_path, CI_DIR), exist_ok=True)
    with open(os.path.join(repo_path, LAST_RUN_FILE), "w") as f:
        json.dump(metadata, f, indent=4)

# Function to commit and push changes
def commit_and_push(repo_path, run_name):
    print(f"🌐 Preparing to commit and push CI artifacts...")

    # Copy artifacts into the repository
    run_dir = os.path.join(repo_path, CI_DIR, run_name)

    # Commit and push changes
    try:
        subprocess.run(["git", "add", "."], check=True, cwd=repo_path)
        subprocess.run(["git", "commit", "-m", f"CI Artifacts and metadata for {run_name}"], check=True, cwd=repo_path)
        subprocess.run(["git", "push", "origin", "main"], check=True, cwd=repo_path)
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to push changes: {e}")
        exit(1)
    print(f"✅ Artifacts pushed successfully.")

# Main function
def main():
    import argparse
    parser = argparse.ArgumentParser(description="CI Reporter for managing and pushing CI artifacts.")
    parser.add_argument("--setup", action="store_true", help="Set up the script with your local repository path.")
    args = parser.parse_args()

    if args.setup:
        print("🔧 Configuring CI Reporter...")
        local_repo_path = input("Enter the path to your local GitHub repository: ").strip()
        if not local_repo_path or not os.path.exists(local_repo_path):
            print("❌ Error: Repository path is invalid or does not exist.")
            exit(1)

        with open(CONFIG_FILE, "w") as f:
            json.dump({"LOCAL_REPO_PATH": local_repo_path}, f)
        print(f"✅ Configuration saved to {CONFIG_FILE}.")
        return

    # Load configuration and proceed with CI processing
    repo_path = load_configuration()
    run_name = generate_run_name()
    build_status, test_status = execute_build_and_test(repo_path, run_name)
    save_last_run(repo_path, run_name, build_status, test_status)
    commit_and_push(repo_path, run_name)
    print("🎉 CI pipeline completed successfully.")

if __name__ == "__main__":
    main()
