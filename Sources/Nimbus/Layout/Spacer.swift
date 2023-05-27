//
// Created by Jacob Caraballo on 2/22/23
//
        

import Foundation
import UIKit

public class Spacer: UIView {
	
	private let style: Style
	
	private lazy var line: UIView = {
		let line = UIView()
		line.backgroundColor = .clear
		return line
	}()
	
	private func setup() {
		self.addSubview(line)
		line.constrain(
			.edges,
			to: .superview,
			modifiers: [
				.margins(.init(vertical: style.value))
			])
		line.constrain([ .height ], toConstant: 0)
	}
	
	public init(_ style: Style = .regular) {
		self.style = style
		super.init(frame: .zero)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension Spacer {
	
	public enum Style {
		
		/// Spacer providing 4px of space.
		case xSmall
		
		/// Spacer providing 8px of space.
		case small
		
		/// Spacer providing 12px of space.
		case regular
		
		/// Spacer providing 16px of space.
		case large
		
		/// Spacer providing 20px of space.
		case xLarge
		
		/// Spacer providing the given custom space..
		case value(CGFloat)
		
		public var value: CGFloat {
			switch self {
			case .xSmall: return 4
			case .small: return 8
			case .regular: return 12
			case .large: return 16
			case .xLarge: return 20
			case let .value(value): return value
			}
		}
		
	}
	
}
