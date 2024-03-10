//
// Created by Jacob Caraballo on 5/28/23
//
        

import Foundation
import UIKit

public class RegularGraphFilterChip: Button, GraphFilterChip {
	
	public var id: GraphFilterChipID
	
	init(title: String, id: GraphFilterChipID) {
		self.id = id
		
		super.init(.regularMini)
		
		self.setTitle(title, for: .normal)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
