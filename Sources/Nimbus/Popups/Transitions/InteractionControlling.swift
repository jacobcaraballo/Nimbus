//
// Created by Jacob Caraballo on 3/17/23
//

import UIKit

protocol InteractionControlling: UIViewControllerInteractiveTransitioning {
	var interactionInProgress: Bool { get }
}
