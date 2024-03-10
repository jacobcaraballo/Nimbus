//
// Created by Jacob Caraballo on 5/28/23
//
        

import Foundation

extension NumberFormatter {
	
	public static var currencyFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()
	
}
