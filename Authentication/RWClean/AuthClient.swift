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

// MARK: - BasicAuthToken
fileprivate struct BasicAuthToken: AuthToken {
  
  fileprivate var email: String
  fileprivate var password: String
  
  fileprivate func authenticationHeaders() -> [String: String] {
    let data = "\(email):\(password)".data(using: .utf8)!
    let value = data.base64EncodedString()
    return ["Authorization": "Basic \(value)"]
  }
}

// MARK: - CustomStringConvertible
extension BasicAuthToken: CustomStringConvertible {
  
  fileprivate var description: String {
    return "BasicAuthToken: {username: \(email), password: \(password) }"
  }
}

// MARK: - AuthClient
public final class AuthClient {
  
  public typealias Success = (AuthToken, User) -> Void
  public typealias Cancel = () -> Void
  
  // MARK: - Constants
  private struct Keys {
    static let token = "token"
    static let user = "user"
  }
  
  // MARK: - Instance Properties
  public var user: User? {
    return authTuple?.user
  }
  
  fileprivate var authTuple: (token: BasicAuthToken, user: User)?
  fileprivate let baseURL: URL
  fileprivate let session = URLSession.shared  
  fileprivate var window: UIWindow?
  
  fileprivate let multicastDelegate = MulticastClosureDelegate<Success, Cancel>()
  
  // MARK: - Class Constructors
  public static let shared: AuthClient = {
    let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: file)!
    let urlString = dictionary["auth_url"] as! String
    let url = URL(string: urlString)!
    return AuthClient(baseURL: url)
  }()
  
  // MARK: - Object Lifecycle
  private init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  // MARK: - Instance Methods
  public func requestAuthToken(_ object: AnyObject,
                               queue: DispatchQueue? = .main,
                               success: @escaping Success,
                               userCancelled: @escaping Cancel) {
    
    if let (token, user) = authTuple {
      success(token, user)
      return
    }
    
    multicastDelegate.addClosurePair(for: object, success: success, failure: userCancelled)
    guard multicastDelegate.count == 1 else { return }
    showSignInWindow()
  }
  
  public func signOut() {
    authTuple = nil
  }
  
  private func showSignInWindow() {
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      let frame = UIScreen.main.bounds
      let window = UIWindow(frame: frame)
      window.rootViewController = SignInViewController.instanceFromStoryboard(delegate: strongSelf)
      window.makeKeyAndVisible()
      window.alpha = 0.0
      UIView.animate(withDuration: 0.33) { window.alpha = 1.0 }
      strongSelf.window = window
    }
  }
}

// MARK: - AuthControllerDelegate
extension AuthClient: AuthControllerDelegate {
  
  internal func signInCancelled(on controller: UIViewController) {
    multicastDelegate.getFailureTuples().forEach { closure, queue in
      queue.async(execute: closure)
    }
    dismissSignInWindow()
  }
  
  private func notifySignInSuccess(_ token: BasicAuthToken, _ user: User) {
    multicastDelegate.getSuccessTuples().forEach { closure, queue in
      queue.async {
        closure(token, user)
      }
    }
    dismissSignInWindow()
  }
  
  internal func signInRequested(on controller: UIViewController,
                                email: String,
                                password: String,
                                failure: @escaping (SignInError) -> Void) {
    
    let token = BasicAuthToken(email: email, password: password)
    let url = baseURL.appendingPathComponent("login")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    token.setAuthenticationHeaders(on: &request)
    
    let task = session.dataTask(with: request) { [weak self] (data, response, error) in
      guard let strongSelf = self else { return }
      if let error = error {
        DispatchQueue.main.async {
          let signInError = SignInError(error: error)
          print("Sign In Failed: \(error)")
          failure(signInError)
        }
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode.isSuccessHTTPCode,
        let data = data,
        let user = User(jsonData: data) else {
          DispatchQueue.main.async {
            let signInError = SignInError(response: response)
            print("Sign In Failed: \(signInError)")
            failure(signInError)
          }
          return
      }
      strongSelf.authTuple = (token, user)
      strongSelf.notifySignInSuccess(token, user)
      strongSelf.dismissSignInWindow()
    }
    task.resume()
  }
  
  internal func registerRequested(on controller: UIViewController,
                                  email: String,
                                  password: String,
                                  firstName: String,
                                  lastName: String,
                                  phoneNumber: String,
                                  failure: @escaping (RegisterError) -> Void) {
    
    let token = BasicAuthToken(email: email, password: password)
    let url = baseURL.appendingPathComponent("users")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let parameters = [
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber
    ]
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
    token.setAuthenticationHeaders(on: &request)
    
    let task = session.dataTask(with: request) { [weak self] (data, response, error) in
      guard let strongSelf = self else { return }
      if let error = error {
        DispatchQueue.main.async {
          print("Register Failed: \(error)")
          failure(.networkProblem(error))
        }
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode.isSuccessHTTPCode,
        let data = data,
        let user = User(jsonData: data) else {
          let registerError = RegisterError(response: response)
          DispatchQueue.main.async {
            print("Register Failed: \(registerError)")
            failure(registerError)
          }
          return
      }
      strongSelf.authTuple = (token, user)
      strongSelf.notifySignInSuccess(token, user)
    }
    task.resume()
  }
  
  private func dismissSignInWindow() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.33, animations: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.window?.alpha = 0.0
        
        }, completion: { [weak self] _ in
          guard let strongSelf = self else { return }
          strongSelf.window = nil
      })
    }
  }
}
