////
//// Created by Jacob Caraballo on 3/24/23
////
//
//
//import Foundation
//import UIKit
//
//extension NumberPad {
//
//	public struct Digit {
//
//		public let text: String
//
//		public let color: UIColor
//
//		public let action: Action
//		
//	}
//
//}
//
//extension NumberPad.Digit {
//
//	/// Represents the direction and amount of units in which a digit will span.
//	///
//	/// Eg, A digit with a dimension of `.horizontal(2)` will occupy 2
//	/// columns in the horizontal direction.
//	public enum Dimension {
//
//		/// Specifies a digit that occupies only a single row and column.
//		case equal
//
//		/// A digit that occupies the given number of rows in the vertical direction.
//		case vertical(_ rows: Int)
//
//		/// A digit that occupies the given number of columns in the horizontal direction.
//		case horizontal(_ columns: Int)
//
//	}
//
//}
//
//extension NumberPad.Digit {
//
//	public typealias Action = (Self) -> Void
//
//}
