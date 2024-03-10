//
// Created by Jacob Caraballo on 2/24/23
//
        

import Foundation
import UIKit
import Combine

public class TabList: UIView {
	
	public typealias OnAction = (_ tab: Button) -> Void
	
	public var onAction: OnAction?
	
	// MARK: - Init
	
	public init(items: [Button] = []) {
		self.items = items
		super.init(frame: .zero)
		
		listenForBounds()
		
		setup()
		updateItemsForSelection()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	public override var layoutMargins: UIEdgeInsets {
		didSet {
			stackView.layoutMargins = layoutMargins
		}
	}
	
	private lazy var stackView: ScrollingStackView = {
		let stackView = ScrollingStackView(axis: .horizontal)
		stackView.layoutMargins = .init(horizontal: .xxLarge, vertical: .large)
		stackView.spacing = .regular
		return stackView
	}()
	
	public var activeTab: Button {
		guard let activeItem = items.first(where: \.isSelected) else {
			let firstItem = items.first!
			firstItem.isSelected = true
			return firstItem
		}
		
		return activeItem
	}
	
	private lazy var indicator: Indicator = {
		let indicator = Indicator(.horizontal, style: .regular, color: .systemMint)
		indicator.isHidden = true
		return indicator
	}()
	
	private var items: [Button]
	
	private var indicatorConstraints = Set<NSLayoutConstraint>()
	
	private var isReadyForScrolling = false {
		didSet {
			guard isReadyForScrolling,
				  let queuedActiveItem
			else { return }
			
			setActiveItem(queuedActiveItem, animated: false)
			self.queuedActiveItem = nil
		}
	}
	
	private var queuedActiveItem: Button?
	
	public var showsSelectionIndicator: Bool {
		set { indicator.isHidden = !newValue }
		get { !indicator.isHidden }
	}
	
}

// MARK: - Setup

extension TabList {
	
	private func setup() {
		self.addSubview(stackView)
		stackView.addArrangedSubviews(items)
		stackView.constrain(.edges, to: .superview)
		
		self.addSubview(indicator)
		updateIndicatorConstraints()
	}
	
	private func listenForBounds() {
		var cancellable: AnyCancellable?
		cancellable = stackView
			.publisher(for: \.bounds)
			.first(where: { $0.size != .zero })
			.sink(receiveCompletion: { _ in
				cancellable?.cancel()
			}, receiveValue: { [weak self] _ in
				self?.isReadyForScrolling = true
			})
	}
	
}

// MARK: - Item Actions

extension TabList {
	
	private func updateItemsForSelection() {
		items.forEach { item in
			let itemAction = item.onAction
			item.onAction = { [weak self, unowned item] in
				itemAction?()
				self?.didSelectItem(item)
			}
		}
	}
	
	private func didSelectItem(_ item: Button) {
		onAction?(item)
		setActiveItem(item, animated: true)
	}
	
	public func setActiveItem(at index: Int, animated: Bool) {
		setActiveItem(items[index], animated: animated)
	}
	
	public func setActiveItem(_ item: Button, animated: Bool) {
		guard isReadyForScrolling else {
			queuedActiveItem = item
			return
		}
		
		items.filter(\.isSelected).forEach { $0.isSelected = false }
		item.isSelected = true
		moveIndicatorToActiveItem(animated: animated)
		stackView.scrollTo(item, position: .offset(.left, .xxLarge), animated: animated)
	}
	
}

// MARK: - Indicator

extension TabList {
	
	private func updateIndicatorConstraints() {
		indicatorConstraints.deactivateAll()
		
		[
			indicator.constrain([ .centerX ], to: .target(activeTab)),
			indicator.constrain([ .bottom ], to: .superview),
			indicator.constrain(
				[ .width ],
				to: .target(activeTab, .width),
				modifiers: [ .margins(.init(horizontal: .regular)) ])
		].store(in: &indicatorConstraints)
	}
	
	private func moveIndicatorToActiveItem(animated: Bool) {
		self.updateIndicatorConstraints()
		guard animated else {
			self.indicator.superview?.layoutIfNeeded()
			return
		}
		
		Animator.animate(duration: 0.4, timing: .spring(0.8)) {
			self.indicator.superview?.layoutIfNeeded()
		}
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct TabList_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.backgroundColor = .systemGroupedBackground
		vc.view.addSubview(view)
		view.constrain(.topEdges, to: .superview)
		return vc
	}()
	
	static var view: UIView = {
		let view = TabList(items: [
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem
		])
		
		view.setActiveItem(at: 9, animated: false)
		
//		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//			view.setActiveItem(at: 9, animated: true)
//		}
		
		return view
	}()
	
	static var listItem: Button {
		let item = Button()
		item.setTitle(Lorem.word, for: .normal)
//		item.subtitle = Lorem.word
		//		item.icon = .building
//		item.onAction = {
//			item.title = Lorem.word
//			item.subtitle = Lorem.word
//		}
		return item
	}
	
}
