//
//  FormattedTimestamp.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/23/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

extension Date {
    
    // Convenient accessor of the date's `Calendar` components.
    // - parameter component: The calendar component to access from the date
    // - returns: The value of the component
    
    private func component(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(component, from: self)
    }
    
    // Determine if date is within the current day
    var isToday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInToday(self)
    }
    
    // Determine if date is within yesterday
    var isYesterday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInYesterday(self)
    }
    
    // ---------------------------------------------------------------- //
    
    // The number of days the receiver's date is earlier than now (0 if the receiver is
    // the same or earlier than now).
    var daysAgo: Int {
        return daysEarlier(than: Date())
    }
    
    //  Returns the number of days the receiver's date is earlier than the provided
    //  comparison date, 0 if the receiver's date is later than or equal to the provided comparison date.
    //  - parameter date: Provided date for comparison
    //  - returns: The number of days
    
    private func earlierDate(_ date:Date) -> Date {
        return (self.timeIntervalSince1970 <= date.timeIntervalSince1970) ? self : date
    }
    
    
    //   Returns an Int representing the amount of time in days between the receiver and
    //   the provided date.
    //   if the receiver is earlier than the provided date, the returned value will be negative.
    //   - parameter date: The provided date for comparison
    //   - parameter calendar: The calendar to be used in the calculation
    //   - returns: The days between receiver and provided date
    
    private func days(from date: Date, calendar: Calendar?) -> Int {
        var calendarCopy = calendar
        if (calendar == nil) {
            calendarCopy = Calendar.autoupdatingCurrent
        }
        
        let earliest = earlierDate(date)
        let latest = (earliest == self) ? date : self
        let multiplier = (earliest == self) ? -1 : 1
        let components = calendarCopy!.dateComponents([.day], from: earliest, to: latest)
        return multiplier*components.day!
    }
    
    
    // Returns an Int representing the amount of time in days between the receiver and
    // the provided date.
    // If the receiver is earlier than the provided date, the returned value will be negative.
    // Uses the default Gregorian calendar
    // - parameter date: The provided date for comparison
    // - returns: The days between receiver and provided date
    
    private func days(from date: Date) -> Int {
        return days(from: date, calendar: nil)
    }
    
    
    //  Return the earlier of two dates, between self and a given date.
    //  - parameter date: The date to compare to self
    //  - returns: The date that is earlier
    
    private func daysEarlier(than date: Date) -> Int {
        return abs(min(days(from: date), 0))
        
    }
    
    // Convenience getter for the date's `weekday` component
    var weekday: Int {
        return component(.weekday)
    }
    
    // TableView timestamp
    func formattedTableViewString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        if isToday {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        } else if isYesterday {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
        } else if daysAgo < 7 {
            return dateFormatter.weekdaySymbols[weekday - 1]
        } else {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
        }
        
        return dateFormatter.string(from: self)
    }
    
}
