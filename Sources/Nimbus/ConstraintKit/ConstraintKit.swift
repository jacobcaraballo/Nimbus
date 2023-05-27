//
//  ConstraintKit.swift
//  atmos
//
//  Created by Jacob Caraballo on 9/13/22.
//

import Foundation
import UIKit

extension UIView {
	
	@discardableResult
	private func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, to target: ConstraintTarget, relatedBy: NSLayoutConstraint.Relation, modifiers: [ConstraintModifier]) -> [NSLayoutConstraint] {
		translatesAutoresizingMaskIntoConstraints = false
		
		let constraints = attributes.map {
			$0.createConstraint(from: self, relation: relatedBy, to: target)
				.modifying(by: modifiers)
		}
		
		NSLayoutConstraint.activate(constraints)
		
		return constraints
	}
	
	@discardableResult
	public func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, to target: ConstraintTarget = .superview, modifiers: [ConstraintModifier] = []) -> [NSLayoutConstraint] {
		self.constrain(attributes, to: target, relatedBy: .equal, modifiers: modifiers)
	}
	
	@discardableResult
	public func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, greaterThanOrEqualTo target: ConstraintTarget, modifiers: [ConstraintModifier] = []) -> [NSLayoutConstraint] {
		self.constrain(attributes, to: target, relatedBy: .greaterThanOrEqual, modifiers: modifiers)
	}
	
	@discardableResult
	public func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, greaterThanOrEqualToConstant constant: CGFloat) -> [NSLayoutConstraint] {
		let constraints = attributes.compactMap { attribute -> NSLayoutConstraint? in
			switch attribute {
			case .height:
				return heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
				
			case .width:
				return widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
				
			default:
				return nil
			}
		}
		
		constraints.forEach {
			$0.isActive = true
		}
		
		return constraints
	}
	
	@discardableResult
	public func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, lessThanOrEqualToConstant constant: CGFloat) -> [NSLayoutConstraint] {
		let constraints = attributes.compactMap { attribute -> NSLayoutConstraint? in
			switch attribute {
			case .height:
				return heightAnchor.constraint(lessThanOrEqualToConstant: constant)
				
			case .width:
				return widthAnchor.constraint(lessThanOrEqualToConstant: constant)
				
			default:
				return nil
			}
		}
		
		constraints.forEach {
			$0.isActive = true
		}
		
		return constraints
	}
	
	@discardableResult
	public func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, lessThanOrEqualTo target: ConstraintTarget, modifiers: [ConstraintModifier] = []) -> [NSLayoutConstraint] {
		self.constrain(attributes, to: target, relatedBy: .lessThanOrEqual, modifiers: modifiers)
	}
	
	@discardableResult
	public func constrain(_ attributes: Set<NSLayoutConstraint.Attribute>, toConstant constant: CGFloat) -> [NSLayoutConstraint] {
		attributes.flatMap { self.constrainDimansionalAttribute($0, toConstant: constant) }
	}
	
	@discardableResult
	private func constrainDimansionalAttribute(_ attribute: NSLayoutConstraint.Attribute, toConstant constant: CGFloat) -> [NSLayoutConstraint] {
		switch attribute {
		case .height:
			let constraint = heightAnchor.constraint(equalToConstant: constant)
			constraint.isActive = true
			return [ constraint ]
			
		case .width:
			let constraint = widthAnchor.constraint(equalToConstant: constant)
			constraint.isActive = true
			return [ constraint ]
			
		default:
			return []
		}
	}
	
	public func constraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		constraints.first { $0.firstAttribute == attribute }
	}
	
	public func constraints(for attributes: Set<NSLayoutConstraint.Attribute>) -> [NSLayoutConstraint] {
		constraints.filter { attributes.contains($0.firstAttribute) }
	}
	
}

extension NSLayoutConstraint.Attribute {
	
	fileprivate func createConstraint(
		from view: ConstraintView,
		relation: NSLayoutConstraint.Relation,
		to target: ConstraintTarget,
		multiplier: CGFloat = 1.0,
		constant: CGFloat = 0
	) -> NSLayoutConstraint {
		let targetView = target.targetView(for: view)
		let targetAttribute = target.targetAttribute
		return NSLayoutConstraint(
			item: view,
			attribute: self,
			relatedBy: relation,
			toItem: targetView,
			attribute: targetAttribute ?? self,
			multiplier: multiplier,
			constant: constant)
	}
	
}

// MARK: - Modifications

extension NSLayoutConstraint {
	
	public func updatingMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
		let newConstraint = NSLayoutConstraint(
			item: self.firstItem!,
			attribute: self.firstAttribute,
			relatedBy: self.relation,
			toItem: self.secondItem,
			attribute: self.secondAttribute,
			multiplier: multiplier,
			constant: self.constant)
		newConstraint.priority = self.priority
		return newConstraint
	}
	
	fileprivate func modifying(by modifiers: [ConstraintModifier]) -> NSLayoutConstraint {
		var constraint = self
		modifiers.forEach { modifier in
			constraint = modifier.modifiedConstraint(constraint)
		}
		return constraint
	}
	
}

// MARK: - Attributes Sets

extension Set where Element == NSLayoutConstraint.Attribute {
	public static var edges: Set<Element> = [ .leading, .top, .trailing, .bottom ]
	
	public static var topEdges: Set<Element> = [ .leading, .top, .trailing ]
	
	public static var bottomEdges: Set<Element> = [ .leading, .bottom, .trailing ]
	
	public static var horizontalEdges: Set<Element> = [ .leading, .trailing ]
	
	public static var verticalEdges: Set<Element> = [ .top, .bottom ]
	
	public static var centerEdges: Set<Element> = [ .centerX, .centerY, .leading, .trailing ]
	
	public static var center: Set<Element> = [ .centerX, .centerY ]
	
	public static var size: Set<Element> = [ .width, .height ]
	
	public static var height: Set<Element> = [ .height ]
	
	public static var width: Set<Element> = [ .width ]
	
	public static var leading: Set<Element> = [ .leading ]
	
	public static var trailing: Set<Element> = [ .trailing ]
	
	public static var top: Set<Element> = [ .top ]
	
	public static var bottom: Set<Element> = [ .bottom ]
	
	public static var centerX: Set<Element> = [ .centerX ]
	
	public static var centerY: Set<Element> = [ .centerY ]
}

// MARK: - Array / Set for Storing Constraints

extension Array where Element == [NSLayoutConstraint] {
	public func store(in constraints: inout Array<NSLayoutConstraint>) {
		constraints.append(contentsOf: self.flatMap({ $0 }))
	}
	
	public func store(in constraints: inout Set<NSLayoutConstraint>) {
		constraints.formUnion(self.flatMap({ $0 }))
	}
}

extension Array where Element == NSLayoutConstraint {
	public func store(in constraints: inout Array<Element>) {
		constraints.append(contentsOf: self)
	}
	
	public func store(in constraints: inout Set<Element>) {
		constraints.formUnion(self)
	}
	
	mutating public func deactivateAll() {
		self.forEach { $0.isActive = false }
		self.removeAll()
	}
	
	mutating public func deactivateConstraint(for attribute: NSLayoutConstraint.Attribute) {
		self.deactivateConstraints(for: [ attribute ])
	}
	
	mutating public func deactivateConstraints(for attributes: Set<NSLayoutConstraint.Attribute>) {
		let deactivatingConstraints = self.filter { attributes.contains($0.firstAttribute) }
		deactivatingConstraints.forEach { constraint in
			constraint.isActive = false
			self.removeAll(where: { $0 == constraint })
		}
	}
	
	public func constraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		self.constraints(for: [ attribute ]).first
	}
	
	public func constraints(for attributes: Set<NSLayoutConstraint.Attribute>) -> [NSLayoutConstraint] {
		self.filter { attributes.contains($0.firstAttribute) }
	}
	
}

extension Set where Element == NSLayoutConstraint {
	
	mutating public func deactivateAll() {
		self.forEach { $0.isActive = false }
		self.removeAll()
	}
	
	mutating public func deactivateConstraint(for attribute: NSLayoutConstraint.Attribute) {
		self.deactivateConstraints(for: [ attribute ])
	}
	
	mutating public func deactivateConstraints(for attributes: Set<NSLayoutConstraint.Attribute>) {
		let deactivatingConstraints = self.filter { attributes.contains($0.firstAttribute) }
		deactivatingConstraints.forEach { constraint in
			constraint.isActive = false
			self.remove(constraint)
		}
	}
	
	public func constraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		self.constraints(for: [ attribute ]).first
	}
	
	public func constraints(for attributes: Set<NSLayoutConstraint.Attribute>) -> [NSLayoutConstraint] {
		self.filter { attributes.contains($0.firstAttribute) }
	}
	
}
