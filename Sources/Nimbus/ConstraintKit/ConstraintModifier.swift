//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

public enum ConstraintModifier {
	case multiplier(CGFloat)
	case constant(CGFloat)
	case priority(UILayoutPriority)
	case margins(UIEdgeInsets)
	
	internal func modifiedConstraint(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint {
		switch self {
		case let .multiplier(value):
			return constraint.updatingMultiplier(value)
			
		case let .constant(value):
			constraint.constant = value
			return constraint
			
		case let .priority(value):
			constraint.priority = value
			return constraint
			
		case let .margins(insets):
			switch constraint.firstAttribute {
			case .leading,
					.left,
					.leadingMargin:
				return ConstraintModifier
					.constant(insets.left)
					.modifiedConstraint(constraint)
				
			case .top,
					.topMargin:
				return ConstraintModifier
					.constant(insets.top)
					.modifiedConstraint(constraint)
				
			case .trailing,
					.right,
					.trailingMargin:
				return ConstraintModifier
					.constant(-insets.right)
					.modifiedConstraint(constraint)
				
			case .bottom,
					.bottomMargin:
				return ConstraintModifier
					.constant(-insets.bottom)
					.modifiedConstraint(constraint)
				
			case .width:
				return ConstraintModifier
					.constant(-(insets.left + insets.right))
					.modifiedConstraint(constraint)
				
			case .height:
				return ConstraintModifier
					.constant(-(insets.top + insets.bottom))
					.modifiedConstraint(constraint)
				
			default:
				return constraint
			}
			
		}
	}
}

// MARK: - Modifier Arrays

extension Array where Element == ConstraintModifier {
	
	public static func multiplier(_ value: CGFloat) -> [ConstraintModifier] {
		[ .multiplier(value) ]
	}
	
	public static func constant(_ value: CGFloat) -> [ConstraintModifier] {
		[ .constant(value) ]
	}
	
	public static func priority(_ value: UILayoutPriority) -> [ConstraintModifier] {
		[ .priority(value) ]
	}
	
	public static func margins(_ value: UIEdgeInsets) -> [ConstraintModifier] {
		[ .margins(value) ]
	}
	
}
