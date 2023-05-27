//
// Created by Jacob Caraballo on 2/24/23
//
        

import Foundation
import UIKit

public class Indicator: UIView {
	
	// MARK: - Init
	
	public init(_ axis: Axis, style: Style = .regular, color: UIColor = .separator) {
		self.axis = axis
		self.style = style
		super.init(frame: .zero)
		setup()
		
		self.color = color
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	private let axis: Axis
	
	private let style: Style
	
	public var color: UIColor {
		get {
			line.backgroundColor ?? .clear
		}
		set {
			line.backgroundColor = newValue
		}
	}
	
	private lazy var line: UIView = {
		let line = UIView()
		line.setCorners(.radius(style.value / 2))
		return line
	}()
	
	private func setup() {
		self.addSubview(line)
		line.constrain(.center, to: .superview)
		
		switch (axis, style) {
		case (.round, let style):
			line.constrain(.size, toConstant: style.value)
			
		case (.horizontal, let style):
			line.constrain([ .height ], toConstant: style.value)
			line.constrain([ .width ], to: .superview)
			
		case (.vertical, let style):
			line.constrain([ .width ], toConstant: style.value)
			line.constrain([ .height ], to: .superview)
			
		}
	}
	
}

extension Indicator {
	
	public enum Axis {
		
		case horizontal
		
		case vertical
		
		case round
		
	}
	
	public indirect enum Style {
		
		/// Indicator size of 2px.
		case xSmall
		
		/// Indicator size of 4px.
		case small
		
		/// Indicator size of 6px.
		case regular
		
		/// Indicator size of 8px.
		case large
		
		/// Indicator size of 10px.
		case xLarge
		
		/// Indicator with a custom size.
		case size(CGFloat)
		
		var value: CGFloat {
			switch self {
			case .xSmall: return 2
			case .small: return 4
			case .regular: return 6
			case .large: return 8
			case .xLarge: return 10
			case let .size(value): return value
			}
		}
		
	}
	
}

import SwiftUI
import UIKitPreviews
struct Indicator_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(view)
		view.constrain(.edges, to: .superview)
		return vc
	}()
	
	static var view: UIView = {
		let view = Indicator(.round, style: .regular, color: .systemMint)
		return view
	}()
}
