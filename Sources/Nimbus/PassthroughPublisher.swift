//
//  Created by Jahziel Caraballo, Jacob on 1/17/23.
//

import Foundation
import Combine

/// Wraps an `AnyPublisher` with a `PassthroughSubject`, essentially combining both into a single declaration.
/// This eliminates the need of having an additional property that only exposes the publisher.
///
/// ```
/// /// Example Declaration
/// @PassthroughPublisher private var isLoggedIn: BoolPublisher
///
/// /// Send value
/// _publisher.send(true)
///
/// ```
@propertyWrapper
struct PassthroughPublisher<Output, Error: Swift.Error> {
    
    private var subject: PassthroughSubject<Output, Error> = .init()
    
    var wrappedValue: AnyPublisher<Output, Error> {
        subject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var projectedValue: Self { self }
    
    func send(_ input: Output) {
        subject.send(input)
    }
    
    mutating func send(completion: Subscribers.Completion<Error>) {
        subject.send(completion: completion)
        subject = .init()
    }
    
}
