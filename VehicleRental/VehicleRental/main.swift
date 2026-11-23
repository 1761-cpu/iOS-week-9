import Foundation

// ENTRY POINT
//   swift run VehicleRental         -> automatic demo of all requirements
//   swift run VehicleRental menu    -> interactive menu
if CommandLine.arguments.contains("menu") {
    ConsoleMenu(system: RentalSystem()).run()
} else {
    Demo.run()
}
