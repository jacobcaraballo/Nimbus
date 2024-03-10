//
// Created by Jacob Caraballo on 2/24/23
//
        

import Foundation
import UIKit
import Combine

public class TabListItem: UIStackView {
	
	public typealias OnAction = () -> Void
	
	public var isActive: Bool = false
	
	public var onAction: OnAction? {
		didSet {
			highlightingButton.isHidden = onAction == nil
		}
	}
	
	private var theme: Theming
	
	public var highlightedBackgroundTheme: Theming = Theme.HighlightedBackground.regular
	
	// MARK: - Init
	
	public init(_ theme: Theming = Theme.ListItem.regular) {
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
	
	private lazy var nestedStackView: NestedStackView = {
		let stackView = NestedStackView(
			[
				NestedStackView.horizontal([
					iconImageView,
					NestedStackView.vertical([
						NestedStackView.horizontal([
							NestedStackView.vertical([
								titleLabel,
								subtitleLabel
							])
						]),
					])
				], options: [
					.alignment(.center),
					.spacing(.small)
				])
			]
		)
		
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		stackView.layoutMargins = .init(all: .large)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		stackView.setCorners(.regular)
		stackView.setShadow()
		
		self.theme.apply(to: stackView)
		
		return stackView
	}()
	
	private lazy var iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.isHidden = true
		imageView.contentMode = .scaleAspectFit
		imageView.constrain(.size, toConstant: 32)
		return imageView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.font = .appFont(.headline)
		label.textColor = Colors.primaryLabel
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.font = .appFont(.subheadline, weight: .light)
		label.textColor = Colors.secondaryLabel
		return label
	}()
	
	public var title: String? {
		get { titleLabel.text }
		set {
			titleLabel.isHidden = newValue == nil
			titleLabel.text = newValue
		}
	}
	
	public var subtitle: String? {
		get { subtitleLabel.text }
		set {
			subtitleLabel.isHidden = newValue == nil
			subtitleLabel.text = newValue
		}
	}
	
	public var icon: UIImage? {
		get { iconImageView.image }
		set {
			iconImageView.isHidden = newValue == nil
			iconImageView.image = newValue
		}
	}
	
	private lazy var highlightingButton: UIButton = {
		let button = UIButton()
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

extension TabListItem {
	
	private func setIsHighlighted(_ isHighlighted: Bool) {
		guard onAction != nil else { return }
		
		let theme: Theming = isHighlighted ? highlightedBackgroundTheme : self.theme
		let scale: CGFloat = isHighlighted ? 0.99 : 1
		
		Animator.animate(duration: 0.15, timing: .curve(.linear)) {
			theme.apply(to: self.nestedStackView)
			self.transform = .init(scaleX: scale, y: scale)
		}
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct TabListItem_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews {
			let vc = UIViewController()
			vc.view.addSubview(listItem)
			vc.view.backgroundColor = .systemGroupedBackground
			listItem.constrain([.leading, .top], to: .superview, modifiers: [ .margins(.init(all: 24)) ])
			return vc
		}
	}
	
	static var listItem: TabListItem = {
		let item = TabListItem()
		item.title = Lorem.word
		item.subtitle = Lorem.word
		//		item.icon = .building
		item.onAction = {
			item.title = Lorem.word
			item.subtitle = Lorem.word
		}
		return item
	}()
}
