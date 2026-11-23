import Foundation

class Car: Vehicle {
    var seats: Int
    var serviceFeePerDay: Int
    
    init(id: String, brand: String, model: String, dailyRate: Int, seats: Int, serviceFeePerDay: Int) {
        self.seats = seats
        self.serviceFeePerDay = serviceFeePerDay
        super.init(id: id, brand: brand, model: model, dailyRate: dailyRate)
    }
    
    override var typeName: String { "Car" }
    override var details: String  { "\(seats) seats, service \(money(serviceFeePerDay))/day" }
    
    override func rentalCost(days: Int) -> Int {
        return (dailyRate + serviceFeePerDay) * days
    }
}

class Motorcycle: Vehicle {
    var engineCC: Int
    
    init(id: String, brand: String, model: String, dailyRate: Int, engineCC: Int) {
        self.engineCC = engineCC
        super.init(id: id, brand: brand, model: model, dailyRate: dailyRate)
    }
    
    private var ratePercent: Int { engineCC <= 125 ? 100 : (engineCC <= 175 ? 125 : 160) }
    
    override var typeName: String { "Motorcycle" }
    override var details: String  { "\(engineCC)cc" }
    
    override func rentalCost(days: Int) -> Int {
        return dailyRate * ratePercent * days / 100
    }
}

class ElectricBicycle: Vehicle {
    var batteryRangeKm: Int
    var batteryFee: Int
    
    init(id: String, brand: String, model: String, dailyRate: Int, batteryRangeKm: Int, batteryFee: Int) {
        self.batteryRangeKm = batteryRangeKm
        self.batteryFee = batteryFee
        super.init(id: id, brand: brand, model: model, dailyRate: dailyRate)
    }
    
    override var typeName: String { "E-Bicycle" }
    override var details: String  { "range \(batteryRangeKm)km, battery fee \(money(batteryFee))" }
    
    override func rentalCost(days: Int) -> Int {
        return dailyRate * days + batteryFee
    }
}
