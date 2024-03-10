//
// Created by Jacob Caraballo on 2/21/23
//
        

import Foundation
import UIKit

class NestedStackView: UIStackView {
	
	private var options: Set<ItemOption>
	
	init(_ nestedItems: [NestedStackViewItem], options: Set<ItemOption> = ItemOption.default) {
		self.options = ItemOption.default
			.subtracting(options)
			.union(options)
		super.init(frame: .zero)
		
		ItemOption.apply(options, to: self)
		
		let subviews = nestedItems.map { item in
			guard let nestingView = item.nestingView as? NestedStackView else {
				return item.nestingView
			}
			
			return nestingView
		}
		
		self.addArrangedSubviews(subviews)
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public static func horizontal(_ items: [NestedStackViewItem], options: Set<ItemOption> = ItemOption.default) -> NestedStackViewItem {
		Item.horizontal(items, options: options)
	}
	
	public static func vertical(_ items: [NestedStackViewItem], options: Set<ItemOption> = ItemOption.default) -> NestedStackViewItem {
		Item.vertical(items, options: options)
	}
	
	public func insertArrangedSubview(_ view: UIView, before subview: UIView) {
		guard let stackView = subview.firstSuperview(of: NestedStackView.self),
			  let viewIndex = stackView.arrangedSubviews.firstIndex(of: subview),
			  viewIndex.advanced(by: -1) > stackView.arrangedSubviews.startIndex
		else { return }
		
		let insertionIndex = stackView.arrangedSubviews.index(before: viewIndex)
		stackView.insertArrangedSubview(view, at: insertionIndex)
	}
	
	public func insertArrangedSubview(_ view: UIView, after subview: UIView) {
		guard let stackView = subview.firstSuperview(of: NestedStackView.self),
			  let viewIndex = stackView.arrangedSubviews.firstIndex(of: subview),
			  viewIndex.advanced(by: 1) > stackView.arrangedSubviews.startIndex
		else { return }
		
		let insertionIndex = stackView.arrangedSubviews.index(after: viewIndex)
		stackView.insertArrangedSubview(view, at: insertionIndex)
	}
	
}

extension NestedStackView {
	
	enum Item {
		case horizontal(_ items: [NestedStackViewItem], options: Set<ItemOption> = ItemOption.default)
		case vertical(_ items: [NestedStackViewItem], options: Set<ItemOption> = ItemOption.default)
	}
	
	enum ItemOption: Hashable {
		static var `default`: Set<Self> = [
			.spacing(4),
			.distribution(.fill),
			.alignment(.fill)
		]
		
		case spacing(CGFloat)
		case distribution(UIStackView.Distribution)
		case alignment(UIStackView.Alignment)
		
		func apply(to stackView: UIStackView) {
			switch self {
			case let .spacing(option):
				stackView.spacing = option
				
			case let .distribution(option):
				stackView.distribution = option
				
			case let .alignment(option):
				stackView.alignment = option
				
			}
		}
		
		static func apply(_ options: Set<Self>, to stackView: UIStackView) {
			options.forEach { $0.apply(to: stackView) }
		}
	}
	
}

extension NestedStackView.Item: NestedStackViewItem {
	var nestingView: UIView {
		switch self {
		case let .horizontal(items, options):
			let nestingView = NestedStackView(items, options: options)
			nestingView.axis = .horizontal
			nestingView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			return nestingView
			
		case let .vertical(items, options):
			let nestingView = NestedStackView(items, options: options)
			nestingView.axis = .vertical
			nestingView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			return nestingView
			
		}
	}
}

protocol NestedStackViewItem {
	var nestingView: UIView { get }
}

extension UIView: NestedStackViewItem {
	var nestingView: UIView { self }
}

