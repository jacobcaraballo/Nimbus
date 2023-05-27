//
// Created by Jacob Caraballo on 3/16/23
//
        

import Foundation
import UIKit
import Combine

public class PopupController: UIViewController, CustomPresentable {
	var transitionManager: UIViewControllerTransitioningDelegate?
	
	public typealias Placement = ScrollingStackView.Placement
	
	private let placement: Placement
	
	private lazy var grabHandle: UIView = {
		let indicator = Indicator(.horizontal, style: .small, color: .separator)
		indicator.constrain(.width, toConstant: 100)
		
		let wrapped = indicator.wrapped()
		wrapped.isHidden = !showsTopHandle
		return wrapped
	}()
	
	public var showsTopHandle: Bool = false {
		didSet {
			grabHandle.isHidden = !showsTopHandle
		}
	}
	
	private lazy var container: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			grabHandle,
			contentView
		])
		
		stackView.spacing = .xxLarge
		stackView.backgroundColor = .systemBackground
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		
		stackView.layoutMargins = .init(all: .large)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		return stackView
	}()
		
	private lazy var contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = .xxLarge
		return stackView
	}()
	
	internal var contentController: UIViewController? {
		didSet {
			guard let contentController,
				  contentController != oldValue
			else { return }
			
			contentView.addController(contentController, in: self)
		}
	}
	
	private lazy var tapGesture: UITapGestureRecognizer = {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
		return tapGesture
	}()
	
	public var dismissOnTap: Bool = true {
		didSet {
			tapGesture.isEnabled = dismissOnTap
		}
	}
	
	init(placement: Placement = .bottom, theme: Theming) {
		self.placement = placement
		super.init(nibName: nil, bundle: nil)
		
		theme.apply(to: self.container)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.addSubview(container)
		
		switch placement {
		case .top:
			container.constrain(.topEdges, to: .safe(.superview), modifiers: .margins(.init(all: .large)))

		case .center:
			container.constrain(.horizontalEdges, to: .safe(.superview), modifiers: .margins(.init(horizontal: .large)))
			container.constrain(.center, to: .superview)

		case .bottom:
			container.constrain(.bottomEdges, to: .safe(.superview), modifiers: .margins(.init(all: .large)))

		}
		
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc
	private func onTap(_ recognizer: UITapGestureRecognizer) {
		let tapLocation = recognizer.location(in: view)
		guard !container.frame.contains(tapLocation) else { return }
		dismiss(animated: true, completion: nil)
	}
	
	public func addArrangedSubviews(_ subviews: [UIView]) {
		self.contentView.addArrangedSubviews(subviews)
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct PopupController_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			Self.showDrawer()
		}
		return vc
	}()
	
	static var drawer: Drawer = {
		let drawer = Drawer()
		drawer.image = .init(systemName: "rectangle.inset.filled.and.person.filled")
		drawer.title = Lorem.title
		drawer.subtitle = Lorem.title
		drawer.text = Lorem.sentence
		drawer.addAdditionalContent(additionalContent)
		drawer.actions = [
			.init(title: Lorem.title, subtitle: Lorem.title, onAction: {
				
			}),
			.regular(title: Lorem.title, subtitle: Lorem.title, onAction: {
				
			}),
			.destructive(title: "Delete", subtitle: Lorem.title, onAction: {
				
			}),
			.cancel(title: "Cancel", subtitle: Lorem.title, onAction: {
				
			})
		]
		return drawer
	}()
	
	static var additionalContent: UIView = {
		let listItem = ListItem()
		listItem.topLeftText = Lorem.word
		listItem.topRightText = Lorem.word
		return listItem
	}()
	
	private static func showDrawer() {
//		let popupController = PopupController(theme: Theme.Drawer.regular)
//		popupController.showsTopHandle = true
		viewController.present(drawer, animated: true)
	}
}
