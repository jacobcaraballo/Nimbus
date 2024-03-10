//
// Created by Jacob Caraballo on 5/28/23
//
        

import Foundation
import UIKit

public protocol GraphDisplayPoint: UIView {
	
	var title: String? { get }
	
	var subtitle: String? { get }
	
	var value: Double { get }
	
	var valueFormatter: NumberFormatter { get set }
	
}

extension GraphDisplayPoint {
	
	public var valueString: String {
		valueFormatter.string(from: .init(floatLiteral: value)) ?? "N/A"
	}
	
}
