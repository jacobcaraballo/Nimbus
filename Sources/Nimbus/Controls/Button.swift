//
// Created by Jacob Caraballo on 3/15/23
//
        

import Foundation
import UIKit

public class Button: UIButton {
	
	public init(_ style: Theme.Button = .regular) {
		super.init(frame: .zero)
		style.apply(to: self)
		setup()
		setupConfiguration()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setupConfiguration() {
		self.configuration = .tinted()
		self.configuration?.contentInsets = .init(horizontal: .large, vertical: .regular)
		self.configuration?.imagePadding = .regular
		self.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: .xxLarge)
	}
	
	public func setTextAlignment(_ alignement: UIButton.Configuration.TitleAlignment) {
		self.configuration?.titleAlignment = alignement
	}
	
	public func setSubtitle(_ subtitle: String) {
		self.configuration?.subtitle = subtitle
	}
	
	public func setImage(_ image: UIImage?) {
		self.setImage(image, for: .normal)
	}
	
	private func setup() {
		clipsToBounds = true
		
		titleLabel?.numberOfLines = 0
		subtitleLabel?.numberOfLines = 0
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct Button_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(view)
		view.constrain(.center, to: .superview)
		view.constrain(.width, lessThanOrEqualTo: .superview, modifiers: .margins(.init(horizontal: .xxLarge)))
		return vc
	}()
	
	static var view: UIView = {
		let button = Button()
		button.setTitle(Lorem.title, for: .normal)
		button.setSubtitle(Lorem.sentence)
		button.setImage(.init(systemName: "square.and.pencil.circle.fill"))
		return button
	}()
}
