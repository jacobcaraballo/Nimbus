//
// Created by Jacob Caraballo on 4/2/23
//
        

import Foundation
import UIKit

public class CheckboxStack {
	
	public enum SelectionStyle {
		case single
		case multiple
	}
	
	public typealias OnAction = (_ checkbox: Checkbox) -> Void
	
	public var onAction: OnAction?
	
	public var selectionStyle: SelectionStyle = .multiple
	
	private var selectedCheckboxes: [Checkbox] = []
	
	public var checkboxes: [Checkbox] = []
	
	public func addCheckbox(_ checkbox: Checkbox) {
		checkbox.stack = self
		checkboxes.append(checkbox)
	}
	
	public func removeCheckbox(_ checkbox: Checkbox) {
		checkbox.stack = nil
		checkboxes.removeAll(where: { $0 == checkbox })
	}
	
	public func addCheckboxes(_ checkboxes: [Checkbox]) {
		checkboxes.forEach { addCheckbox($0) }
	}
	
	public func selectCheckbox(_ checkbox: Checkbox) {
		if selectionStyle == .single {
			deselectAllCheckboxes()
		}
		
		selectedCheckboxes.append(checkbox)
		
		checkbox.setIsOn(true)
		onAction?(checkbox)
	}
	
	public func selectCheckbox(at index: Int) {
		selectCheckbox(checkboxes[index])
	}
	
	public func toggleCheckbox(_ checkbox: Checkbox) {
		guard selectionStyle == .multiple else {
			selectCheckbox(checkbox)
			return
		}
		
		if isCheckboxSelected(checkbox) {
			deselectCheckbox(checkbox)
		} else {
			selectCheckbox(checkbox)
		}
	}
	
	public func isCheckboxSelected(_ checkbox: Checkbox) -> Bool {
		selectedCheckboxes.contains(checkbox)
	}
	
	private func deselectAllCheckboxes() {
		checkboxes.forEach { $0.setIsOn(false) }
		selectedCheckboxes.removeAll()
	}
	
	private func deselectCheckbox(_ checkbox: Checkbox) {
		checkbox.setIsOn(false)
		selectedCheckboxes.removeAll(where: { $0 == checkbox })
	}
	
}

// MARK: - Previews

import SwiftUI
import UIKitPreviews
struct CheckboxStack_Previews: PreviewProvider {
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
		let checkboxStack = CheckboxStack()
		checkboxStack.selectionStyle = .single
		checkboxStack.addCheckboxes([
			checkbox,
			checkbox,
			checkbox,
			checkbox
		])
		checkboxStack.selectCheckbox(at: 0)
		let stack = UIStackView(arrangedSubviews: checkboxStack.checkboxes)
		stack.axis = .vertical
		return stack
	}()
	
	static var checkbox: Checkbox {
		let checkbox = Checkbox()
		checkbox.tintColor = .systemTeal
		return checkbox
	}
}
