//
// Created by Jacob Caraballo on 4/2/23
//
        

import Foundation
import UIKit

/*
 let form = Form()
 form.addItem()
 */
class Form: UIViewController {
	
	typealias OnAction = () -> Void
	
}

extension Form {
	
	struct Item {
		
	}
	
	enum ItemType {
		
		/// A group of items.
		case group(title: String? = nil, items: [Self])
		
		/// Field for text input.
		case text(placeholder: String, defaultValue: String)
		
		/// Field for secure text input.
		case secureText(placeholder: String, defaultValue: String)
		
		/// Field for radio selection.
		case radio(isOn: Bool)
		
		/// Field for toggle selection.
		case toggle(isOn: Bool)
		
		/// Field for checkbox selection.
		case checkbox(isOn: Bool)
		
		/// Field for triggering a dropdown for option selection.
		case dropdown(options: [String], selectedIndex: Int?)
		
		/// Field for triggering a dropdown for multiple option selection.
		case multipleSelectionDropdown(options: [String], selectedIndices: [Int]?)
		
		/// Field for selecting a date.
		case date(date: Date? = nil)
		
		/// Field fo rselecting a date range.
		case dateRange(startDate: Date? = nil, endDate: Date? = nil)
		
	}
	
}
