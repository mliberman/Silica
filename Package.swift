// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Silica",
    products: [
        .library(name: "Silica", targets: ["Silica"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mliberman/Cairo.git", .branch("feature/xcode-10.2"))
    ],
    targets: [
        .target(name: "Silica", dependencies: ["Cairo"])
    ]
)
