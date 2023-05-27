//
// Created by Jacob Caraballo on 2/27/23
//
        

import Foundation
import UIKit

public class Toggle: UISwitch, Control {
	
	public var onAction: OnAction?
	
	public override var tintColor: UIColor! {
		didSet {
			self.onTintColor = tintColor
		}
	}
	
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		
		addAction(.init(handler: { [unowned self] _ in
			self.onAction?(self.isOn)
		}), for: .valueChanged)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Previews

import SwiftUI
import UIKitPreviews
struct Toggle_Previews: PreviewProvider {
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
		let toggle = Toggle()
		toggle.tintColor = .systemTeal
		toggle.isOn = true
		return toggle
	}()
}
