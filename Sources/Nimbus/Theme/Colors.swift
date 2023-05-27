//
// Created by Jacob Caraballo on 5/6/23
//
        

import Foundation
import UIKit

public protocol ThemeColors {
	
	static var primaryBackground: UIColor { get }
	
	static var secondaryBackground: UIColor { get }
	
	static var primaryLabel: UIColor { get }
	
	static var secondaryLabel: UIColor { get }
	
}

public struct Colors: ThemeColors {
	
	static var bundle: Bundle = .myPackage
	
	private static func getColor(named name: String) -> UIColor {
		.init(named: name, in: bundle, compatibleWith: .current)!
	}
	
	public static var primaryBackground: UIColor {
		getColor(named: "PrimaryBackground")
	}
	
	public static var secondaryBackground: UIColor {
		getColor(named: "SecondaryBackground")
	}
	
	public static var primaryLabel: UIColor {
		getColor(named: "PrimaryLabel")
	}
	
	public static var secondaryLabel: UIColor {
		getColor(named: "SecondaryLabel")
	}
	
	public static var highlightedBackground: UIColor {
		getColor(named: "HighlightedBackground")
	}
	
}
