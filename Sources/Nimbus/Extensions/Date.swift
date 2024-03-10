//
// Created by Jacob Caraballo on 6/4/23
//
        

import Foundation

public extension Date {
	
	var startOfDay: Date { Self.currentCalendar.startOfDay(for: self) }
	
	var endOfDay: Date { Self.currentCalendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)! }
	
	static var currentCalendar: Calendar { Calendar.current }
	
	static var startOfYear: Date {
		currentCalendar.date(from: currentCalendar.dateComponents([.year], from: .now))!
	}
	
	static var endOfYear: Date {
		currentCalendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
	}
	
	init(day: Int? = nil, month: Int? = nil, year: Int? = nil) {
		let components = DateComponents(year: year, month: month, day: day)
		self = Calendar.current.date(from: components)!
	}
	
	static var daysForCurrentYear: [Date] {
		let calendar = Calendar.current
		
		var dates: [Date] = []
		var date = startOfYear
		
		while date <= endOfYear {
			dates.append(date)
			guard let nextDate = calendar.date(byAdding: .day, value: 1, to: date) else {
				break
			}
			date = nextDate
		}
		
		return dates
	}
}
