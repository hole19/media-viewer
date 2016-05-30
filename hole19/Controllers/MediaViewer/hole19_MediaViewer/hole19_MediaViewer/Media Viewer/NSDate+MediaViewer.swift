
import Foundation

extension NSDate {
    func defaultString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, y"
        return formatter.stringFromDate(self)
    }
    
    class func dateWith(day day: Int, month: Int, year: Int) -> NSDate {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        return NSCalendar(identifier: NSCalendarIdentifierGregorian)!.dateFromComponents(components)!
    }

}