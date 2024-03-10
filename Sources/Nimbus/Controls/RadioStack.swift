//
// Created by Jacob Caraballo on 4/2/23
//
        

import Foundation
import UIKit

public class RadioStack {
	
	public typealias OnAction = (_ radio: Radio) -> Void
	
	public var onAction: OnAction?
	
	// MARK: - Init
	
	private var selectedRadio: Radio?
	
	public var radios: [Radio] = []
	
	public func addRadio(_ radio: Radio) {
		radio.stack = self
		radios.append(radio)
	}
	
	public func removeRadio(_ radio: Radio) {
		radio.stack = nil
		radios.removeAll(where: { $0 == radio })
	}
	
	public func addRadios(_ radios: [Radio]) {
		radios.forEach { addRadio($0) }
	}
	
	public func selectRadio(_ radio: Radio) {
		deselectAllRadios()
		selectedRadio = radio
		selectedRadio?.setIsOn(true)
		
		if let radio = selectedRadio {
			onAction?(radio)
		}
	}
	
	public func selectRadio(at index: Int) {
		selectRadio(radios[index])
	}
	
	private func deselectAllRadios() {
		radios.forEach { $0.setIsOn(false) }
	}
	
}

// MARK: - Previews

import SwiftUI
import UIKitPreviews
struct RadioStack_Previews: PreviewProvider {
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
