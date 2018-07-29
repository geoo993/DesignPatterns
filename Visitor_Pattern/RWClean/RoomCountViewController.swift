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

// MARK: - RoomCountDataSource
public protocol RoomCountDataSourceProtocol: HomeInfoDataSourceProtocol {
  var count: UInt { get set }
  var roomTitlePlural: String { get }
}

public class RoomCountViewController: HomeInfoViewController {
  
  // MARK: - Injections
  public var countDataSource: RoomCountDataSourceProtocol? {
    didSet {
      homeInfoDataSource = countDataSource
    }
  }
  
  override func configureView() {
    super.configureView()
    guard let countDataSource = countDataSource else { return }
    countLabel?.text = "\(countDataSource.count)"
    stepper?.value = Double(countDataSource.count)
    roomTitleLabel?.text = countDataSource.roomTitlePlural
  }
  
  // MARK: - Instance Properties
  @IBOutlet final internal var countLabel: UILabel?
  @IBOutlet final internal var roomTitleLabel: UILabel?
  @IBOutlet final internal var stepper: UIStepper?  
  
  // MARK: - Actions
  @IBAction final internal func stepperValueChanged(_ sender: UIStepper) {
    
  }
}
