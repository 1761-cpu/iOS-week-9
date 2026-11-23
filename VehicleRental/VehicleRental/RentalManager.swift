//
//  RentalManager.swift
//  VehicleRental
//
//  Created by MAY 04 on 23/11/26.
//


import Foundation

final class RentalManager {
    private var vehicles: [Vehicle] = []
    private var customers: [Customer] = []
    private var rentals: [Rental] = []

    // ----- FR1: Vehicle management -----
    func addVehicle(_ v: Vehicle) throws {
        guard v.dailyRate > 0 else { throw RentalError.invalidData("Daily rate must be greater than 0.") }
        guard !vehicles.contains(where: { $0.id == v.id }) else { throw RentalError.duplicateID(v.id) }
        vehicles.append(v)
        print("[OK] Added vehicle \(v.id)")
    }

    func findVehicle(_ id: String) throws -> Vehicle {
        guard let v = vehicles.first(where: { $0.id == id }) else {
            throw RentalError.notFound("Vehicle '\(id)'")
        }
        return v
    }

    func showVehicle(_ id: String) throws {
        print("  " + (try findVehicle(id)).info())
    }

    func updateVehicle(_ id: String, brand: String? = nil, model: String? = nil,
                       dailyRate: Int? = nil) throws {
        let v = try findVehicle(id)
        try v.update(brand: brand, model: model, dailyRate: dailyRate)
        print("[OK] Updated: \(v.info())")
    }

    func checkAvailability(_ id: String) throws {
        let v = try findVehicle(id)
        print("  \(v.id) is \(v.isAvailable ? "AVAILABLE" : "NOT available (\(v.status.rawValue))")")
    }

    func listVehicles(onlyAvailable: Bool = false) {
        print(onlyAvailable ? "--- AVAILABLE VEHICLES ---" : "--- ALL VEHICLES ---")
        for v in vehicles where !onlyAvailable || v.isAvailable { print("  " + v.info()) }
    }

    // ----- FR2: Customer management -----
    @discardableResult
    func registerCustomer(name: String, phone: String, email: String) throws -> Customer {
        guard !name.isEmpty else { throw RentalError.invalidData("Customer name must not be empty.") }
        try validateContact(phone: phone, email: email)
        let c = Customer(id: "C\(customers.count + 1)", name: name, phone: phone, email: email)
        customers.append(c)
        print("[OK] Registered customer \(c.id) - \(c.name)")
        return c
    }

    func findCustomer(_ id: String) throws -> Customer {
        guard let c = customers.first(where: { $0.id == id }) else {
            throw RentalError.notFound("Customer '\(id)'")
        }
        return c
    }

    func showCustomer(_ id: String) throws {
        print("  " + (try findCustomer(id)).info())
    }

    // NEW: list all customers (broad interpretation of "View customer information")
    func listCustomers() {
        print("--- ALL CUSTOMERS ---")
        for c in customers { print("  " + c.info()) }
    }

    func updateCustomerContact(_ id: String, phone: String, email: String) throws {
        let c = try findCustomer(id)
        try c.updateContact(phone: phone, email: email)
        print("[OK] Updated contact: \(c.info())")
    }

    func showHistory(_ customerID: String) throws {
        let c = try findCustomer(customerID)
        print("--- RENTAL HISTORY OF \(c.name) ---")
        for r in c.history {
            print("  \(r.id) | \(r.vehicle.id) | \(r.days) day(s) | \(money(r.totalCost)) | \(r.status.rawValue)")
        }
    }

    // ----- FR3: Rental management -----
    @discardableResult
    func rent(vehicleID: String, customerID: String, days: Int) throws -> Rental {
        let vehicle = try findVehicle(vehicleID)
        let customer = try findCustomer(customerID)
        guard days > 0 else { throw RentalError.invalidDays }
        try vehicle.markRented()
        let rental = Rental(id: "R\(rentals.count + 1)", vehicle: vehicle, customer: customer, days: days)
        rentals.append(rental)
        customer.addRental(rental)
        print("[OK] \(customer.name) rented \(vehicle.id) for \(days) day(s). Total: \(money(rental.totalCost))")
        return rental
    }

    func returnVehicle(rentalID: String) throws {
        guard let rental = rentals.first(where: { $0.id == rentalID }) else {
            throw RentalError.notFound("Rental '\(rentalID)'")
        }
        try rental.complete()
        rental.vehicle.markReturned()
        print("[OK] Rental \(rental.id) returned. \(rental.vehicle.id) is available again.")
    }

    // ----- FR5: Rental information -----
    func showRental(_ id: String) throws {
        guard let r = rentals.first(where: { $0.id == id }) else {
            throw RentalError.notFound("Rental '\(id)'")
        }
        print(r.info())
    }

    // NEW: list all or only active rentals
    func listRentals(onlyActive: Bool = false) {
        print(onlyActive ? "--- ACTIVE RENTALS ---" : "--- ALL RENTALS ---")
        for r in rentals where !onlyActive || r.status == .active {
            print("  \(r.id) | \(r.vehicle.id) | \(r.customer.name) | \(r.days) day(s) | \(money(r.totalCost)) | \(r.status.rawValue)")
        }
    }
}