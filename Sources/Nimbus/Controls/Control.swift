//
// Created by Jacob Caraballo on 2/27/23
//
        

import Foundation
import UIKit

public protocol Control: UIView {
	
	typealias OnAction = (_ isOn: Bool) -> Void

	var onAction: OnAction? { get set }
	
	var isOn: Bool { get set }
	
}
