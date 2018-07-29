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

// MARK: - AuthControllerDelegate
internal protocol AuthControllerDelegate {
  
  func signInCancelled(on controller: UIViewController)
  
  func signInRequested(on controller: UIViewController,
                       email: String,
                       password: String,
                       failure: @escaping (SignInError) -> Void)
  
  func registerRequested(on controller: UIViewController,
                         email: String,
                         password: String,
                         firstName: String,
                         lastName: String,
                         phoneNumber: String,
                         failure: @escaping (RegisterError) -> Void)  
}

// MARK: - SignInError
public enum SignInError: Error {
  
  case invalidCredentials
  case networkProblem(Error)
  case unknown(URLResponse?)
  
  internal init(error: Error) {
    self = .networkProblem(error)
  }
  
  internal init(response: URLResponse?) {
    guard let httpResponse = response as? HTTPURLResponse else {
      self = .unknown(response)
      return
    }
    
    switch httpResponse.statusCode {
    case 404: self = .invalidCredentials
    default: self = .unknown(response)
    }
  }
}

// MARK: - RegisterError
internal enum RegisterError: Error {
  
  case emailTaken
  case networkProblem(Error)
  case unknown(URLResponse?)
  
  internal init(error: Error) {
    self = .networkProblem(error)
  }
  
  internal init(response: URLResponse?) {
    guard let httpResponse = response as? HTTPURLResponse else {
      self = .unknown(response)
      return
    }
    switch httpResponse.statusCode {
    case 404: self = .emailTaken
    default: self = .unknown(httpResponse)
    }
  }
}
