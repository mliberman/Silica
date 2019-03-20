// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Silica",
    products: [
        .library(name: "Silica", targets: ["Silica"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mliberman/Cairo.git", .exact("1.3.4"))
    ],
    targets: [
        .target(name: "Silica", dependencies: ["Cairo"])
    ]
)
