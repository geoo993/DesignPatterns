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

internal final class UserViewController: UIViewController {
  
  // MARK: - Injections
  internal let authClient = AuthClient.shared
  
  // MARK: - Outlets
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var firstNameTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
  @IBOutlet var phoneNumberTextField: UITextField!
  @IBOutlet var userTextFields: [UITextField]!
  
  @IBOutlet var signInButton: UIButton!
  @IBOutlet var signOutButton: UIButton!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()        
    configureView(authClient.user)
  }
  
  private func configureView(_ user: User?) {
    
    guard let user = user else {
      signInButton.isHidden = false
      signOutButton.isHidden = true
      userTextFields.forEach {
        $0.isHidden = true
        $0.text = nil
      }
      return
    }
    
    signInButton.isHidden = true
    signOutButton.isHidden = false
    userTextFields.forEach { $0.isHidden = false }
    
    emailTextField.text = user.email
    firstNameTextField.text = user.firstName
    lastNameTextField.text = user.lastName
    phoneNumberTextField.text = user.phoneNumber
  }
  
  // MARK: - Actions
  @IBAction func signInButtonPressed(_ sender: Any) {
    authClient.requestAuthToken(self, success: { [weak self] (_, user) in
      guard let strongSelf = self else { return }
      strongSelf.configureView(user)
      
      }, userCancelled: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.configureView(nil)
    })
  }
  
  @IBAction func signOutButtonPressed(_ sender: Any) {
    authClient.signOut()
    configureView(nil)
  }
}
