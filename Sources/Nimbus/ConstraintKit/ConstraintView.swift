//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

// MARK: - ConstraintView

public protocol ConstraintView {
	
	/// View that represents the safe area layout guide.
	var safe: ConstraintView { get }
	
	/// The superview to which this view belongs.
	var owningSuperview: UIView { get }
	
}

// MARK: - UIView + ConstraintView

extension UIView: ConstraintView {
	public var safe: ConstraintView { safeAreaLayoutGuide }
	
	public var owningSuperview: UIView { superview! }
}

extension UILayoutGuide: ConstraintView {
	public var safe: ConstraintView { self }
	
	public var owningSuperview: UIView { owningView!.owningSuperview }
}
