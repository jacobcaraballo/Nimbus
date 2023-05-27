//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

extension UIScrollView {
	
	public indirect enum ScrollPosition {
		
		case centerX
		
		case centerY
		
		case left
		
		case right
		
		case top
		
		case bottom
		
		case offset(ScrollPosition, CGFloat)
		
	}
	
	private func getRectForScrollPosition(
		in view: UIView,
		position: ScrollPosition,
		origin: CGPoint,
		offset: CGFloat = 0
	) -> CGRect {
		switch position {
		case .centerX:
			let childCenterX = origin.x + view.frame.width / 2.0
			let scrollViewCenterX = frame.size.width / 2.0
			
			return .init(
				x: .maximum(childCenterX - scrollViewCenterX - offset, 0),
				y: 0,
				width: self.frame.width,
				height: 1)
			
		case .left:
			return .init(
				x: origin.x - offset,
				y: 0,
				width: self.frame.width,
				height: 1)
			
		case .right:
			let childEndX = origin.x + view.frame.width
			return .init(
				x: .maximum(childEndX - frame.size.width + offset, 0),
				y: 0,
				width: self.frame.width,
				height: 1)
			
		case .centerY:
			let childCenterY = origin.y + view.frame.height / 2.0
			let scrollViewCenterY = frame.size.height / 2.0
			
			return .init(
				x: 0,
				y: .maximum(childCenterY - scrollViewCenterY - offset, 0),
				width: 1,
				height: self.frame.height)
			
		case .top:
			return .init(
				x: 0,
				y: origin.y - offset,
				width: 1,
				height: self.frame.height)
			
		case .bottom:
			let childEndY = origin.y + view.frame.height
			return .init(
				x: 0,
				y: .maximum(childEndY - frame.size.height + offset, 0),
				width: 1,
				height: self.frame.height)
			
		case let .offset(position, offset):
			return getRectForScrollPosition(in: view, position: position, origin: origin, offset: offset)
			
		}
	}
	
	public func scrollTo(
		_ view: UIView,
		position: ScrollPosition,
		animated: Bool
	) {
		guard let origin = view.superview?
			.convert(view.frame.origin, to: self)
		else { return }
		
		let rect = getRectForScrollPosition(in: view, position: position, origin: origin)
		scrollRectToVisible(rect, animated: animated)
	}
	
}
