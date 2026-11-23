//
//  Car.swift
//  VehicleRental
//
//  Created by MAY 04 on 23/11/26.
//


import Foundation

// INHERITANCE: Car is a Vehicle
final class Car: Vehicle {
    let seats: Int
    let serviceFeePerDay: Int

    init(id: String, brand: String, model: String, dailyRate: Int,
         seats: Int, serviceFeePerDay: Int) {
        self.seats = seats
        self.serviceFeePerDay = serviceFeePerDay
        super.init(id: id, brand: brand, model: model, dailyRate: dailyRate)
    }

    override var typeName: String { return "Car" }
    override var details: String { return "\(seats) seats, service \(money(serviceFeePerDay))/day" }
    override var pricingRule: String { return "(daily rate + service fee) x days" }

    // POLYMORPHISM
    override func rentalCost(days: Int) -> Int {
        return (dailyRate + serviceFeePerDay) * days
    }
}