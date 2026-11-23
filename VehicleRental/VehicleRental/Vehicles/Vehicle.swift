//
//  Vehicle.swift
//  VehicleRental
//
//  Created by MAY 04 on 23/11/26.
//


import Foundation

// ENCAPSULATION: private(set) — readable everywhere, changeable only inside
class Vehicle {
    let id: String
    private(set) var brand: String
    private(set) var model: String
    private(set) var dailyRate: Int
    private(set) var status: VehicleStatus = .available

    init(id: String, brand: String, model: String, dailyRate: Int) {
        self.id = id
        self.brand = brand
        self.model = model
        self.dailyRate = dailyRate
    }

    // Subclasses override these (POLYMORPHISM)
    var typeName: String { return "Vehicle" }
    var details: String { return "" }
    var pricingRule: String { return "daily rate x days" }
    func rentalCost(days: Int) -> Int { return dailyRate * days }

    var isAvailable: Bool { return status == .available }

    func update(brand: String? = nil, model: String? = nil, dailyRate: Int? = nil) throws {
        if let b = brand, b.isEmpty { throw RentalError.invalidData("Brand must not be empty.") }
        if let m = model, m.isEmpty { throw RentalError.invalidData("Model must not be empty.") }
        if let r = dailyRate, r <= 0 { throw RentalError.invalidData("Daily rate must be greater than 0.") }
        if let b = brand { self.brand = b }
        if let m = model { self.model = m }
        if let r = dailyRate { self.dailyRate = r }
    }

    func markRented() throws {
        guard status == .available else { throw RentalError.notAvailable(id) }
        status = .rented
    }
    func markReturned() { status = .available }

    func info() -> String {
        return "[\(typeName)] \(id) | \(brand) \(model) | \(details) | \(money(dailyRate))/day | \(status.rawValue)"
    }
}