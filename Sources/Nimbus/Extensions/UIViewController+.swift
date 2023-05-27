//
// Created by Jacob Caraballo on 3/17/23
//

import Foundation
import UIKit

enum InteractiveDismissalType {
	case none
	case standard
}

extension UIViewController {
	func present(_ viewController: CustomPresentable, interactiveDismissalType: InteractiveDismissalType, completion: (() -> Void)? = nil) {
		
		let interactionController: InteractionControlling?
		switch interactiveDismissalType {
		case .none:
			interactionController = nil
		case .standard:
			interactionController = StandardInteractionController(viewController: viewController)
		}
		
		let transitionManager = PopupTransitionManager(interactionController: interactionController)
		viewController.transitionManager = transitionManager
		viewController.transitioningDelegate = transitionManager
		viewController.modalPresentationStyle = .custom
		present(viewController, animated: true, completion: completion)
	}
}
