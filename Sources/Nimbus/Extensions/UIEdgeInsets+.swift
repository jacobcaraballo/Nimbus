//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

extension UIEdgeInsets {
	public init(from insets: NSDirectionalEdgeInsets) {
		self.init(top: insets.top, left: insets.leading, bottom: insets.bottom, right: insets.trailing)
	}
	
	public init(all edges: CGFloat) {
		self.init(top: edges, left: edges, bottom: edges, right: edges)
	}
	
	public init(horizontal: CGFloat, vertical: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
	
	public init(horizontal: CGFloat) {
		self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
	}
	
	public init(vertical: CGFloat) {
		self.init(top: vertical, left: 0, bottom: vertical, right: 0)
	}
}

extension NSDirectionalEdgeInsets {
	public init(all edges: CGFloat) {
		self.init(top: edges, leading: edges, bottom: edges, trailing: edges)
	}
	
	public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
		self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
	}
}
