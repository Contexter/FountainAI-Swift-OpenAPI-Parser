import os

# Define paths
PACKAGE_SWIFT_PATH = "Package.swift"
RESOURCE_DIRECTORIES = [
    "Sources/OpenAPIParserLib/OpenAPI/",
    "Tests/OpenAPIParserTests/"
]

def scan_resources():
    """
    Scan specified directories for resource files.
    """
    resources = []
    for directory in RESOURCE_DIRECTORIES:
        for root, _, files in os.walk(directory):
            for file in files:
                if file.endswith(('.json', '.yaml', '.yml')):
                    resources.append(os.path.relpath(os.path.join(root, file)))
    return resources

def locate_test_target(lines, target_name="OpenAPIParserTests"):
    """
    Locate the start and end of the testTarget block.
    """
    start, end = None, None
    for i, line in enumerate(lines):
        if f'.testTarget(' in line and f'name: "{target_name}"' in line:
            start = i
        if start is not None and line.strip() == "),":
            end = i
            break
    return start, end

def update_package_swift(resources):
    """
    Update Package.swift with the scanned resources.
    """
    try:
        with open(PACKAGE_SWIFT_PATH, "r") as f:
            lines = f.readlines()

        # Locate testTarget block for OpenAPIParserTests
        test_target_start, test_target_end = locate_test_target(lines)

        if test_target_start is None or test_target_end is None:
            print("❌ Could not locate test target in Package.swift.")
            return

        # Check if resources already exist
        if any("resources:" in line for line in lines[test_target_start:test_target_end]):
            print("✅ Resources are already declared in Package.swift.")
            return

        # Insert resources
        resource_lines = ["        resources: [\n"]
        resource_lines += [f"            .process(\"{resource}\"),\n" for resource in resources]
        resource_lines.append("        ],\n")

        # Insert resource lines before the closing parenthesis of the test target
        lines = lines[:test_target_end] + resource_lines + lines[test_target_end:]

        # Write updated Package.swift
        with open(PACKAGE_SWIFT_PATH, "w") as f:
            f.writelines(lines)

        print(f"✅ Updated {PACKAGE_SWIFT_PATH} with {len(resources)} resources.")
    except Exception as e:
        print(f"❌ Failed to update {PACKAGE_SWIFT_PATH}: {e}")

if __name__ == "__main__":
    print("🚀 Scanning directories for resources...")
    resources = scan_resources()
    print(f"Found {len(resources)} resource(s): {resources}")

    print("🚀 Updating Package.swift...")
    update_package_swift(resources)
