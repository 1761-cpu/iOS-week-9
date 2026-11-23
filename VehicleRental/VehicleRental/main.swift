import Foundation

let company = Company()
company.generateMockData()

var isRunning = true

while isRunning {
    printHeader("VEHICLE RENTAL MANAGEMENT SYSTEM")
    print("""
    1. Vehicle Management
    2. Customer Management
    3. Rental Operations
    4. Statistics & Reports
    0. Exit
    """)
    
    switch getInput("Choose an option: ") {
    case "1":
        var inMenu = true
        while inMenu {
            printHeader("VEHICLE MANAGEMENT")
            print("""
            1. List all vehicles
            2. List available vehicles
            3. Update vehicle info
            0. Back to main menu
            """)
            switch getInput("Choose: ") {
            case "1":
                company.listVehicles()
            case "2":
                company.listVehicles(onlyAvailable: true)
            case "3":
                let id = getInput("Enter Vehicle ID: ")
                let rateStr = getInput("Enter new Daily Rate (leave blank to skip): ")
                let newRate = rateStr.isEmpty ? nil : Int(rateStr)
                do {
                    try company.updateVehicle(id, dailyRate: newRate)
                    print("[OK] Vehicle updated.")
                } catch { print("[ERROR] \(error)") }
            case "0": inMenu = false
            default: print("Invalid option.")
            }
        }
        
    case "2":
        var inMenu = true
        while inMenu {
            printHeader("CUSTOMER MANAGEMENT")
            print("""
            1. List all customers
            2. Register new customer
            3. Update customer contact
            4. View customer rental history
            0. Back to main menu
            """)
            switch getInput("Choose: ") {
            case "1":
                company.listCustomers()
            case "2":
                let name = getInput("Name: ")
                let phone = getInput("Phone: ")
                let email = getInput("Email: ")
                do {
                    let c = try company.registerCustomer(name: name, phone: phone, email: email)
                    print("[OK] Registered \(c.id)")
                } catch { print("[ERROR] \(error)") }
            case "3":
                let id = getInput("Customer ID: ")
                let phone = getInput("New Phone: ")
                let email = getInput("New Email: ")
                do {
                    try company.updateCustomerContact(id, phone: phone, email: email)
                    print("[OK] Contact updated.")
                } catch { print("[ERROR] \(error)") }
            case "4":
                let id = getInput("Customer ID: ")
                do { try company.showHistory(id) } catch { print("[ERROR] \(error)") }
            case "0": inMenu = false
            default: print("Invalid option.")
            }
        }
        
    case "3":
        var inMenu = true
        while inMenu {
            printHeader("RENTAL OPERATIONS")
            print("""
            1. Rent a vehicle
            2. Return a vehicle
            3. List all rentals
            4. List active rentals
            0. Back to main menu
            """)
            switch getInput("Choose: ") {
            case "1":
                let vID = getInput("Vehicle ID: ")
                let cID = getInput("Customer ID: ")
                guard let days = getIntInput("Rental Days: ") else { continue }
                do { try company.rent(vehicleID: vID, customerID: cID, days: days) }
                catch { print("[ERROR] \(error)") }
            case "2":
                let rID = getInput("Rental ID: ")
                do { try company.returnVehicle(rentalID: rID) }
                catch { print("[ERROR] \(error)") }
            case "3":
                company.listRentals()
            case "4":
                company.listRentals(onlyActive: true)
            case "0": inMenu = false
            default: print("Invalid option.")
            }
        }
        
    case "4":
        var inMenu = true
        while inMenu {
            printHeader("STATISTICS & REPORTS")
            print("""
            1. Available vehicles on a specific date
            2. Available vehicles in a date range
            3. Revenue by month
            4. Daily status of all vehicles
            0. Back to main menu
            """)
            switch getInput("Choose: ") {
            case "1":
                guard let d = getDateInput("Date (dd/MM/yyyy): ") else { print("Invalid date"); continue }
                let list = company.getAvailableVehicles(on: d)
                print("\nFound \(list.count) available vehicle(s):")
                for v in list { print("  • \(v.info())") }
            case "2":
                guard let s = getDateInput("From (dd/MM/yyyy): "), let e = getDateInput("To (dd/MM/yyyy): ") else { print("Invalid date"); continue }
                let list = company.getAvailableVehicles(from: s, to: e)
                print("\nFound \(list.count) available vehicle(s):")
                for v in list { print("  • \(v.info())") }
            case "3":
                guard let m = getIntInput("Month (1-12): "), let y = getIntInput("Year (e.g., 2026): ") else { continue }
                let rev = company.getRevenue(forMonth: m, year: y)
                printHeader("REVENUE FOR \(m)/\(y)")
                print("TOTAL: \(money(rev.total))")
                for (t, a) in rev.byType { print("  • \(t): \(money(a))") }
            case "4":
                guard let d = getDateInput("Date (dd/MM/yyyy): ") else { print("Invalid date"); continue }
                company.printDailyStatus(on: d)
            case "0": inMenu = false
            default: print("Invalid option.")
            }
        }
        
    case "0":
        isRunning = false
        print("Exiting system. Goodbye!")
        
    default:
        print("Invalid option. Please try again.")
    }
}
