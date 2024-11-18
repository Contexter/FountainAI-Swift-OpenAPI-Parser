import subprocess
import re
import sys  # Import sys to handle standard error and output streams

def run_command(command):
    """
    Executes a shell command and filters unnecessary warnings.
    """
    try:
        result = subprocess.run(
            command,
            shell=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        
        stdout = result.stdout
        stderr = result.stderr

        # Filter out unwanted warnings using regex or specific keywords
        filtered_stderr = filter_warnings(stderr)
        
        print(stdout)
        if filtered_stderr.strip():  # Print only if filtered warnings are non-empty
            print(filtered_stderr, file=sys.stderr)

    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code {e.returncode}: {e.stderr}", file=sys.stderr)

def filter_warnings(stderr):
    """
    Filters unnecessary warnings from stderr.
    """
    ignore_patterns = [
        r"unindent by \d+ spaces",    # Example: Indentation warnings
        r"remove trailing comma",     # Example: Trailing comma warnings
        r"add 1 line break",          # Example: Line break suggestions
        r"line is too long",          # Example: Line length warnings
    ]
    filtered_lines = []

    for line in stderr.splitlines():
        if not any(re.search(pattern, line) for pattern in ignore_patterns):
            filtered_lines.append(line)
    
    return "\n".join(filtered_lines)

if __name__ == "__main__":
    print("Running automated tests with filtered warnings...\n")
    
    commands = [
        "python3 -m unittest discover",  # Example test command
        # Add more commands as needed
    ]

    for command in commands:
        print(f"Executing: {command}")
        run_command(command)
