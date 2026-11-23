import Foundation

enum VehicleStatus: String {
    case available = "Available"
    case rented    = "Rented"
    case defective = "Defective"
}

class Vehicle {
    var id: String
    var brand: String
    var model: String
    var dailyRate: Int
    
    private(set) var status: VehicleStatus = .available

    init(id: String, brand: String, model: String, dailyRate: Int) {
        self.id = id
        self.brand = brand
        self.model = model
        self.dailyRate = dailyRate
    }

    var typeName: String { return "Vehicle" }
    var details: String  { return "" }
    var isAvailable: Bool { return status == .available }

    func rentalCost(days: Int) -> Int {
        return dailyRate * days
    }

    func markRented() throws {
        guard status == .available else { throw RentalError.notAvailable(id) }
        status = .rented
    }
    
    func markReturned() {
        if status == .rented { status = .available }
    }
    
    func markDefective() {
        status = .defective
    }

    func update(brand: String? = nil, model: String? = nil, dailyRate: Int? = nil) throws {
        if let b = brand { self.brand = b }
        if let m = model { self.model = m }
        if let r = dailyRate {
            guard r > 0 else { throw RentalError.invalidData("Daily rate must be greater than 0.") }
            self.dailyRate = r
        }
    }

    func info() -> String {
        return "[\(typeName)] \(id) | \(brand) \(model) | \(details) | \(money(dailyRate))/day | \(status.rawValue)"
    }
}
