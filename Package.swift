// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Silica",
    products: [
        .library(name: "Silica", targets: ["Silica"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mliberman/Cairo.git", .exact("1.4.0"))
    ],
    targets: [
        .target(name: "Silica", dependencies: ["Cairo"])
    ]
)
