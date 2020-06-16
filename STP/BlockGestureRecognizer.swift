//
//  BlockGestureRecognizer.swift
//  STP
//
//  Created by Chris O'Neil on 10/11/15.
//  Copyright © 2015 Because. All rights reserved.
//


private class MultiDelegate : NSObject, UIGestureRecognizerDelegate {
    @objc func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIGestureRecognizer {

    struct PropertyKeys {
        static var blockKey = "BCBlockPropertyKey"
        static var multiDelegateKey = "BCMultiDelegateKey"
    }

    private var block:((_ recognizer:UIGestureRecognizer) -> Void) {
        get {
            return Associator.getAssociatedObject(object: self, associativeKey:&PropertyKeys.blockKey)!
        }
        set {
            Associator.setAssociatedObject(object: self, value: newValue, associativeKey:&PropertyKeys.blockKey, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var multiDelegate:MultiDelegate {
        get {
            return Associator.getAssociatedObject(object: self, associativeKey:&PropertyKeys.multiDelegateKey)!
        }
        set {
            Associator.setAssociatedObject(object: self, value: newValue, associativeKey:&PropertyKeys.multiDelegateKey, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }

    convenience init(block:@escaping (_ recognizer:UIGestureRecognizer) -> Void) {
        self.init()
        self.block = block
        self.multiDelegate = MultiDelegate()
        self.delegate = self.multiDelegate
        self.addTarget(self, action: "didInteractWithGestureRecognizer:")
    }

    @objc func didInteractWithGestureRecognizer(sender:UIGestureRecognizer) {
        self.block(sender)
    }
}
