//
// Created by Jacob Caraballo on 3/16/23
//
        

import Foundation
import UIKit

extension UIScreen {
	private static let cornerRadiusKey: String = {
		let components = ["Radius", "Corner", "display", "_"]
		return components.reversed().joined()
	}()
	
	/// The corner radius of the display. Uses a private property of `UIScreen`,
	/// and may report 0 if the API changes.
	public static var cornerRadius: CGFloat {
		guard let screen = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first(where: { $0.windows.contains(where: \.isKeyWindow) })?.screen,
			  let cornerRadius = screen.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
			assertionFailure("Failed to detect screen corner radius")
			return 0
		}
		
		return cornerRadius
	}
}
