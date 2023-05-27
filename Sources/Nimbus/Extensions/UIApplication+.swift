//
// Created by Jacob Caraballo on 2/27/23
//
        

import Foundation
import UIKit

extension UIApplication {
	
	public static var keyWindow: UIWindow {
		shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first(where: { $0.activationState == .foregroundActive })?
			.keyWindow ?? UIWindow()
	}
	
	public static var visibleViewController: UIViewController? {
		getVisibleViewController(rootViewController: keyWindow.rootViewController)
	}
	
	private static func getVisibleViewController(rootViewController: UIViewController? = UIApplication.keyWindow.rootViewController) -> UIViewController? {
		
		if let navigationController = rootViewController as? UINavigationController {
			return getVisibleViewController(rootViewController: navigationController.visibleViewController)
		}
		
		if let tabController = rootViewController as? UITabBarController,
		   let selected = tabController.selectedViewController {
			return getVisibleViewController(rootViewController: selected)
		}
		
		if let presented = rootViewController?.presentedViewController {
			return getVisibleViewController(rootViewController: presented)
		}
		
		return rootViewController
		
	}
	
}
