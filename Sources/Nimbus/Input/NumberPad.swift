////
//// Created by Jacob Caraballo on 3/24/23
////
//        
//
//import Foundation
//import UIKit
//
//public class NumberPad: UICollectionView {
//	
//	private var digits: [Digit]
//	
//	private var numberOfColumns: Int
//	
//	private var numberOfRows: Int {
//		let numberOfRows = Double(digits.count) / Double(numberOfColumns)
//		return Int(ceil(numberOfRows))
//	}
//	
//	// MARK: - Init
//	
//	public init(digits: [Digit], numberOfColumns: Int) {
//		self.digits = digits
//		self.numberOfColumns = numberOfColumns
//		super.init(frame: .zero, collectionViewLayout: NumberPadLayout(numberOfColumns: numberOfColumns))
//		
//		setup()
//	}
//	
//	required init(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	// MARK: - Properties
//	
//	
//	
//}
//
//// MARK: - Setup
//
//extension NumberPad {
//	
//	private func setup() {
//		self.digits.enumerated().forEach { (index, digit) in
//			let remainder = (index + 1) % self.numberOfColumns
//			
//			if remainder == 0 {
//				// create new row
//			} else {
//				// add to current row
//			}
//		}
//	}
//	
//	private func createColumn() -> UIStackView {
//		let stackView
//	}
//	
//}
//
//import SwiftUI
//import UIKitPreviews
//struct NumberPad_Previews: PreviewProvider {
//	static var previews: some View {
//		UIKitPreviews { viewController }
//	}
//	
//	static var viewController: UIViewController = {
//		let vc = UIViewController()
//		vc.view.addSubview(view)
//		view.constrain(.topEdges)
//		return vc
//	}()
//	
//	static var view: UIView = {
//		let digits = [
//			"7", "8", "9",
//			"4", "5", "6",
//			"1", "2", "3",
//			"0", "."]
//			.map { digitString -> NumberPad.Digit in
//				.init(
//					text: digitString,
//					color: .secondaryLabel) { _ in }
//			}
//		let numberPad: NumberPad = .init(digits: digits)
//		
//		return numberPad
//	}()
//}
