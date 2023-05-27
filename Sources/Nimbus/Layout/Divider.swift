//
// Created by Jacob Caraballo on 2/21/23
//
        

import Foundation
import UIKit

public class Divider: UIView {
	
	private let style: Style
	
	private lazy var line: UIView = {
		let line = UIView()
		return line
	}()
	
	private func setup() {
		self.addSubview(line)
		line.constrain(
			.edges,
			to: .superview,
			modifiers: [
				.margins(.init(vertical: style.rawValue))
			])
		line.constrain([ .height ], toConstant: 0.5)
		line.setContentCompressionResistancePriority(.required, for: .horizontal)
		line.setContentCompressionResistancePriority(.required, for: .vertical)
	}
	
	public init(_ style: Style = .regular, color: UIColor = .separator) {
		self.style = style
		super.init(frame: .zero)
		
		self.line.backgroundColor = color
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension Divider {
	
	public enum Style: CGFloat {
		
		/// Divider with no vertical space.
		case noSpace = 0
		
		/// Divider providing 4px of space.
		case xSmall = 4
		
		/// Divider providing 8px of space.
		case small = 8
		
		/// Divider providing 12px of space.
		case regular = 12
		
		/// Divider providing 16px of space.
		case large = 16
		
		/// Divider providing 20px of space.
		case xLarge = 20
		
	}
	
}
