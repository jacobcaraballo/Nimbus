//
// Created by Jacob Caraballo on 3/13/23
//


import Foundation
import UIKit

class Banner: UIView, Identifiable {
	
	// MARK: - Init
	
	init(_ theme: Theme.Banner = .regular, title: String? = nil, text: String) {
		self.theme = theme
		self.title = title
		self.text = text
		
		super.init(frame: .zero)
		
		setup()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	private var theme: Theme.Banner
	
	public var showsCloseButton: Bool = false {
		didSet {
			closeButton.isHidden = !showsCloseButton
		}
	}
	
	private lazy var container: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			imageView,
			stackView
		])
		stackView.spacing = .regular
		stackView.axis = .horizontal
		stackView.distribution = .fillProportionally
		stackView.alignment = .center
		stackView.layoutMargins = .init(all: .large)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.setContentHuggingPriority(.required, for: .horizontal)
		return stackView
	}()
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			titleStackView,
			textLabel
		])
		stackView.spacing = .xSmall
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.setContentHuggingPriority(.required, for: .horizontal)
		return stackView
	}()
	
	private lazy var titleStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			titleLabel,
			closeButton
		])
		stackView.spacing = .xSmall
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		stackView.alignment = .top
		stackView.setContentHuggingPriority(.required, for: .horizontal)
		return stackView
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.isHidden = true
		imageView.contentMode = .scaleAspectFit
		imageView.constrain(.size, toConstant: 40)
		return imageView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		Theme.Label.title.apply(to: label)
		label.numberOfLines = 0
		label.text = title
		label.isHidden = title == nil
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	private lazy var textLabel: UILabel = {
		let label = UILabel()
		Theme.Label.text.apply(to: label)
		label.numberOfLines = 0
		label.text = text
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		let config = UIImage.SymbolConfiguration(scale: .large)
		button.tintColor = .opaqueSeparator
		button.isHidden = !showsCloseButton
		button.setImage(.init(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
		button.setContentCompressionResistancePriority(.required, for: .horizontal)
		button.setContentHuggingPriority(.required, for: .horizontal)
		button.addAction(.init(handler: { [unowned self] _ in
			self.dismiss()
		}), for: .touchUpInside)
		return button
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
	
	@discardableResult
	static func present(_ theme: Theme.Toast = .regular, title: String? = nil, text: String, duration: TimeInterval, in viewController: UIViewController? = nil) -> Toast {
		let view = viewController?.view ?? UIApplication.keyWindow
		let toast = Toast(theme, title: title, text: text)
		toast.present(in: view, duration: duration)
		return toast
	}
	
}

// MARK: - Setup

extension Banner {
	
	func setup() {
		theme.apply(to: self)
		
		self.addSubview(container)
		container.constrain(.edges, to: .superview)
	}
	
}

// MARK: - Presentation

extension Banner {
	
	private func dismiss() {
		Animator.animate(duration: 0.3, timing: .curve(.easeIn), animations: {
			self.alpha = 0
			self.isHidden = true
		}) { [weak self] in
			guard let self else { return }
			self.removeFromSuperview()
		}
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct Banner_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(stackView)
		stackView.constrain(.topEdges, to: .superview, modifiers: .margins(.init(all: .xxLarge)))
		return vc
	}()
	
	static var banner: Banner = {
		let banner: Banner = .init(.failure, title: Lorem.title, text: Lorem.sentence)
		banner.showsCloseButton = true
		banner.image = .init(systemName: "exclamationmark.triangle.fill")
		return banner
	}()
	
	static var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			banner
		])
		stackView.spacing = .xSmall
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.layoutMargins = .init(all: .large)
		stackView.isLayoutMarginsRelativeArrangement = true
		return stackView
	}()
	
}
