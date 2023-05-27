//
// Created by Jacob Caraballo on 2/22/23
//
        

import Foundation
import UIKit
import UIKitPreviews

extension UIFont {
	
	func rounded(_ weight: Weight = .regular) -> UIFont {
		.rounded(ofSize: pointSize, weight: weight)
	}
	
	static func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
		let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
		let font: UIFont
		
		if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
			font = UIFont(descriptor: descriptor, size: size)
		} else {
			font = systemFont
		}
		
		return font
	}
	
	static func appFont(_ style: TextStyle, weight: Weight = .regular) -> UIFont {
		.preferredFont(forTextStyle: style).rounded(weight)
	}
	
}

import SwiftUI
struct UIFont_Previews: PreviewProvider {
	
	static var previews: some View {
		UIKitPreviews {
			let vc = UIViewController()
			vc.view.addSubview(view)
			view.constrain(.topEdges, to: .superview, modifiers: [ .margins(.init(all: 24)) ])
			return vc
		}
	}
	
	static var view: UIStackView = {
		let view = UIStackView(arrangedSubviews: [
			createLabel(text: "Hello, World", style: .largeTitle),
			createLabel(text: "Hello, World", style: .title1),
			createLabel(text: "Hello, World", style: .title2),
			createLabel(text: "Hello, World", style: .title3),
			Divider(),
			createLabel(text: "Hello, World", style: .headline),
			createLabel(text: "Hello, World", style: .subheadline),
			Divider(),
			createLabel(text: "Hello, World", style: .body),
			createLabel(text: "Hello, World", style: .callout),
			createLabel(text: "Hello, World", style: .footnote),
			Divider(),
			createLabel(text: "Hello, World", style: .caption1),
			createLabel(text: "Hello, World", style: .caption2),
			
		])
		view.spacing = .small
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fillProportionally
		return view
	}()
	
	static func createLabel(text: String, style: UIFont.TextStyle, weight: UIFont.Weight = .semibold) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = .appFont(style, weight: weight)
		return label
	}
	
}
