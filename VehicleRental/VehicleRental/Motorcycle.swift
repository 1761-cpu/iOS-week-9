//
//  Motorcycle.swift
//  VehicleRental
//
//  Created by MAY 04 on 23/11/26.
//


import Foundation

final class Motorcycle: Vehicle {
    let engineCC: Int

    init(id: String, brand: String, model: String, dailyRate: Int, engineCC: Int) {
        self.engineCC = engineCC
        super.init(id: id, brand: brand, model: model, dailyRate: dailyRate)
    }

    var engineCategory: String {
        return engineCC <= 125 ? "Small" : (engineCC <= 175 ? "Medium" : "Large")
    }
    private var ratePercent: Int {
        return engineCC <= 125 ? 100 : (engineCC <= 175 ? 125 : 160)
    }

    override var typeName: String { return "Motorcycle" }
    override var details: String { return "\(engineCC)cc (\(engineCategory))" }
    override var pricingRule: String { return "daily rate x engine factor (\(ratePercent)%) x days" }

    override func rentalCost(days: Int) -> Int {
        return dailyRate * ratePercent * days / 100
    }
}