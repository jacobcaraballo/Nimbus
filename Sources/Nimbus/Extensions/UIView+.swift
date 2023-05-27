//
// Created by Jacob Caraballo on 2/21/23
//
        

import Foundation
import UIKit
import Combine

extension UIView {
	
	public func padded(_ margins: UIEdgeInsets = .init(all: .regular)) -> UIView {
		let view = UIStackView(arrangedSubviews: [ self ])
		view.axis = .vertical
		view.layoutMargins = margins
		view.isLayoutMarginsRelativeArrangement = true
		return view
	}
	
	public func wrapped() -> UIView {
		let view = UIStackView(arrangedSubviews: [ self ])
		view.axis = .vertical
		view.distribution = .fill
		view.alignment = .center
		return view
	}
	
	public func setCorners(_ corners: Corner = .regular, masking masks: CACornerMask = []) {
		self.layer.maskedCorners =  CACornerMask.allCorners.subtracting(masks)
		self.layer.cornerCurve = .continuous
		self.layer.allowsEdgeAntialiasing = true
		corners.apply(to: self)
	}
	
	public func setShadow(_ options: Set<Shadow> = Shadow.default) {
		let options = Shadow.default
			.subtracting(options)
			.union(options)
		options.forEach { $0.apply(to: self) }
	}
	
	public func setBorder(_ border: Border = .thin, color: UIColor = .separator) {
		border.apply(to: self)
		self.layer.borderColor = color.cgColor
	}
	
	public func addController(_ controller: UIViewController, in parent: UIViewController) {
		if let view = self as? UIStackView {
			view.addArrangedSubview(controller.view)
		} else {
			self.addSubview(controller.view)
		}
		
		parent.addChild(controller)
		controller.didMove(toParent: parent)
	}
	
	public func insertController(_ controller: UIViewController, in parent: UIViewController, at index: Int) {
		if let view = self as? UIStackView {
			view.insertArrangedSubview(controller.view, at: index)
		} else {
			self.insertSubview(controller.view, at: index)
		}
		
		parent.addChild(controller)
		controller.didMove(toParent: parent)
	}
	
	public func firstSuperview<T: UIView>(of type: T.Type) -> T? {
		guard let superview = self.superview else { return nil }
		guard let superview = superview as? T else {
			return superview.firstSuperview(of: T.self)
		}
		return superview
	}
	
}

extension CACornerMask {
	public static var allCorners: Self = [topRight, bottomRight, topLeft, bottomLeft]
	
	public static var topRight = layerMaxXMinYCorner
	public static var bottomRight = layerMaxXMaxYCorner
	public static var topLeft = layerMinXMinYCorner
	public static var bottomLeft = layerMinXMaxYCorner
}

extension UIView {
	
	public enum Corner {
		
		/// A radius of 4px.
		case xSmall
		
		/// A radius of 8px.
		case small
		
		/// A radius of 12px.
		case regular
		
		/// A radius of 16px.
		case large
		
		/// A radius of 20px.
		case xLarge
		
		/// A radius of the given size.
		case radius(CGFloat)
		
		/// A radius of the given percentage of the smallest side.
		case percent(CGFloat)
		
		/// A radius of half the size of the smallest side.
		case half
		
		/// A radius of a quarter of the size of the smallest side.
		case quarter
		
		case screen
		
		fileprivate var radius: CGFloat {
			switch self {
			case .xSmall: return 4
			case .small: return 8
			case .regular: return 12
			case .large: return 16
			case .xLarge: return 20
			case .radius(let radius): return radius
			case .percent(let percent): return percent
			case .half: return 0.5
			case .quarter: return 0.25
			case .screen: return UIScreen.cornerRadius
			}
		}
		
		internal func apply(to view: UIView) {
			switch self {
			case .percent,
					.half,
					.quarter:
				apply(percentage: radius, to: view)
				
			default:
				apply(radius: radius, to: view)
			}
		}
		
		private func apply(percentage: CGFloat, to view: UIView) {
			var cancellable: AnyCancellable?
			
			cancellable = view
				.publisher(for: \.bounds)
				.first(where: { $0.size != .zero })
				.map { min($0.width, $0.height) * percentage }
				.sink(receiveCompletion: { _ in
					cancellable?.cancel()
				}, receiveValue: { [weak view] radius in
					guard let view else { return }
					self.apply(radius: radius, to: view)
				})
		}
		
		private func apply(radius: CGFloat, to view: UIView) {
			view.layer.cornerRadius = radius
		}
		
	}
	
	public enum Border: CGFloat {
		case ultrathin = 0.25
		case thin = 0.5
		case regular = 1
		case thick = 2
		case ultrathick = 4
		
		internal func apply(to view: UIView) {
			view.layer.borderWidth = rawValue
		}
	}
	
	public enum Shadow: Hashable {
		public static var `default`: Set<Self> = [
			.color(.init(white: 0.5, alpha: 0.5)),
			.radius(3),
			.offset(.zero),
			.opacity(0.2)
		]
		
		case color(UIColor)
		case radius(CGFloat)
		case offset(CGSize)
		case opacity(Float)
		
		func apply(to view: UIView) {
			switch self {
			case let .color(option):
				view.layer.shadowColor = option.cgColor
				
			case let .radius(option):
				view.layer.shadowRadius = option
				
			case let .offset(option):
				view.layer.shadowOffset = option
				
			case let .opacity(option):
				view.layer.shadowOpacity = option
				
			}
		}
		
		func isSimilar(to other: Shadow) -> Bool {
			switch (self, other) {
			case (.color, .color): return true
			case (.radius, .radius): return true
			case (.offset, .offset): return true
			case (.opacity, .opacity): return true
			default: return false
			}
		}
		
		private var hashId: String {
			switch self {
			case .color: return "color"
			case .radius: return "radius"
			case .offset: return "offset"
			case .opacity: return "opacity"
			}
		}
		
		public func hash(into hasher: inout Hasher) {
			hasher.combine(hashId)
		}
	}
	
}

extension CGSize {
	init(_ value: CGFloat) {
		self.init(width: value, height: value)
	}
}
