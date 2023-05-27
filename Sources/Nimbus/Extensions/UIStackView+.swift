//
// Created by Jacob Caraballo on 2/21/23
//
        

import Foundation
import UIKit

extension UIStackView {
	
	public func addArrangedSubviews(_ arrangedSubviews: [UIView]) {
		arrangedSubviews.forEach { self.addArrangedSubview($0) }
	}
	
	public func removeArrangedSubviews() {
		arrangedSubviews.forEach { self.removeArrangedSubview($0) }
	}
	
	public func removeArrangedSubviews<T: Any>(ofType: T) {
		arrangedSubviews
			.filter { $0 is T }
			.forEach { self.removeArrangedSubview($0) }
	}
	
}
