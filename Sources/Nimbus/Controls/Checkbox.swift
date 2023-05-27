//
// Created by Jacob Caraballo on 2/23/23
//
        

import Foundation
import UIKit

public class Checkbox: UIButton, Control {
	
	internal var stack: CheckboxStack?
	
	public var onAction: OnAction?
	
	public var isOn: Bool {
		get { isSelected }
		set { isSelected = newValue }
	}
	
	// MARK: - Init
	
	init() {
		super.init(frame: CGRect.zero)
		
		imageView?.contentMode = .scaleAspectFit
		
		setImage(imageChecked, for: .selected)
		setImage(imageUnchecked, for: .normal)
		
		addAction(.init(handler: onSelect(_:)), for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Properties
	
	private lazy var config = UIImage.SymbolConfiguration(scale: .large)
	
	private lazy var imageUnchecked = UIImage(systemName: "checkmark.circle", withConfiguration: config)
	
	private lazy var imageChecked = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
	
	private func onSelect(_ action: UIAction) {
		isSelected = !isSelected
		onAction?(isSelected)
		stack?.toggleCheckbox(self)
	}
	
	public func setIsOn(_ isOn: Bool) {
		isSelected = isOn
	}
	
}

// MARK: - Previews

import SwiftUI
import UIKitPreviews
struct Checkbox_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(view)
		view.constrain(.center, to: .superview)
		view.constrain(.size, toConstant: 50)
		return vc
	}()
	
	static var view: UIView = {
		let checkbox = Checkbox()
		checkbox.tintColor = .systemTeal
		return checkbox
	}()
}
