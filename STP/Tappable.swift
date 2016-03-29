//
//  Tappable.swift
//  STP
//
//  Created by Chris O'Neil on 10/11/15.
//  Copyright © 2015 Because. All rights reserved.
//

import UIKit

public protocol Tappable {
    func makeTappable()
    func didTap()
    func didTouchDown()
    func didTouchUp()
    func minimumPressDuration() -> NSTimeInterval
    func allowableMovement() -> CGFloat
}

public extension Tappable where Self:UIView {

    func makeTappable() {

        let gestureRecognizer = UILongPressGestureRecognizer { [unowned self] (recognizer) -> Void in
            let tap = recognizer as! UILongPressGestureRecognizer

            func isInFrame() -> Bool {
                let location = recognizer.locationInView(self)
                switch location {
                case _ where location.x < 0 - self.frame.size.width / 2,
                    _ where location.x > self.frame.size.width * 1.5,
                    _ where location.y < 0 - self.frame.size.height / 2,
                    _ where location.y > self.frame.size.height * 1.5:
                    return false
                default:
                    return true
                }
            }

            switch tap.state {
            case .Began:
                self.didTouchDown()
            case .Ended:
                self.didTouchUp()
                if isInFrame() {
                    self.didTap()
                }
            case .Failed, .Cancelled:
                self.didTouchUp()
            case .Changed:
                if isInFrame() {
                    self.didTouchDown()
                } else {
                    self.didTouchUp()
                }
            case .Possible: break
            }
        }

        gestureRecognizer.minimumPressDuration = self.minimumPressDuration()
        gestureRecognizer.allowableMovement = self.allowableMovement()
        self.addGestureRecognizer(gestureRecognizer)
    }

    func didTap() {
        return
    }

    func didTouchDown() {
        self.alpha = 0.5
    }

    func didTouchUp() {
        self.alpha = 1.0
    }

    func minimumPressDuration() -> NSTimeInterval {
        return 0.001
    }

    func allowableMovement() -> CGFloat {
        return 10.0
    }
}
