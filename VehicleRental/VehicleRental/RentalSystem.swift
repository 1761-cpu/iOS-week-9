import Foundation

// RENTAL SYSTEM (manager class, like InventoryManager)
// All collections are private: outside code must use the methods below.
final class RentalSystem {
    private var vehicles: [Vehicle] = []
    private var customers: [Customer] = []
    private var rentals: [Rental] = []
    private var nextCustomerNumber = 1
    private var nextRentalNumber = 1

    // MARK: - FR1 Vehicle management

    func addVehicle(_ vehicle: Vehicle) throws {
        guard !vehicles.contains(where: { sameID($0.id, vehicle.id) }) else {
            throw RentalError.duplicateVehicle(vehicle.id)
        }
        vehicles.append(vehicle)
        print("[OK] Added vehicle: \(vehicle.id) - \(vehicle.brand) \(vehicle.model)")
    }

    func findVehicle(id: String) throws -> Vehicle {
        guard let v = vehicles.first(where: { sameID($0.id, id) }) else {
            throw RentalError.vehicleNotFound(id)
        }
        return v
    }

    func printVehicleDetails(id: String) throws {
        let v = try findVehicle(id: id)
        print(v.detailedDescription())
    }

    func updateVehicleInfo(id: String, brand: String? = nil, model: String? = nil,
                           dailyRate: Double? = nil) throws {
        let v = try findVehicle(id: id)
        try v.updateBasicInfo(brand: brand, model: model, dailyRate: dailyRate)
        print("[OK] Updated vehicle \(v.id): \(v.brand) \(v.model), \(formatVND(v.dailyRate))/day")
    }

    @discardableResult
    func checkAvailability(id: String) throws -> Bool {
        let v = try findVehicle(id: id)
        print("Vehicle \(v.id) is \(v.isAvailable ? "AVAILABLE" : "NOT available (\(v.status.rawValue))").")
        return v.isAvailable
    }

    func markVehicleUnderMaintenance(id: String) throws {
        let v = try findVehicle(id: id)
        try v.sendToMaintenance()
        print("[OK] Vehicle \(v.id) is now under maintenance.")
    }

    func finishMaintenance(id: String) throws {
        let v = try findVehicle(id: id)
        v.finishMaintenance()
        print("[OK] Vehicle \(v.id) status: \(v.status.rawValue).")
    }

    func listVehicles(onlyAvailable: Bool = false) {
        let list = onlyAvailable ? vehicles.filter { $0.isAvailable } : vehicles
        print(onlyAvailable ? "--- AVAILABLE VEHICLES ---" : "--- ALL VEHICLES ---")
        if list.isEmpty { print("  (none)") }
        for v in list { print("  " + v.describe()) }
        let available = vehicles.filter { $0.status == .available }.count
        let rented = vehicles.filter { $0.status == .rented }.count
        let maintenance = vehicles.filter { $0.status == .maintenance }.count
        print("  Total: \(vehicles.count) | Available: \(available) | Rented: \(rented) | Maintenance: \(maintenance)")
    }

    // MARK: - FR2 Customer management

    @discardableResult
    func registerCustomer(name: String, phone: String, email: String) throws -> Customer {
        let id = String(format: "C%03d", nextCustomerNumber)
        let customer = try Customer(id: id, name: name, phone: phone, email: email)
        nextCustomerNumber += 1          // only consumed when registration succeeds
        customers.append(customer)
        print("[OK] Registered customer \(customer.id): \(customer.name)")
        return customer
    }

    func findCustomer(id: String) throws -> Customer {
        guard let c = customers.first(where: { sameID($0.id, id) }) else {
            throw RentalError.customerNotFound(id)
        }
        return c
    }

    func printCustomerDetails(id: String) throws {
        let customer = try findCustomer(id: id)
        print("  " + customer.describe())
    }

    func listCustomers() {
        print("--- ALL CUSTOMERS ---")
        if customers.isEmpty { print("  (none)") }
        for c in customers { print("  " + c.describe()) }
    }

    func updateCustomerContact(id: String, phone: String? = nil, email: String? = nil) throws {
        let c = try findCustomer(id: id)
        try c.updateContact(phone: phone, email: email)
        print("[OK] Updated contact of \(c.id): \(c.phone) | \(c.email)")
    }

    func printCustomerHistory(id: String) throws {
        let c = try findCustomer(id: id)
        print("--- RENTAL HISTORY: \(c.id) - \(c.name) ---")
        if c.rentalHistory.isEmpty { print("  (no rentals yet)") }
        for r in c.rentalHistory { print("  " + r.summaryLine()) }
    }

    // MARK: - FR3 Rental management

    @discardableResult
    func rentVehicle(vehicleID: String, customerID: String, days: Int) throws -> Rental {
        // 1) validate everything first
        let vehicle = try findVehicle(id: vehicleID)
        let customer = try findCustomer(id: customerID)
        guard days > 0 else { throw RentalError.invalidRentalDuration(days) }
        guard vehicle.isAvailable else {
            throw RentalError.vehicleNotAvailable(id: vehicle.id, status: vehicle.status)
        }
        // 2) then change state
        let rental = try Rental(id: String(format: "R%03d", nextRentalNumber),
                                vehicle: vehicle, customer: customer, days: days)
        try vehicle.markRented()
        nextRentalNumber += 1
        customer.addRental(rental)
        rentals.append(rental)
        print("[OK] \(customer.name) rented \(vehicle.brand) \(vehicle.model) for \(days) day(s). "
              + "Rental \(rental.id), total: \(formatVND(rental.totalCost))")
        return rental
    }

    @discardableResult
    func returnVehicle(rentalID: String) throws -> Rental {
        guard let rental = rentals.first(where: { sameID($0.id, rentalID) }) else {
            throw RentalError.rentalNotFound(rentalID)
        }
        try rental.markReturned()
        try rental.vehicle.markReturned()
        print("[OK] Rental \(rental.id) returned. \(rental.vehicle.id) is available again. "
              + "Amount due: \(formatVND(rental.totalCost))")
        return rental
    }

    // MARK: - FR5 Rental information display

    func printRentalInfo(rentalID: String) throws {
        guard let rental = rentals.first(where: { sameID($0.id, rentalID) }) else {
            throw RentalError.rentalNotFound(rentalID)
        }
        print(rental.describe())
    }

    func printAllRentals(onlyActive: Bool = false) {
        let list = onlyActive ? rentals.filter { $0.status == .active } : rentals
        print(onlyActive ? "--- ACTIVE RENTALS ---" : "--- ALL RENTALS ---")
        if list.isEmpty { print("  (none)") }
        for r in list { print("  " + r.summaryLine() + " | Customer: \(r.customer.name)") }
    }

    // MARK: - Helper
    private func sameID(_ a: String, _ b: String) -> Bool {
        return a.caseInsensitiveCompare(b.trimmingCharacters(in: .whitespaces)) == .orderedSame
    }
}
