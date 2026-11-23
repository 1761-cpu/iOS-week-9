import Foundation

class Customer {
    let id: String
    var name: String
    var phone: String
    var email: String

    init(id: String, name: String, phone: String, email: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
    }

    func updateContact(phone: String, email: String) throws {
        guard phone.count >= 10, phone.allSatisfy({ $0.isNumber }) else {
            throw RentalError.invalidData("Phone must be at least 10 digits.")
        }
        guard email.contains("@") else {
            throw RentalError.invalidData("Invalid email format.")
        }
        self.phone = phone
        self.email = email
    }

    func info() -> String {
        return "\(id) | \(name) | \(phone) | \(email)"
    }
}
