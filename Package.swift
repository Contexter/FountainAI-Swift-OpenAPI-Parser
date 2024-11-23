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
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "OpenAPIParserLib",
            dependencies: ["Yams"],
            path: "Sources/OpenAPIParserLib"
        ),
        .testTarget(
            name: "OpenAPIParserTests",
            dependencies: ["OpenAPIParserLib"],
            path: "Tests/OpenAPIParserTests",
            resources: [
                .process("Sources/OpenAPIParserLib/OpenAPI")
            ]
        ),
    ]
)
