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

internal class SignInViewController: UIViewController {
  
  // MARK: - Instance Properties
  internal var delegate: AuthControllerDelegate!
  
  // MARK: - Outlets
  @IBOutlet internal var emailTextField: UITextField!
  @IBOutlet internal var passwordTextField: UITextField!
  
  // MARK: - Class Constructors
  internal class func instanceFromStoryboard(delegate: AuthControllerDelegate) -> UINavigationController {
    let bundle = Bundle(for: self)
    let storyboard = UIStoryboard(name: "Auth", bundle: bundle)
    let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    
    let viewController = navigationController.topViewController as! SignInViewController
    viewController.delegate = delegate
    
    return navigationController
  }
  
  // MARK: - Actions
  @IBAction func cancelButtonPressed(_ sender: Any) {
    delegate.signInCancelled(on: self)
  }
  
  @IBAction func signInButtonPressed(_ sender: Any) {
    attemptSignIn()
  }
  
  internal func attemptSignIn() {
    guard let email = emailTextField.text, !email.isEmpty,
      let password = passwordTextField.text, !password.isEmpty else {
        showMissingInputAlert()
        return
    }
    
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    
    showLoadingHUD()
    delegate.signInRequested(on: self, email: email, password: password, failure: handleError())
  }
  
  private func showMissingInputAlert() {
    let controller = UIAlertController(title: NSLocalizedString("Missing Email or Password", comment: ""),
                                       message: NSLocalizedString("Please check your inputs and try again", comment: ""),
                                       preferredStyle: .alert)
    
    controller.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                       style: .default))
    
    present(controller, animated: true)
  }
  
  private func handleError() -> (SignInError) -> Void {
    return { [weak self] in
      guard let strongSelf = self else { return }
      
      strongSelf.dismissLoadingHUD()
      
      switch $0 {
      case .invalidCredentials: strongSelf.showInvalidCredentialsAlert()
      default: strongSelf.showCheckInternetConnectionAlert()
      }
    }
  }
  
  private func showInvalidCredentialsAlert() {
    
    let controller = UIAlertController(title: NSLocalizedString("Incorrect Email or Password", comment: ""),
                                       message: NSLocalizedString("Please verify your inputs and try again", comment: ""),
                                       preferredStyle: .alert)
    
    controller.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                       style: .default))
    
    present(controller, animated: true)
  }
  
  private func showCheckInternetConnectionAlert() {
    
    let controller = UIAlertController(title: NSLocalizedString("Networking Error", comment: ""),
                                       message: NSLocalizedString("Please check your internet connection and try again", comment: ""),
                                       preferredStyle: .alert)
    
    let retry = UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default) { [weak self] _ in
      self?.attemptSignIn()
    }
    let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
    
    controller.addAction(retry)
    controller.addAction(cancel)
    
    present(controller, animated: true)
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let viewController = segue.destination as? RegisterViewController else { return }
    
    viewController.delegate = delegate
  }
}


// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
  
  public  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    
    return false
  }
}
