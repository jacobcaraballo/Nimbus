//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

public indirect enum ConstraintTarget {
	public enum Option {
		case safe
		case regular
		
		internal func target(for view: UIView) -> ConstraintView {
			switch self {
			case .safe:
				return view.safeAreaLayoutGuide
				
			case .regular:
				return view
			}
		}
	}
	
	case `self`
	case superview
	case target(ConstraintView, NSLayoutConstraint.Attribute? = nil)
	case safe(Self)
	
	internal func targetView(for view: ConstraintView) -> ConstraintView {
		switch self {
		case .self:
			return view
			
		case .superview:
			return view.owningSuperview
			
		case let .target(target, _):
			return target
			
		case let .safe(target):
			return target.targetView(for: view).safe
			
		}
	}
	
	internal var targetAttribute: NSLayoutConstraint.Attribute? {
		switch self {
		case .self,
				.superview,
				.safe:
			return nil
			
		case let .target(_, attribute):
			return attribute
		}
	}
	
}
