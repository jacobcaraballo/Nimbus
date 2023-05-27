//
// Created by Jacob Caraballo on 2/26/23
//
        

import Foundation
import UIKit

class Toast: UIView, Identifiable {
	
	// MARK: - Init
	
	init(_ theme: Theme.Toast = .regular, title: String? = nil, text: String) {
		self.theme = theme
		self.title = title
		self.text = text
		
		super.init(frame: .zero)
		
		setup()
		setupSwipeGesture()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	private var theme: Theme.Toast
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			titleLabel,
			textLabel
		])
		stackView.spacing = .xSmall
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.layoutMargins = .init(all: .large)
		stackView.isLayoutMarginsRelativeArrangement = true
		return stackView
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.isHidden = true
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		Theme.Label.title.apply(to: label)
		label.numberOfLines = 0
		label.text = title
		label.isHidden = title == nil
		return label
	}()
	
	private lazy var textLabel: UILabel = {
		let label = UILabel()
		Theme.Label.text.apply(to: label)
		label.numberOfLines = 0
		label.text = text
		return label
	}()
	
	public var image: UIImage? {
		didSet {
			imageView.image = image
			imageView.isHidden = image == nil
		}
	}
	
	public var title: String? {
		didSet {
			titleLabel.text = title
			titleLabel.isHidden = title == nil
		}
	}
	
	public var text: String {
		didSet { textLabel.text = text }
	}
	
	internal var id: UUID = UUID()
	
	static var activeToasts = Set<Toast>()
	
	private var presentedConstraint: NSLayoutConstraint!
	private var dismissedConstraint: NSLayoutConstraint!
	
	private var dismissTask: DispatchWorkItem?
	
	@discardableResult
	static func present(_ theme: Theme.Toast = .regular, title: String? = nil, text: String, duration: TimeInterval, in viewController: UIViewController? = nil) -> Toast {
		let view = viewController?.view ?? UIApplication.keyWindow
		let toast = Toast(theme, title: title, text: text)
		toast.present(in: view, duration: duration)
		return toast
	}
	
}

// MARK: - Setup

extension Toast {
	
	func setup() {
		theme.apply(to: self)
		
		self.addSubview(imageView)
		imageView.constrain(.size, toConstant: 40)
		imageView.constrain(.leading, to: .superview, modifiers: .constant(.large))
		imageView.constrain(.centerY, to: .superview)
		
		self.addSubview(stackView)
		stackView.constrain([ .top, .trailing, .bottom ], to: .superview)
		stackView.constrain(.leading, to: .target(imageView, .trailing))
	}
	
	func prepareConstraints(for view: UIView) {
		view.addSubview(self)
		
		presentedConstraint = constrain(
			.bottom,
			to: .safe(.superview),
			modifiers: [
				.constant(-.xxLarge),
				.priority(.defaultHigh)
			]).first
		presentedConstraint.isActive = false

		dismissedConstraint = constrain(.top, to: .target(view, .bottom), modifiers: .priority(.defaultLow)).first
		
		constrain(.horizontalEdges,
				  to: .superview,
				  modifiers: .margins(.init(horizontal: .xxLarge)))
		
		
		superview?.layoutIfNeeded()
	}
	
	private func setupSwipeGesture() {
		let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
		swipe.direction = .down
		addGestureRecognizer(swipe)
	}
	
	@objc private func onSwipe() {
		dismiss()
	}
	
}

// MARK: - Presentation
extension Toast {
	
	func present(duration: TimeInterval) {
		self.present(in: UIApplication.keyWindow, duration: duration)
	}
	
	func present(in view: UIView, duration: TimeInterval) {
		Self.activeToasts.insert(self)
		
		prepareConstraints(for: view)
		self.setDismissedStyle()
		
		self.presentedConstraint.isActive = true
		
		UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7) {
			self.superview?.layoutIfNeeded()
			self.setPresentedStyle()
		}.startAnimation()
		
		dismissTask = .init { [weak self] in
			self?.dismiss()
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: dismissTask!)
	}
	
	func dismiss() {
		self.dismissTask?.cancel()
		self.dismissTask = nil
		
		self.presentedConstraint.isActive = false
		
		let anim = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7) {
			self.superview?.layoutIfNeeded()
			self.setDismissedStyle()
		}
		anim.addCompletion { [weak self] _ in
			guard let self else { return }
			Self.activeToasts.remove(self)
			self.removeFromSuperview()
		}
		anim.startAnimation()
	}
	
}

// MARK: - Presentation Style
extension Toast {
	
	func setDismissedStyle() {
		transform = .init(scaleX: 0.95, y: 0.95)
	}
	
	func setPresentedStyle() {
		transform = .identity
	}
	
	func updatePositionInToastStack() {
		
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct Toast_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		showToasts(5)
		return vc
	}()
	
	static var toast: Toast {
		.init(.failure, title: Lorem.title, text: Lorem.sentence)
	}
	
	static func showNewToast() {
		toast.present(duration: 5)
	}
	
	static func showToasts(_ n: Int) {
		guard n > 0 else { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.showNewToast()
			self.showToasts(n - 1)
		}
	}
	
}
