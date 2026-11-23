// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "VehicleRental",
    platforms: [.macOS(.v12)],
    targets: [
        .executableTarget(
            name: "VehicleRental",
            path: "Sources/VehicleRental"
        )
    ]
)
