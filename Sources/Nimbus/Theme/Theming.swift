//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

public protocol Theming {
	
	var options: [ThemingOptions] { get }
	
}

extension Theming {
	
	public func apply(to view: UIView) {
		options.forEach {
			$0.apply(to: view)
		}
	}
	
}

public enum ThemingOptions {
	
	case backgroundColor(UIColor)
	
	case tintColor(UIColor)
	
	case corners(UIView.Corner, CACornerMask = [])
	
	case shadow(Set<UIView.Shadow> = UIView.Shadow.default)
	
	case border(_ border: UIView.Border, color: UIColor = .separator)
	
	case text(font: UIFont, color: UIColor)
	
	case buttonConfiguration(_ config: UIButton.Configuration)
	
	case layoutMargins(_ layoutMargins: UIEdgeInsets)
	
	case textAlignment(_ alignment: NSTextAlignment)
	
}

extension ThemingOptions {
	
	public func apply(to view: UIView) {
		
		switch self {
		case let .backgroundColor(color):
			view.backgroundColor = color
			
		case let .tintColor(color):
			view.tintColor = color
			
		case let .corners(corners, masks):
			view.setCorners(corners, masking: masks)
			
		case let .shadow(shadow):
			view.setShadow(shadow)
			
		case let .border(border, color):
			view.setBorder(border, color: color)
			
		case let .text(font, color):
			guard let label = view as? UILabel else { break }
			label.font = font
			label.textColor = color
			
		case let .buttonConfiguration(config):
			guard let button = view as? UIButton else { break }
			button.configuration = config
			
		case let .layoutMargins(layoutMargins):
			guard let stackView = view as? UIStackView else { break }
			stackView.layoutMargins = layoutMargins
			stackView.isLayoutMarginsRelativeArrangement = true
			
		case let .textAlignment(alignment):
			if let textLabel = view as? UILabel {
				textLabel.textAlignment = alignment
			} else if let stackView = view as? UIStackView {
				stackView.arrangedSubviews.forEach { subview in
					self.apply(to: subview)
				}
			} else {
				view.subviews.forEach { subview in
					self.apply(to: subview)
				}
			}
			
		}
		
	}
	
}
