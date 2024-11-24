// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OpenAPIParser",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "OpenAPIParserLib", targets: ["OpenAPIParserLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/contexter/FountainAI-OpenAPIs.git", from: "1.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "OpenAPIParserLib",
            dependencies: [
                "Yams",
                "FountainAI-OpenAPIs"
            ],
            path: "Sources/OpenAPIParserLib",
            exclude: ["OpenAPI"] // Exclude the local OpenAPI directory
        ),
        .testTarget(
            name: "OpenAPIParserTests",
            dependencies: ["OpenAPIParserLib"],
            path: "Tests/OpenAPIParserTests"
        ),
    ]
)
