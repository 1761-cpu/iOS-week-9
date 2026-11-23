//
//  Customer.swift
//  VehicleRental
//
//  Created by MAY 04 on 23/11/26.
//


import Foundation

class Customer {
    let id: String
    let name: String
    private(set) var phone: String
    private(set) var email: String
    private(set) var history: [Rental] = []

    init(id: String, name: String, phone: String, email: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
    }

    func updateContact(phone: String, email: String) throws {
        try validateContact(phone: phone, email: email)
        self.phone = phone
        self.email = email
    }

    func addRental(_ rental: Rental) { history.append(rental) }

    func info() -> String {
        return "\(id) | \(name) | \(phone) | \(email) | rentals: \(history.count)"
    }
}