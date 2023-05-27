//
// Created by Jacob Caraballo on 2/24/23
//
        

import Foundation
import UIKit
import Combine

public class ScrollingStackView: UIScrollView {
	
	public enum Placement {
		public static var `default`: Self = .top
		
		case top
		case center
		case bottom
	}
	
	private let placement: Placement
	
	// MARK: - Init
	
	public init(axis: NSLayoutConstraint.Axis, placement: Placement = .top, arrangedSubviews: [UIView] = []) {
		self.placement = placement
		
		super.init(frame: .zero)
		
		self.showsHorizontalScrollIndicator = false
		self.showsVerticalScrollIndicator = false
		self.stackView.axis = axis
		self.stackView.addArrangedSubviews(arrangedSubviews)
		self.setContentCompressionResistancePriority(.required, for: .vertical)
		self.setContentCompressionResistancePriority(.required, for: .horizontal)
		
		setupKeyboardConfiguration()
		setupContent()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	public var axis: NSLayoutConstraint.Axis {
		stackView.axis
	}
	
	public var spacing: CGFloat = 0 {
		didSet {
			stackView.spacing = spacing
		}
	}
	
	public override var layoutMargins: UIEdgeInsets {
		didSet {
			stackView.layoutMargins = layoutMargins
			isLayoutMarginsRelativeArrangement = true
		}
	}
	
	public var isLayoutMarginsRelativeArrangement: Bool {
		get {
			stackView.isLayoutMarginsRelativeArrangement
		}
		set {
			stackView.isLayoutMarginsRelativeArrangement = newValue
		}
	}
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		stackView.spacing = spacing
		stackView.setContentCompressionResistancePriority(.required, for: .vertical)
		stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
		return stackView
	}()
	
}

// MARK: - Setup

extension ScrollingStackView {
	
	private func setupContent() {
		addSubview(stackView)
		
		stackView.constrain(.edges, to: .superview)
		
		switch axis {
		case .vertical:
			self.alwaysBounceHorizontal = false
			self.alwaysBounceVertical = true
			stackView.constrain(.width, to: .superview)
			
		case .horizontal:
			self.alwaysBounceHorizontal = true
			self.alwaysBounceVertical = false
			stackView.constrain(.height, to: .superview)
			
		@unknown default:
			break
			
		}
	}
	
	private func setupKeyboardConfiguration() {
		var cancellable: AnyCancellable?
		cancellable = KeyboardInteraction.observeKeyboardState()
			.sink { [weak self] state in
				cancellable?.cancel()
				cancellable = nil
				
				self?.updateForKeyboardStateChanged(state)
			}
	}
	
	private func updateForKeyboardStateChanged(_ state: KeyboardInteraction.State) {
		switch state {
		case .willShow(let configuration):
			self.contentInset.bottom = configuration.frame.height
			self.stackView.constraint(for: .bottom)?
				.constant = configuration.frame.height
			Animator.animate(duration: configuration.animationDuration, timing: .curve(configuration.animationCurve)) {
				self.stackView.superview?.layoutIfNeeded()
			}
			
		case .willDismiss(let configuration):
			self.contentInset.bottom = 0
			self.stackView.constraint(for: .bottom)?
				.constant = 0
			Animator.animate(duration: configuration.animationDuration, timing: .curve(configuration.animationCurve)) {
				self.stackView.superview?.layoutIfNeeded()
			}
		}
		
	}
	
	public func insertArrangedSubview(_ view: UIView, at index: Int) {
		stackView.insertArrangedSubview(view, at: index)
	}
	
	public func addArrangedSubview(_ view: UIView) {
		stackView.addArrangedSubview(view)
	}
	
	public func addArrangedSubviews(_ views: [UIView]) {
		stackView.addArrangedSubviews(views)
	}
	
	public func addArrangedController(_ controller: UIViewController, in parent: UIViewController) {
		stackView.addController(controller, in: parent)
	}
	
	public var arrangedSubviews: [UIView] {
		stackView.arrangedSubviews
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct ScrollingStackView_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.backgroundColor = .systemGroupedBackground
		vc.view.addSubview(horizontalScrollingStack)
		horizontalScrollingStack.constrain(.edges, to: .superview)
		return vc
	}()
	
	static var verticalScrollingStack: ScrollingStackView = {
		let view = ScrollingStackView(axis: .vertical)
		let listItems: [ListItem] = (1...10).map { _ in
			listItem2
		}
		view.addArrangedSubviews(listItems)
		return view
	}()
	
	static var horizontalScrollingStack: UIView = {
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
		
		return view
	}()
	
	static var listItem: TabListItem {
		let item = TabListItem()
		item.title = Lorem.word
		item.subtitle = Lorem.word
		item.onAction = {
			item.title = Lorem.word
			item.subtitle = Lorem.word
		}
		return item
	}
	
	static var listItem2: ListItem {
		let item = ListItem()
		item.topRightText = Lorem.word
		item.topLeftText = Lorem.word
		item.bottomRightText = Lorem.word
		item.bottomLeftText = Lorem.word
		item.leftIcon = .building
		item.leftSideColor = .systemRed
		item.bottomText = Lorem.sentences(3)
		item.rightIcon = .chevronRight
		item.onAction = {
			item.bottomText = Lorem.sentences(3)
		}
		item.setControl(.checkbox) { isOn in
			item.bottomRightText = isOn ? "Is Checked" : "Is Unchecked"
			item.bottomText = Lorem.sentences(3)
		}
		return item
	}
	
}
