/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit


public class AvoidKeyboardScrollView: UIScrollView {
  
  // MARK: - Injections
  internal let notificationCenter = NotificationCenter.default
  
  // MARK: - Instance Properties
  private var originalContentInset: UIEdgeInsets!
    
  // MARK: - Object Lifecycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  internal func commonInit() {
    registerForKeyboardNotifications()
    originalContentInset = contentInset
  }
  
  deinit {
    notificationCenter.removeObserver(self)
  }
  
  // MARK: - Keyboard Notifications
  
  private func registerForKeyboardNotifications() {
    
    notificationCenter.addObserver(self, selector: #selector(keyboardWillShown(_:)),
                                   name: .UIKeyboardWillShow, object: nil)
    
    notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                   name: .UIKeyboardWillHide, object: nil)
    
  }
  
  @objc private func keyboardWillShown(_ notification: NSNotification) {
    
    let info = notification.userInfo!
    let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! CGRect).size
    
    contentInset = UIEdgeInsets(top: originalContentInset.top,
                                left: originalContentInset.left,
                                bottom: originalContentInset.bottom + kbSize.height,
                                right: originalContentInset.right)
    
    animateSetContentInset(contentInset, info: info)
  }
  
  @objc private func keyboardWillHide(_ notification: NSNotification) {
    
    let info = notification.userInfo!
    animateSetContentInset(originalContentInset, info: info)
  }
  
  private func animateSetContentInset(_ value: UIEdgeInsets, info: [AnyHashable: Any]) {
    
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(info[UIKeyboardAnimationDurationUserInfoKey] as! Double)
    UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey] as! Int)!)
    UIView.setAnimationBeginsFromCurrentState(true)
    contentInset = value
    layoutIfNeeded()
    UIView.commitAnimations()
  }
}
