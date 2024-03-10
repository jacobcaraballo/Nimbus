//
// Created by Jacob Caraballo on 5/27/23
//
        

import Foundation
import UIKit

public protocol GraphDisplay: UIView {
		
	var dataPoints: [GraphDisplayPoint] { get set }
	
	func getDataPoint(for position: CGPoint) -> GraphDisplayPoint?
	
}
