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

import Foundation

public final class User {
  
  // MARK: - Constants
  internal struct Keys {
    static let id = "id"
    static let email = "email"
    static let firstName = "first_name"
    static let phoneNumber = "phone_number"
    static let lastName = "last_name"
  }
  
  // MARK: - Intance Properties
  public var id: Int
  public var email: String
  public var firstName: String
  public var phoneNumber: String
  public var lastName: String
    
  // MARK: - Object Lifecycle
  public convenience init?(jsonData data: Data) {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
      let dictionary = jsonObject as? [AnyHashable: Any] else {
        return nil
    }
    self.init(dictionary: dictionary)
  }
  
  public init?(dictionary: [AnyHashable: Any]) {
    
    guard let id = dictionary[Keys.id] as? Int,
      let email = dictionary[Keys.email] as? String,
      let firstName = dictionary[Keys.firstName] as? String,
      let phoneNumber = dictionary[Keys.phoneNumber] as? String,
      let lastName = dictionary[Keys.lastName] as? String else {
        return nil
    }
    
    self.id = id
    self.email = email
    self.firstName = firstName
    self.phoneNumber = phoneNumber
    self.lastName = lastName
  }
}
