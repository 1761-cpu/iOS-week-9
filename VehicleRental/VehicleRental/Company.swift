import Foundation

class Company {
    var vehicles: [Vehicle] = []
    var customers: [Customer] = []
    var rentals: [Rental] = []

    // MARK: - Vehicle Management
    func addVehicle(_ v: Vehicle) throws {
        guard v.dailyRate > 0 else { throw RentalError.invalidData("Daily rate must be greater than 0.") }
        guard !vehicles.contains(where: { $0.id == v.id }) else { throw RentalError.duplicateID(v.id) }
        vehicles.append(v)
    }
    
    func findVehicle(_ id: String) throws -> Vehicle {
        guard let v = vehicles.first(where: { $0.id == id }) else {
            throw RentalError.notFound("Vehicle '\(id)'")
        }
        return v
    }
    
    func updateVehicle(_ id: String, brand: String? = nil, model: String? = nil, dailyRate: Int? = nil) throws {
        let v = try findVehicle(id)
        try v.update(brand: brand, model: model, dailyRate: dailyRate)
    }
    
    func listVehicles(onlyAvailable: Bool = false) {
        print("\n--- VEHICLE LIST ---")
        for v in vehicles where !onlyAvailable || v.isAvailable {
            print("  • \(v.info())")
        }
    }

    // MARK: - Customer Management
    @discardableResult
    func registerCustomer(name: String, phone: String, email: String) throws -> Customer {
        guard !name.isEmpty else { throw RentalError.invalidData("Customer name must not be empty.") }
        
        let c = Customer(id: "C\(customers.count + 1)", name: name, phone: phone, email: email)
        try c.updateContact(phone: phone, email: email) // Validate
        customers.append(c)
        return c
    }
    
    func findCustomer(_ id: String) throws -> Customer {
        guard let c = customers.first(where: { $0.id == id }) else {
            throw RentalError.notFound("Customer '\(id)'")
        }
        return c
    }
    
    func updateCustomerContact(_ id: String, phone: String, email: String) throws {
        let c = try findCustomer(id)
        try c.updateContact(phone: phone, email: email)
    }
    
    func listCustomers() {
        print("\n--- CUSTOMER LIST ---")
        for c in customers {
            print("  • \(c.info())")
        }
    }
    
    func showHistory(_ customerID: String) throws {
        let c = try findCustomer(customerID)
        print("\n--- RENTAL HISTORY OF \(c.name) ---")
        let history = rentals.filter { $0.customer.id == c.id }
        
        if history.isEmpty {
            print("  (No rentals yet)")
        } else {
            for r in history {
                print("  • \(r.id) | \(r.vehicle.id) | \(r.days) day(s) | \(money(r.totalCost)) | \(r.status)")
            }
        }
    }

    // MARK: - Rental Management
    @discardableResult
    func rent(vehicleID: String, customerID: String, days: Int) throws -> Rental {
        let vehicle  = try findVehicle(vehicleID)
        let customer = try findCustomer(customerID)
        guard days > 0 else { throw RentalError.invalidDays }
        
        try vehicle.markRented()
        let r = Rental(id: "R\(rentals.count + 1)", vehicle: vehicle, customer: customer, startDate: Date(), days: days)
        rentals.append(r)
        print("[OK] \(customer.name) rented \(vehicle.id) for \(days) day(s). Total: \(money(r.totalCost))")
        return r
    }
    
    func returnVehicle(rentalID: String) throws {
        guard let r = rentals.first(where: { $0.id == rentalID }) else {
            throw RentalError.notFound("Rental '\(rentalID)'")
        }
        try r.complete()
        r.vehicle.markReturned()
        print("[OK] Rental \(r.id) returned. \(r.vehicle.id) is available.")
    }
    
    func listRentals(onlyActive: Bool = false) {
        print("\n--- RENTAL LIST ---")
        for r in rentals where !onlyActive || !r.isReturned {
            print("  • \(r.id) | \(r.vehicle.id) | \(r.customer.name) | \(r.days)d | \(money(r.totalCost)) | \(r.status)")
        }
    }

    // MARK: - Statistics & Mock Data
    func getAvailableVehicles(on date: Date) -> [Vehicle] {
        return vehicles.filter { v in
            v.status != .defective &&
            !rentals.contains(where: { $0.vehicle.id == v.id && $0.startDate <= date && date <= $0.endDate })
        }
    }
    
    func getAvailableVehicles(from startDate: Date, to endDate: Date) -> [Vehicle] {
        return vehicles.filter { v in
            v.status != .defective &&
            !rentals.contains(where: { $0.vehicle.id == v.id && $0.startDate <= endDate && $0.endDate >= startDate })
        }
    }
    
    func getRevenue(forMonth month: Int, year: Int) -> (total: Int, byType: [String: Int]) {
        var total = 0
        var byType: [String: Int] = ["Car": 0, "Motorcycle": 0, "E-Bicycle": 0]
        let cal = Calendar.current
        
        for r in rentals {
            let c = cal.dateComponents([.month, .year], from: r.startDate)
            if c.month == month && c.year == year {
                total += r.totalCost
                byType[r.vehicle.typeName, default: 0] += r.totalCost
            }
        }
        return (total, byType)
    }
    
    func printDailyStatus(on date: Date) {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        print("\n--- VEHICLE STATUS ON \(df.string(from: date)) ---")
        
        for v in vehicles {
            if v.status == .defective {
                print("  • \(v.id) [\(v.typeName)] -> DEFECTIVE")
            } else if let r = rentals.first(where: { $0.vehicle.id == v.id && $0.startDate <= date && date <= $0.endDate }) {
                print("  • \(v.id) [\(v.typeName)] -> RENTED (by \(r.customer.name))")
            } else {
                print("  • \(v.id) [\(v.typeName)] -> AVAILABLE")
            }
        }
    }

    func generateMockData() {
        let brands = ["Toyota", "Honda", "Yamaha", "Yadea", "Hyundai"]
        
        // 1. Create 20 Vehicles
        for i in 1...20 {
            let id = "V-\(i)", brand = brands.randomElement()!
            let model = "Model-\(i)", rate = Int.random(in: 10...50) * 100_000
            if i <= 7 {
                vehicles.append(Car(id: id, brand: brand, model: model, dailyRate: rate, seats: Int.random(in: 4...7), serviceFeePerDay: 50_000))
            } else if i <= 14 {
                vehicles.append(Motorcycle(id: id, brand: brand, model: model, dailyRate: rate, engineCC: Int.random(in: 100...200)))
            } else {
                vehicles.append(ElectricBicycle(id: id, brand: brand, model: model, dailyRate: rate, batteryRangeKm: Int.random(in: 50...100), batteryFee: 20_000))
            }
        }
        
        // Mark 2 vehicles as defective
        vehicles[0].markDefective()
        vehicles[1].markDefective()

        // 2. Create 20 Customers
        for i in 1...20 {
            customers.append(Customer(id: "C-\(i)", name: "Customer \(i)", phone: "09000000\(String(format: "%02d", i))", email: "c\(i)@test.com"))
        }

        // 3. Create 100 Rentals
        let cal = Calendar.current
        let base = cal.date(from: DateComponents(year: 2026, month: 11, day: 1))!
        let availableVehicles = vehicles.filter { $0.status != .defective }
        
        for i in 1...100 {
            let v = availableVehicles.randomElement()!
            let c = customers.randomElement()!
            let start = cal.date(byAdding: .day, value: Int.random(in: 0...29), to: base)!
            let days = Int.random(in: 1...5)
            
            let r = Rental(id: "R-\(i)", vehicle: v, customer: c, startDate: start, days: days)
            if r.endDate < Date() { r.isReturned = true }
            rentals.append(r)
        }
        
        // Sync vehicle status for currently active rentals
        let now = Date()
        for v in vehicles where v.status == .available {
            let isOut = rentals.contains { $0.vehicle.id == v.id && !$0.isReturned && $0.startDate <= now && now <= $0.endDate }
            if isOut { try? v.markRented() }
        }
    }
}
