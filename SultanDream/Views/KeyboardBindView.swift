//
//  KeyboardBindView.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 22.03.2022.
//

import UIKit

class KeyboardBindView: UIView {

    private var keyboardMaxHeight: CGFloat = 0
    private var lastDeltaY: CGFloat = 0
    private var bottomLayoutConstraint: NSLayoutConstraint?
    private var screenBottomPadding: CGFloat = 0
    private var scrollHandler: (CGFloat, Double) -> () = { _, _ in }
    private var tableView: UITableView?
    private var isBound: Bool = true
    private var mainTextField: UITextField?
    
    private var isConMen: Bool = false
    
    func setCM(b: Bool) {
        self.isConMen = b
    }
    
    func setTextField(tf: UITextField) {
        self.mainTextField = tf
    }
    
    func setIsBound(isBound: Bool) {
        self.isBound = isBound
    }
    
    func setTableView(tableV: UITableView) {
        self.tableView = tableV
    }
    
    func setScreenBottomPadding(padding: CGFloat) {
        self.screenBottomPadding = padding
    }
    
    func setBottomLayoutConstraint(constraint: NSLayoutConstraint) {
        self.bottomLayoutConstraint = constraint
    }
    
    func setScrollHandler(handler: @escaping (CGFloat, Double) -> ()) {
        self.scrollHandler = handler
    }
    
    func removeBindToKeyboard() {
        //print("removeBindToKeyboard")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    func bindToKeyboard() {
        //print("bindToKeyboard")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        if self.keyboardMaxHeight == 0 { self.keyboardMaxHeight = self.lastDeltaY }
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
//        print("keyboardWillChange")
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        //print("keyboardWillChange \(self.isBound) \(self.mainTextField?.isFirstResponder) \(startTime) \(duration)")
        if !self.isBound { return }
        guard let nextButtonBottomConstraint =  self.bottomLayoutConstraint else { return }
        
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let strartingFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var deltaY = endingFrame.origin.y - strartingFrame.origin.y
        var bottomPadding = UIScreen.main.bounds.height - (self.frame.origin.y + self.frame.height)
        if let superview = self.superview {
            bottomPadding -= superview.frame.origin.y
        }
        //print("keyboardWillChange \(deltaY) \(bottomPadding)")
        if deltaY == -50 || deltaY == 50 {
            deltaY = nextButtonBottomConstraint.constant
        } else if deltaY < -50 || deltaY > 50 {
            if endingFrame.origin.y > strartingFrame.origin.y {
                deltaY = nextButtonBottomConstraint.constant
                //print("keyboardWillChange nextButtonBottomConstraint \(deltaY)")
            } else {
                deltaY = deltaY + bottomPadding
                //print("keyboardWillChange bottomPadding \(deltaY)")
            }
        }
//        print("keyboardWillChange deltaY 1 \(deltaY)")
        self.lastDeltaY = abs(deltaY)
        let finalDuration = self.keyboardMaxHeight == 0 ? duration : (deltaY < 0 ? (Double(deltaY) / -Double(self.keyboardMaxHeight - self.screenBottomPadding) * duration) : (Double(deltaY) / Double(self.keyboardMaxHeight) * duration))
        self.scrollHandler(deltaY, finalDuration)
        if let contentOffsetPoint = self.tableView?.contentOffset {
            self.tableView?.setContentOffset(contentOffsetPoint, animated: false)
        }
//        if self.keyboardMaxHeight != 0 {
//            if nextButtonBottomConstraint.constant == 0 && deltaY != -self.keyboardMaxHeight {
//                deltaY = 0
//            }
//        }
//        print("keyboardWillChange deltaY \(deltaY) \(self.keyboardMaxHeight) \(nextButtonBottomConstraint.constant)")
        UIView.animateKeyframes(withDuration: finalDuration, delay: 0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
            if self.keyboardMaxHeight != 0 && (nextButtonBottomConstraint.constant - deltaY) > self.keyboardMaxHeight {
                //print("keyboardWillChange animate 1 \(deltaY) \(nextButtonBottomConstraint.constant)")
                self.tableView?.contentOffset.y -= nextButtonBottomConstraint.constant - self.keyboardMaxHeight
                nextButtonBottomConstraint.constant = self.keyboardMaxHeight
            } else if (nextButtonBottomConstraint.constant - deltaY) < 0 || (nextButtonBottomConstraint.constant == 0 && deltaY == -50) {
                //print("keyboardWillChange animate 2 \(deltaY) \(nextButtonBottomConstraint.constant)")
                self.tableView?.contentOffset.y -= nextButtonBottomConstraint.constant
                nextButtonBottomConstraint.constant = 0
            } else {
                //print("keyboardWillChange animate 3 \(deltaY) \(nextButtonBottomConstraint.constant)")
                nextButtonBottomConstraint.constant -= deltaY
                self.tableView?.contentOffset.y -= deltaY
            }
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }

}
