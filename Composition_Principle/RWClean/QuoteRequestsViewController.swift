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

public final class QuoteRequestsViewController: UIViewController {
  
  // MARK: - Instance Properties
  internal let networkClient = NetworkClient.shared
  internal var quoteRequests: [QuoteRequestViewModel] = []
  
  // MARK: - Outlets
  @IBOutlet internal var tableView: UITableView! {
    didSet {
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(loadQuoteRequests), for: .valueChanged)
      tableView.refreshControl = refreshControl
      tableView.tableFooterView = UIView()
    }
  }
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    loadQuoteRequests()
  }
  
  internal func loadQuoteRequests() {
    
    tableView.refreshControl?.beginRefreshing()
    
    networkClient.getQuotes(success: { [weak self] quotes in
      guard let strongSelf = self else { return }
      strongSelf.quoteRequests = quotes.map { QuoteRequestViewModel(quoteRequest: $0) }
      strongSelf.tableView.reloadData()
      strongSelf.tableView.refreshControl?.endRefreshing()
      
      }, failure: { error in
        print("Load quote requests failed: \(error)")
    })
  }
}

// MARK: - UITableViewDataSource
extension QuoteRequestsViewController: UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quoteRequests.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "QuoteRequestCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! QuoteRequestTableViewCell
    let viewModel = quoteRequests[indexPath.row]
    viewModel.configure(cell)
    return cell
  }
}
