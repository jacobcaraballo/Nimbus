//
// Created by Jacob Caraballo on 5/28/23
//
        

import Foundation
import UIKit

class LineGraphDisplayPoint: UIView, GraphDisplayPoint {
	
	// MARK: - Init
	
	public init(
		title: String? = nil,
		subtitle: String? = nil,
		value: Double,
		dateRange: ClosedRange<Date>,
		valueFormatter: NumberFormatter = .currencyFormatter
	) {
		self.title = title
		self.subtitle = subtitle
		self.value = value
		self.dateRange = dateRange
		self.valueFormatter = valueFormatter
		
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Properties
	
	let id = UUID()
	
	var title: String?
	
	var subtitle: String?
	
	var value: Double
	
	var dateRange: ClosedRange<Date>
	
	var valueFormatter: NumberFormatter
	
}
