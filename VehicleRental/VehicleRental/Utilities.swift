import Foundation

func money(_ amount: Int) -> String {
    var result = ""
    for (i, ch) in String(amount).reversed().enumerated() {
        if i > 0 && i % 3 == 0 { result.append(",") }
        result.append(ch)
    }
    return String(result.reversed()) + " VND"
}

func printHeader(_ title: String) {
    print("\n=============================================")
    print("  \(title)")
    print("=============================================")
}

func getInput(_ prompt: String) -> String {
    print(prompt, terminator: "")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func getIntInput(_ prompt: String) -> Int? {
    return Int(getInput(prompt))
}

func getDateInput(_ prompt: String) -> Date? {
    let f = DateFormatter()
    f.dateFormat = "dd/MM/yyyy"
    return f.date(from: getInput(prompt))
}
