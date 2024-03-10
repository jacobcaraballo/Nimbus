//
// Created by Jacob Caraballo on 5/9/23
//
        

import Foundation
import UIKit

class SomeViewController: UIViewController {
	
	private var viewModel: SomeViewModelType
	
	public init(viewModel: SomeViewModelType) {
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
}
