//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

// MARK: - Animator

public typealias Animator = UIViewPropertyAnimator

extension UIViewPropertyAnimator {
	
	public typealias Animations = () -> Void
	
	public typealias Completion = () -> Void
	
	public static func animator(duration: TimeInterval, timing: Timing, animations: @escaping Animations) -> UIViewPropertyAnimator {
		switch timing {
		case let .curve(curve):
			return .init(duration: duration, curve: curve, animations: animations)
			
		case let .spring(dampingRatio):
			return .init(duration: duration, dampingRatio: dampingRatio, animations: animations)
			
		case let .curveProvider(provider),
			let .springParameters(provider as UITimingCurveProvider),
			let .cubicParamaters(provider as UITimingCurveProvider):
			let anim = UIViewPropertyAnimator(duration: duration, timingParameters: provider)
			anim.addAnimations(animations)
			return anim
			
		case let .controlPoints(point1, point2):
			return .init(duration: duration, controlPoint1: point1, controlPoint2: point2, animations: animations)
			
		}
	}
	
	public static func animate(duration: TimeInterval, timing: Timing, animations: @escaping Animations, completion: Completion? = nil) {
		let animator = self.animator(duration: duration, timing: timing, animations: animations)
		animator.addCompletion { _ in
			completion?()
		}
		animator.startAnimation()
	}
	
}

extension UIViewPropertyAnimator {
	
	public enum Timing {
		/// The UIKit timing curve to apply to the animation.
		case curve(UIView.AnimationCurve)
		
		/// The damping ratio to apply to the initial acceleration and oscillation.
		/// To smoothly decelerate the animation without oscillation, specify a
		/// value of 1. Specify values closer to 0 to create less damping and
		/// more oscillation.
		case spring(CGFloat)
		
		/// The object providing the timing information. This object must adopt
		/// the UITimingCurveProvider protocol.
		case curveProvider(UITimingCurveProvider)
		
		/// The timing information for animations that mimics the behavior of a spring.
		case springParameters(UISpringTimingParameters)
		
		/// The timing information for animations in the form of a cubic Bézier curve.
		case cubicParamaters(UICubicTimingParameters)
		
		/// Initializes the animator object with a cubic Bézier timing curve.
		case controlPoints(_ point1: CGPoint, _ point2: CGPoint)
	}
	
}
