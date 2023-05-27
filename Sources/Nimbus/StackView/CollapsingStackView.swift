//
// Created by Jacob Caraballo on 2/21/23
//
        

import Foundation
import UIKit

class CollapsingStackView: UIView {
	
	init(title: String, subtitle: String, items: [ListItem]) {
		super.init(frame: .zero)
		
		self.titleLabel.text = title
		self.subtitleLabel.text = subtitle
		
		setup()
		
		setItems(items)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			headerStackView,
			divider,
			contentStackView,
			summaryStackView
		])
		stackView.backgroundColor = Colors.secondaryBackground
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		stackView.layoutMargins = .init(all: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.setCorners()
		stackView.setShadow([
			.opacity(0.5),
			.radius(2)
		])
		return stackView
	}()
	
	private lazy var headerStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			titleLabel,
			subtitleLabel,
			dropdownImageView
		])
		stackView.spacing = .regular
		stackView.axis = .horizontal
		stackView.distribution = .fill
		stackView.alignment = .bottom
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
		stackView.addGestureRecognizer(gesture)
		
		return stackView
	}()
	
	private lazy var divider: Divider = .init()
	
	private lazy var contentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		
		stackView.spacing = .small
		stackView.setCustomSpacing(0, after: divider)
		
		return stackView
	}()
	
	private lazy var summaryStackView: UIStackView = {
		let stackView = UIStackView()
		
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		
		stackView.spacing = .small
		stackView.setCustomSpacing(0, after: divider)
		
		stackView.isHidden = true
		
		return stackView
	}()
	
	public lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .appFont(.headline)
		label.textColor = Colors.primaryLabel
		return label
	}()
	
	public lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .appFont(.subheadline)
		label.textColor = Colors.secondaryLabel
		return label
	}()
	
	private lazy var dropdownImageView: UIImageView = {
		let imageView = UIImageView(image: .chevronRight)
		imageView.transform = .init(rotationAngle: rotationAngleForCurrentState)
		imageView.tintColor = .separator
		return imageView
	}()
	
	private func updateDropdownImage() {
		Animator.animate(duration: 0.4, timing: .spring(0.8)) {
			self.dropdownImageView.transform = .init(rotationAngle: self.rotationAngleForCurrentState)
		}
	}
	
	private var rotationAngleForCurrentState: CGFloat {
		if isCollapsed {
			return 0
		} else {
			return .pi / 2
		}
	}
	
	public func setSummaryView(_ view: UIView) {
		shouldDisplaySummary = true
		summaryStackView.addArrangedSubview(view)
	}
	
	private var shouldDisplaySummary: Bool = false
	
}

extension CollapsingStackView {
	
	@objc func didTap() {
		toggle()
	}
	
	private func setup() {
		stackView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(stackView)
		stackView.constrain(.edges, to: .superview)
	}
	
	public func setItems(_ listItems: [ListItem]) {
		contentStackView.removeArrangedSubviews(ofType: ListItem.self)
		contentStackView.addArrangedSubviews(listItems)
	}
	
	public var items: [ListItem] {
		contentStackView
			.arrangedSubviews
			.compactMap { $0 as? ListItem }
	}
	
}

extension CollapsingStackView {
	
	public var isCollapsed: Bool {
		return contentStackView.isHidden || contentStackView.alpha != 1
	}
	
	public func toggle() {
		setIsHidden(!isCollapsed)
	}
	
	public func setIsHidden(_ isHidden: Bool, animated: Bool = true) {
		guard animated else {
			self.contentStackView.alpha = isHidden ? 0 : 1
			self.contentStackView.isHidden = isHidden
			
			if shouldDisplaySummary {
				self.summaryStackView.alpha = isHidden ? 1 : 0
				self.summaryStackView.isHidden = !isHidden
			} else {
				self.divider.alpha = isHidden ? 0 : 1
				self.divider.isHidden = isHidden
			}
			
			return
		}
		
		let duration: TimeInterval = 0.3
		
		Animator.animate(duration: duration / 2, timing: .curve(.linear)) {
			self.contentStackView.alpha = isHidden ? 0 : 1
			
			if self.shouldDisplaySummary {
				self.summaryStackView.alpha = isHidden ? 1 : 0
			} else {
				self.divider.alpha = isHidden ? 0 : 1
			}
		}
		
		Animator.animate(duration: duration, timing: .spring(0.9)) {
			self.contentStackView.isHidden = isHidden
			
			if self.shouldDisplaySummary {
				self.summaryStackView.isHidden = !isHidden
			} else {
				self.divider.isHidden = isHidden
			}
		}
		
		self.updateDropdownImage()
	}
	
	
	
	private func collapse() {
		setIsHidden(true)
	}
	
	private func expand() {
		setIsHidden(false)
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct CollapsingStackView_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(scrollingStackView)
		scrollingStackView.constrain(.edges, to: .superview)
		return vc
	}()
	
	static var scrollingStackView: ScrollingStackView = {
		let stackView = ScrollingStackView(axis: .vertical, arrangedSubviews: [
			view
		])
		stackView.layoutMargins = .init(all: .xxLarge)
		return stackView
	}()
	
	static var view: CollapsingStackView = {
		let view = CollapsingStackView(title: "Hello", subtitle: "World", items: [
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
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			view.setSummaryView(summaryView)
//			view.setIsHidden(true, animated: false)
		}
		return view
	}()
	
	static var summaryView: ScrollingStackView = {
		let stackView = ScrollingStackView(axis: .horizontal)
		let items = view.items.map { TinyListItem(from: $0) }
		stackView.addArrangedSubviews(items)
		stackView.layoutMargins = .init(horizontal: .xSmall, vertical: .xSmall)
		stackView.spacing = .small
		return stackView
	}()
	
	static var listItem: ListItem {
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
