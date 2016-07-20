
import Foundation

extension Date {
    public func defaultString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, y"
        return formatter.string(from: self)
    }
    
    public static func dateWith(day: Int, month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar(identifier: Calendar.Identifier.gregorian)!.date(from: components)!
    }

}
