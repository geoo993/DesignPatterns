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

public final class QuoteRequest {
    
  // MARK: - Constants
  internal struct Keys {
    static let id = "id"
    static let created = "created"
    static let promised = "promised"
    static let userID = "rwuser_id"
    static let product = "product"
  }
  
  
  // MARK: - Instance Properties
  public let identifier: Int
  public let created: Date
  public let promised: Date
  public let userID: Int
  public let product: Product
  
  
  // MARK: - Object Lifecycle
  public init?(dictionary: [AnyHashable: Any]) {
    
    guard let identifier = dictionary[Keys.id] as? Int,
      let createdTimeInterval = dictionary[Keys.created] as? Double,
      let promisedTimeInterval = dictionary[Keys.promised] as? Double,
      let userID = dictionary[Keys.userID] as? Int,
      let productJSON = dictionary[Keys.product] as? [String: Any],
      let product = Product(json: productJSON) else {
      return nil
    }
    
    self.identifier = identifier
    self.created = Date(timeIntervalSince1970: createdTimeInterval)
    self.promised = Date(timeIntervalSince1970: promisedTimeInterval)
    self.userID = userID
    self.product = product
  }
  
  // MARK: - Class Constructors
  public class func array(from jsonArray: [[AnyHashable: Any]]) -> [QuoteRequest] {
    var array: [QuoteRequest] = []
    for dictionary in jsonArray {
      guard let quoteRequest = QuoteRequest(dictionary: dictionary) else {
        continue
      }
      array.append(quoteRequest)
    }
    return array
  }
}
