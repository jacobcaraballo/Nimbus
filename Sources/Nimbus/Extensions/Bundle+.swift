//
// Created by Jacob Caraballo on 5/6/23
//
        

import Foundation

extension Bundle {
	
	/// This can however change in new Xcode versions, so make sure to
	/// test it when a new version of Xcode is released. If it stops working,
	/// you can print out the path like this and look for the bundle name:
	///
	/// ```
	/// Bundle(for: BundleFinder.self)
	/// 	.resourceURL?
	/// 	.deletingLastPathComponent()
	/// 	.deletingLastPathComponent()
	/// ```
	static let myPackageBundleName = "Nimbus_Nimbus"
	
	private class BundleFinder {}
	
	public static let myPackage: Bundle = {
		let bundleNameIOS = myPackageBundleName
		let candidates = [
			// Bundle should be here when the package is linked into an App.
			Bundle.main.resourceURL,
			// Bundle should be here when the package is linked into a framework.
			Bundle(for: BundleFinder.self).resourceURL,
			// For command-line tools.
			Bundle.main.bundleURL,
			// Bundle should be here when running previews from a different package
			// (this is the path to "…/Debug-iphonesimulator/").
			Bundle(for: BundleFinder.self)
				.resourceURL?
				.deletingLastPathComponent()
				.deletingLastPathComponent()
				.deletingLastPathComponent(),
			Bundle(for: BundleFinder.self)
				.resourceURL?
				.deletingLastPathComponent()
				.deletingLastPathComponent(),
		]
		
		for candidate in candidates {
			let bundlePathiOS = candidate?.appendingPathComponent(bundleNameIOS + ".bundle")
			if let bundle = bundlePathiOS.flatMap(Bundle.init(url:)) {
				return bundle
			}
		}
		fatalError("Can't find myPackage custom bundle.")
	}()
	
}
