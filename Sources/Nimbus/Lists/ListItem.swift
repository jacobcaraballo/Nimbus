//
// Created by Jacob Caraballo on 2/21/23
//
        

import Foundation
import UIKit
import UIKitPreviews
import LoremSwiftum
import Combine

public class ListItem: UIStackView {
	
	public typealias OnAction = () -> Void
	
	public typealias OnCheck = (_ isOn: Bool) -> Void
	
	private var theme: Theming
	
	public var highlightedBackgroundTheme: Theming = Theme.HighlightedBackground.regular
	
	public var onAction: OnAction? {
		didSet {
			highlightingButton.isHidden = onAction == nil
		}
	}
	
	// MARK: - Init
	
	init(_ theme: Theming = Theme.ListItem.regular) {
		self.theme = theme
		
		super.init(frame: .zero)
		
		self.layoutMargins = .init(all: .large)
		self.isLayoutMarginsRelativeArrangement = true
		
		setup()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Properties
	
	private lazy var mainStackView: UIStackView = {
		let stackView = UIStackView()
		return stackView
	}()
	
	private lazy var nestedStackView: NestedStackView = {
		let stackView = NestedStackView(
			[
				NestedStackView.horizontal([
					colorView,
					leftIconImageView,
					NestedStackView.vertical([
						topLeftLabel,
						bottomLeftLabel
					]),
					NestedStackView.vertical([
						topRightLabel,
						bottomRightLabel
					]),
					controlContainer,
					rightIconImageView
				], options: [
					.alignment(.center),
					.spacing(.small)
				]),
				divider,
				bottomTextLabel
			]
		)
		
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.layoutMargins = .init(all: .large)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		theme.apply(to: stackView)
		
		return stackView
	}()
	
	private lazy var divider = {
		let divider = Divider()
		divider.isHidden = true
		return divider
	}()
	
	private lazy var colorView: UIView = {
		let view = UIView()
		view.isHidden = true
		view.constrain([ .width ], toConstant: 4)
		view.constrain([ .height ], greaterThanOrEqualToConstant: 32)
		view.setCorners(.radius(2))
		return view
	}()
	
	private lazy var controlContainer: UIStackView = {
		let container = UIStackView()
		container.axis = .horizontal
		return container
	}()
	
	private var controlView: Control? {
		didSet {
			guard let controlView else { return }
			controlContainer.addArrangedSubview(controlView)
		}
	}
	
	private lazy var leftIconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.isHidden = true
		imageView.contentMode = .scaleAspectFit
		imageView.constrain(.size, toConstant: 32)
		return imageView
	}()
	
	private lazy var topLeftLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.font = .appFont(.headline)
		label.textColor = .darkGray
		
		label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return label
	}()
	
	private lazy var topRightLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.font = .appFont(.headline)
		label.textColor = .darkGray
		label.textAlignment = .right
		
		label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return label
	}()
	
	private lazy var bottomLeftLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.font = .appFont(.subheadline, weight: .light)
		label.textColor = .secondaryLabel
		
		label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		
		return label
	}()
	
	private lazy var bottomRightLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.font = .appFont(.subheadline, weight: .light)
		label.textColor = .secondaryLabel
		label.textAlignment = .right
		
		label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return label
	}()
	
	private lazy var bottomTextLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.numberOfLines = 0
		label.font = .appFont(.subheadline, weight: .light)
		label.textColor = .secondaryLabel
		return label
	}()
	
	private lazy var rightIconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.isHidden = true
		imageView.contentMode = .scaleAspectFit
		imageView.constrain(.size, toConstant: 22)
		return imageView
	}()
	
	public var topLeftText: String? {
		get { topLeftLabel.text }
		set {
			topLeftLabel.isHidden = newValue == nil
			topLeftLabel.text = newValue
		}
	}
	
	public var topRightText: String? {
		get { topRightLabel.text }
		set {
			topRightLabel.isHidden = newValue == nil
			topRightLabel.text = newValue
		}
	}
	
	public var bottomLeftText: String? {
		get { bottomLeftLabel.text }
		set {
			bottomLeftLabel.isHidden = newValue == nil
			bottomLeftLabel.text = newValue
		}
	}
	
	public var bottomRightText: String? {
		get { bottomRightLabel.text }
		set {
			bottomRightLabel.isHidden = newValue == nil
			bottomRightLabel.text = newValue
		}
	}
	
	public var bottomText: String? {
		get { bottomTextLabel.text }
		set {
			bottomTextLabel.isHidden = newValue == nil
			divider.isHidden = newValue == nil
			bottomTextLabel.text = newValue
		}
	}
	public var leftIcon: UIImage? {
		get { leftIconImageView.image }
		set {
			leftIconImageView.isHidden = newValue == nil
			leftIconImageView.image = newValue
		}
	}
	public var rightIcon: UIImage? {
		get { rightIconImageView.image }
		set {
			rightIconImageView.isHidden = newValue == nil
			rightIconImageView.image = newValue
			rightIconImageView.tintColor = .separator
		}
	}
	public var leftSideColor: UIColor? {
		get { colorView.backgroundColor }
		set {
			colorView.isHidden = newValue == nil
			colorView.backgroundColor = newValue
		}
	}
	
	private lazy var highlightingButton: OverlayButton = {
		let button = OverlayButton(passthroughTouchesTo: controlContainer)
		button.isHidden = true
		button.backgroundColor = .clear
		button.setCorners(.regular)
		button.addAction(.init(handler: { _ in
			self.onAction?()
		}), for: .touchUpInside)
		return button
	}()
	
	private var cancellables = Set<AnyCancellable>()
	
	private func setup() {
		self.addSubview(nestedStackView)
		nestedStackView.constrain(.edges, to: .superview)
		
		self.addSubview(highlightingButton)
		highlightingButton.constrain(.edges)
		
		highlightingButton.publisher(for: \.isHighlighted)
			.sink { isHighlighted in
				self.setIsHighlighted(isHighlighted)
			}
			.store(in: &cancellables)
	}
	
}

extension ListItem {
	
	private func setIsHighlighted(_ isHighlighted: Bool) {
		guard onAction != nil else { return }
		
		let scale: CGFloat = isHighlighted ? 0.99 : 1
		let theme: Theming = isHighlighted ? highlightedBackgroundTheme : self.theme
				
		Animator.animate(duration: 0.15, timing: .curve(.linear)) {
			theme.apply(to: self.nestedStackView)
			self.transform = .init(scaleX: scale, y: scale)
		}
	}
	
}

extension ListItem {
	
	public enum ControlStyle {
		
		case checkbox
		
		case radio
		
		case toggle
		
	}
	
	public func setControl(_ control: ControlStyle, onAction: @escaping Control.OnAction) {
		
		switch control {
		case .checkbox:
			let checkbox = Checkbox()
			checkbox.constrain(.size, toConstant: 32)
			checkbox.onAction = onAction
			self.controlView = checkbox
			
		case .radio:
			let radio = Radio()
			radio.constrain(.size, toConstant: 32)
			radio.onAction = onAction
			self.controlView = radio
			
		case .toggle:
			let toggle = Toggle()
			toggle.constrain(.width, toConstant: toggle.frame.width)
			toggle.onAction = onAction
			self.controlView = toggle
			
		}
		
	}
	
}

extension ListItem {
	
	class TableViewCell: UITableViewCell {
		public let listItem: ListItem
		
		init(listItem: ListItem) {
			self.listItem = listItem
			super.init(frame: .zero)
			setup()
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func setup() {
			self.contentView.addSubview(listItem)
			listItem.constrain(.edges, to: .superview)
		}
	}
	
	class CollectionViewCell: UICollectionViewCell {
		
		public var listItem: ListItem = .init() {
			didSet { setup() }
		}
		
		override init(frame: CGRect) {
			super.init(frame: frame)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func prepareForReuse() {
			super.prepareForReuse()
		}
		
		private func setup() {
			self.contentView.addSubview(listItem)
			listItem.constrain(.edges, to: .superview)
		}
		
	}
	
}

class OverlayButton: UIButton {
	
	public var passthroughView: UIView?
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		guard let passthroughView else { return false }
		let point = convert(point, to: passthroughView)
		return passthroughView.hitTest(point, with: event) == nil
	}
	
	init(passthroughTouchesTo view: UIView? = nil) {
		self.passthroughView = view
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

import SwiftUI
struct ListItem_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews {
			let vc = UIViewController()
			vc.view.addSubview(listItem)
			vc.view.backgroundColor = .systemGroupedBackground
			listItem.constrain(.topEdges, to: .superview, modifiers: [ .margins(.init(all: 24)) ])
			return vc
		}
	}
	
	static var listItem_Bug: UIView = {
		let listItem = ListItem()
		listItem.topLeftText = Lorem.word
		listItem.topRightText = Lorem.word
		return listItem
	}()
	
	static var listItem: ListItem = {
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
	}()
	
}
