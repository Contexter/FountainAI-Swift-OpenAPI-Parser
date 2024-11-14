// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OpenAPIParser",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "OpenAPIParser", targets: ["OpenAPIParser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "OpenAPIParser",
            dependencies: ["Yams"],
            path: "Sources/OpenAPIParser",
            resources: [
                .process("openapi_specs") // Mark the `openapi_specs` directory as a resource
            ]
        ),
        .testTarget(
            name: "OpenAPIParserTests",
            dependencies: ["OpenAPIParser"],
            path: "Tests/OpenAPIParserTests"
        ),
    ]
)
