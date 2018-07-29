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

// MARK: - QuoteRequestViewModelView
public protocol QuoteRequestViewModelView: NSObjectProtocol {
  var productTitleLabel: UILabel? { get }
  var requestedDateLabel: UILabel? { get }
  var promiseDateLabel: UILabel? { get }
}

// MARK: - QuoteRequestViewModel
public final class QuoteRequestViewModel {
  
  // MARK: - Class Properties
  internal static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
  }()
  
  // MARK: - Instance Properties
  public let quoteRequest: QuoteRequest
  
  public let productTitle: String
  public let promisedDateText: String
  public let requestedDateText: String
  
  // MARK: - Object Lifecycle
  public init(quoteRequest: QuoteRequest) {
    self.quoteRequest = quoteRequest
    
    self.productTitle = quoteRequest.product.title
    
    let dateFormatter = QuoteRequestViewModel.dateFormatter
    self.promisedDateText = dateFormatter.string(from: quoteRequest.promised)
    self.requestedDateText = dateFormatter.string(from: quoteRequest.created)
  }
}

extension QuoteRequestViewModel {
  
  public func configure(_ view: QuoteRequestViewModelView) {
    view.productTitleLabel?.text = productTitle
    view.requestedDateLabel?.text = requestedDateText
    view.promiseDateLabel?.text = promisedDateText
  }
}
