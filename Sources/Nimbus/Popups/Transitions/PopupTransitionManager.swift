//
// Created by Jacob Caraballo on 3/17/23
//

import UIKit

class PopupTransitionManager: NSObject {
	
	private var interactionController: InteractionControlling?
	
	init(interactionController: InteractionControlling?) {
		self.interactionController = interactionController
	}
}

extension PopupTransitionManager: UIViewControllerTransitioningDelegate {
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return PopupPresentationController(presentedViewController: presented, presenting: presenting)
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return PopupAnimator(presenting: true)
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return PopupAnimator(presenting: false)
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		guard let interactionController = interactionController, interactionController.interactionInProgress else {
			return nil
		}
		return interactionController
	}
}
