import Foundation

func money(_ amount: Int) -> String {
    var result = ""
    for (i, ch) in String(amount).reversed().enumerated() {
        if i > 0 && i % 3 == 0 { result.append(",") }
        result.append(ch)
    }
    return String(result.reversed()) + " VND"
}
