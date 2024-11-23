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
                .process("Sources/OpenAPIParserLib/OpenAPI/Action-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Central-Sequence-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Character-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Core-Script-Managment-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Ensemble-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Paraphrase-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Performer-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Session-And-Context-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Spoken-Word-Service.yml"),
                .process("Sources/OpenAPIParserLib/OpenAPI/Story-Factory-Service.yml")
            ]
        ),
    ]
)
