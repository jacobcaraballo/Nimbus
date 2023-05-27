//
// Created by Jacob Caraballo on 3/15/23
//
        

import Foundation
import UIKit

public class Drawer: PopupController {
	
	private lazy var headerStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			paddedImageView,
			titleLabel,
			subtitleLabel,
			textLabel
		])
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.setContentCompressionResistancePriority(.required, for: .vertical)
		stackView.spacing = .small
		return stackView
	}()
	
	private lazy var additionalContentContainer: UIStackView = {
		let stackView = UIStackView()
		stackView.isHidden = true
		stackView.spacing = .regular
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		return stackView
	}()
	
	private lazy var actionsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.setContentCompressionResistancePriority(.required, for: .vertical)
		stackView.spacing = .regular
		return stackView
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.layoutMargins = .init(all: .xxxLarge)
		return imageView
	}()
	
	private lazy var paddedImageView: UIView = {
		let paddedView = imageView.padded()
		paddedView.isHidden = true
		return paddedView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.textAlignment = .center
		label.numberOfLines = 0
		Theme.Label.title.apply(to: label)
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.textAlignment = .center
		label.numberOfLines = 0
		Theme.Label.subtitle.apply(to: label)
		return label
	}()
	
	private lazy var textLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.textAlignment = .center
		label.numberOfLines = 0
		Theme.Label.text.apply(to: label)
		return label
	}()
	
	public override var title: String? {
		didSet {
			self.titleLabel.text = title
			self.titleLabel.isHidden = title == nil
		}
	}
	
	public var subtitle: String? {
		didSet {
			self.subtitleLabel.text = subtitle
			self.subtitleLabel.isHidden = subtitle == nil
		}
	}
	
	public var text: String? {
		didSet {
			self.textLabel.text = text
			self.textLabel.isHidden = text == nil
		}
	}
	
	public var image: UIImage? {
		didSet {
			self.imageView.image = image?.applyingSymbolConfiguration(.init(scale: .large))
			self.paddedImageView.isHidden = image == nil
		}
	}
	
	public var actions: [Action] = [] {
		didSet {
			updateActions()
		}
	}
	
	public func addAdditionalContent(_ view: UIView) {
		self.additionalContentContainer.isHidden = false
		self.additionalContentContainer.addArrangedSubview(view)
	}
	
	public func removeFromAdditionalContent(_ view: UIView) {
		view.removeFromSuperview()
		self.additionalContentContainer.isHidden = self.additionalContentContainer.arrangedSubviews.isEmpty
	}
	
	init() {
		super.init(placement: .bottom, theme: Theme.Drawer.regular)
		setup()
	}
	
	private func setup() {
		self.addArrangedSubviews([
			headerStackView,
			additionalContentContainer,
			Divider(.noSpace),
			actionsStackView
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateActions() {
		actionsStackView.removeArrangedSubviews()
		actionsStackView.addArrangedSubviews(actions.map({ action in
			self.createActionButton(for: action)
		}))
	}
	
	private func createActionButton(for action: Action) -> UIButton {
		let button = Button(action.style)
		button.setTitle(action.title, for: .normal)
		button.setSubtitle(action.subtitle)
		button.setContentCompressionResistancePriority(.required, for: .vertical)
		button.setTextAlignment(.center)
		return button
	}
	
	public func setImageScale(_ scale: UIImage.SymbolScale) {
		self.image = image?.applyingSymbolConfiguration(.init(scale: scale))
	}
	
	public func setImageSize(_ size: CGFloat) {
		self.image = image?.applyingSymbolConfiguration(.init(pointSize: size))
	}
	
}

// MARK: - Action

extension Drawer {
	
	public struct Action {
		
		public typealias OnAction = () -> Void
		
		public let style: Theme.Button
		
		public let title: String
		
		public let subtitle: String
		
		public let onAction: OnAction
		
		init(_ style: Theme.Button = .regular, title: String, subtitle: String, onAction: @escaping OnAction) {
			self.style = style
			self.title = title
			self.subtitle = subtitle
			self.onAction = onAction
		}
		
		static func regular(title: String, subtitle: String, onAction: @escaping OnAction) -> Self {
			.init(.regular, title: title, subtitle: subtitle, onAction: onAction)
		}
		
		static func cancel(title: String, subtitle: String, onAction: @escaping OnAction) -> Self {
			.init(.cancel, title: title, subtitle: subtitle, onAction: onAction)
		}
		
		static func destructive(title: String, subtitle: String, onAction: @escaping OnAction) -> Self {
			.init(.destructive, title: title, subtitle: subtitle, onAction: onAction)
		}
		
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct Drawer_Previews: PreviewProvider {
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
		drawer.showsTopHandle = true
		drawer.dismissOnTap = true
		drawer.image = .init(systemName: "rectangle.inset.filled.and.person.filled")
		drawer.title = Lorem.title
		drawer.subtitle = Lorem.title
		drawer.text = Lorem.sentence
		drawer.addAdditionalContent(additionalContent)
		drawer.addAdditionalContent(textField)
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
	
	static var textField: UITextField = {
		let textField = UITextField()
		return textField
	}()
	
	private static func showDrawer() {
		viewController.present(drawer, animated: true)
	}
}
