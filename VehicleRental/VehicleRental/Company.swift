import Foundation

class Company {
    // Mảng riêng biệt cho từng thực thể để dễ quản lý
    var vehicles: [Vehicle] = []
    var customers: [Customer] = []
    var rentals: [Rental] = []

    // MARK: - Quản lý Xe
    func addVehicle(_ v: Vehicle) throws {
        guard !vehicles.contains(where: { $0.id == v.id }) else { throw RentalError.duplicateID(v.id) }
        vehicles.append(v)
        print("[OK] Added vehicle \(v.id)")
    }

    func findVehicle(_ id: String) throws -> Vehicle {
        guard let v = vehicles.first(where: { $0.id == id }) else { throw RentalError.notFound("Vehicle '\(id)'") }
        return v
    }

    func listVehicles() {
        print("\n--- ALL VEHICLES ---")
        for v in vehicles { print("  • \(v.info())") }
    }

    // MARK: - Quản lý Khách hàng
    @discardableResult
    func registerCustomer(name: String, phone: String, email: String) throws -> Customer {
        try validateContact(phone: phone, email: email)
        let c = Customer(id: "C\(customers.count + 1)", name: name, phone: phone, email: email)
        customers.append(c)
        print("[OK] Registered customer \(c.id) - \(c.name)")
        return c
    }

    func findCustomer(_ id: String) throws -> Customer {
        guard let c = customers.first(where: { $0.id == id }) else { throw RentalError.notFound("Customer '\(id)'") }
        return c
    }

    func listCustomers() {
        print("\n--- ALL CUSTOMERS ---")
        for c in customers { print("  • \(c.info())") }
    }

    // MARK: - Quản lý Thuê Xe (Rentals)
    @discardableResult
    func rent(vehicleID: String, customerID: String, days: Int) throws -> Rental {
        let vehicle = try findVehicle(vehicleID)
        let customer = try findCustomer(customerID)
        
        guard days > 0 else { throw RentalError.invalidDays }
        guard vehicle.status == .available else { throw RentalError.notAvailable(vehicleID) }
        
        // 1. Đổi trạng thái xe
        vehicle.status = .rented
        
        // 2. Tạo hoá đơn thuê và lưu vào mảng rentals
        let rental = Rental(id: "R\(rentals.count + 1)", vehicle: vehicle, customer: customer, days: days)
        rentals.append(rental)
        
        print("[OK] \(customer.name) rented \(vehicle.id) for \(days) day(s). Total: \(money(rental.totalCost))")
        return rental
    }

    func returnVehicle(rentalID: String) throws {
        guard let rental = rentals.first(where: { $0.id == rentalID }) else {
            throw RentalError.notFound("Rental '\(rentalID)'")
        }
        guard !rental.isReturned else {
            throw RentalError.alreadyReturned(rentalID)
        }
        
        // 1. Đánh dấu hoá đơn đã trả
        rental.isReturned = true
        
        // 2. Trả lại trạng thái Available cho xe
        rental.vehicle.status = .available
        
        print("[OK] Rental \(rental.id) returned. \(rental.vehicle.id) is available again.")
    }

    func listRentals() {
        print("\n--- ALL RENTALS ---")
        for r in rentals { print("  • \(r.info())") }
    }
}