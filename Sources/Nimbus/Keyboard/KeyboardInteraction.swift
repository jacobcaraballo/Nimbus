//
// Created by Jacob Caraballo on 3/17/23
//
        

import Foundation
import UIKit
import Combine

public class KeyboardInteraction {
	
	public enum State {
		case willShow(Configuration)
		case willDismiss(Configuration)
	}
	
	public typealias StatePublisher = AnyPublisher<State, Never>
	
	public struct Configuration: Hashable {
		public let frame: CGRect
		public let animationDuration: TimeInterval
		public let animationCurve: UIView.AnimationCurve
		
		public static var zero: Self {
			.init(
				frame: .zero,
				animationDuration: .zero,
				animationCurve: .linear)
		}
		
		public func hash(into hasher: inout Hasher) {
			hasher.combine(frame.height)
			hasher.combine(frame.width)
			hasher.combine(frame.origin.x)
			hasher.combine(frame.origin.y)
			hasher.combine(animationDuration)
			hasher.combine(animationCurve)
		}
	}
	
	static var shared = KeyboardInteraction()
	
	private var cancellables = Set<AnyCancellable>()
	
	@PassthroughPublisher private var state: StatePublisher
	
	private init() {
		setup()
	}
	
	private func setup() {
		NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] notification in
				self?.keyboardWillShow(notification)
			}
			.store(in: &cancellables)
		
		NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] notification in
				self?.keyboardWillDismiss(notification)
			}
			.store(in: &cancellables)
	}
	
	private func keyboardWillShow(_ notification: Notification) {
		guard let userInfo = notification.userInfo,
			  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
			  let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
			  let targetFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
				 NSValue)?.cgRectValue,
			  let curve = UIView.AnimationCurve(rawValue: Int(curveValue))
		else { return }
		
		let config: Configuration = .init(
			frame: targetFrame,
			animationDuration: duration,
			animationCurve: curve)
		_state.send(.willShow(config))
	}
	
	private func keyboardWillDismiss(_ notification: Notification) {
		guard let userInfo = notification.userInfo,
			  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
			  let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
			  let targetFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
								 NSValue)?.cgRectValue,
			  let curve = UIView.AnimationCurve(rawValue: Int(curveValue))
		else { return }
		
		let config: Configuration = .init(
			frame: targetFrame,
			animationDuration: duration,
			animationCurve: curve)
		_state.send(.willDismiss(config))
	}
		
	public static func observeKeyboardState() -> StatePublisher {
		Self.shared.state
	}
	
}

extension UIView {
	
	public func findFirstResponder() -> UIView? {
		guard !self.isFirstResponder else {
			return self
		}
		
		guard !self.subviews.isEmpty else {
			return nil
		}
		
		return self.subviews.first { $0.findFirstResponder() != nil }
	}
	
}
