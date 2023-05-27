//
// Created by Jacob Caraballo on 2/28/23
//
        

import Foundation
import UIKit

public class Radio: UIButton, Control {
	
	internal var stack: RadioStack?
	
	public var onAction: OnAction?
	
	public var isOn: Bool {
		get { isSelected }
		set { setIsOn(newValue) }
	}
	
	// MARK: - Init
	
	init() {
		super.init(frame: CGRect.zero)
		
		imageView?.contentMode = .scaleAspectFit
		
		self.changesSelectionAsPrimaryAction = true
		
		setImage(imageChecked, for: .selected)
		setImage(imageUnchecked, for: .normal)
		
		addAction(.init(handler: onSelect(_:)), for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Properties
	
	private lazy var defaultConfig = UIImage.SymbolConfiguration(scale: .large)
	
	private lazy var imageUnchecked: UIImage = {
		let config = UIImage.SymbolConfiguration(paletteColors: [.clear, .tintColor])
		
		return .init(systemName: "smallcircle.filled.circle", withConfiguration: defaultConfig)!
			.applyingSymbolConfiguration(config)!
	}()
	
	private lazy var imageChecked: UIImage = {
		return .init(systemName: "smallcircle.filled.circle.fill", withConfiguration: defaultConfig)!
	}()
	
	private func onSelect(_ action: UIAction) {
		setIsOn(true)
		stack?.selectRadio(self)
	}
	
	public func setIsOn(_ isOn: Bool) {
		isSelected = isOn
		onAction?(isOn)
	}
	
}

// MARK: - Previews

import SwiftUI
import UIKitPreviews
struct Radio_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(stackView)
		stackView.constrain(.center, to: .superview)
		return vc
	}()
	
	static var stackView: UIStackView = {
		let radioStack = RadioStack()
		radioStack.addRadios([
			radio,
			radio,
			radio,
			radio
		])
		radioStack.selectRadio(at: 0)
		let stack = UIStackView(arrangedSubviews: radioStack.radios)
		stack.axis = .vertical
		return stack
	}()
	
	static var radio: Radio {
		let radio = Radio()
		radio.tintColor = .systemTeal
		return radio
	}
}
