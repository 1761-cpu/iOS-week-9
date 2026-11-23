import Foundation

// MARK: - Class
class Rental {
    let id: String
    let vehicle: Vehicle
    let customer: Customer
    
    let startDate: Date
    let endDate: Date
    let days: Int
    let totalCost: Int
    
    var isReturned: Bool = false

    init(id: String, vehicle: Vehicle, customer: Customer, startDate: Date, days: Int) {
        self.id = id
        self.vehicle = vehicle
        self.customer = customer
        self.startDate = startDate
        self.days = days
        self.endDate = Calendar.current.date(byAdding: .day, value: days - 1, to: startDate)!
        
        self.totalCost = vehicle.rentalCost(days: days)
    }

    var status: String { return isReturned ? "Returned" : "Active" }

    func complete() throws {
        guard !isReturned else { throw RentalError.alreadyReturned(id) }
        isReturned = true
    }

    func info() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return """
        Rental \(id) - Status: \(status)
          Vehicle : \(vehicle.info())
          Customer: \(customer.name) (\(customer.id))
          Period  : \(df.string(from: startDate)) to \(df.string(from: endDate)) (\(days) day(s))
          Total   : \(money(totalCost))
        """
    }
}

// MARK: - Error
enum RentalError: Error, CustomStringConvertible {
    case invalidData(String)
    case notFound(String)
    case duplicateID(String)
    case notAvailable(String)
    case invalidDays
    case alreadyReturned(String)

    var description: String {
        switch self {
        case .invalidData(let msg):      return msg
        case .notFound(let what):        return "\(what) was not found."
        case .duplicateID(let id):       return "ID '\(id)' already exists."
        case .notAvailable(let id):      return "Vehicle '\(id)' is not available for rent."
        case .invalidDays:               return "Rental duration must be at least 1 day."
        case .alreadyReturned(let id):   return "Rental '\(id)' has already been returned."
        }
    }
}
