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

public class HomeProductsViewController: UIViewController {
  
  // MARK: - Instance Properties
  internal var imageTasks: [IndexPath: URLSessionDataTask] = [:]
  internal var products: [Product] = []
  internal let session = URLSession.shared
  
  
  // MARK: - Outlets
  @IBOutlet internal var collectionView: UICollectionView! {
    didSet {
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(loadProducts), for: .valueChanged)
      collectionView.refreshControl = refreshControl
      
      let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      collectionView.collectionViewLayout = CollectionViewCenterFlowLayout(layout: layout)
    }
  }
  
  internal func loadProducts() {
    collectionView.refreshControl?.beginRefreshing()
    let url = URL(string: "https://rwcleanbackend.herokuapp.com/products/home")!
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Product download failed: \(error)")
        return
      }
      guard let data = data else {
        print("Product download failed: data is nil!")
        return
      }
      let jsonArray: [[String: Any]]
      do {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
          print("Product download failed: invalid JSON")
          return
        }
        jsonArray = jsonObject
        
      } catch {
        print("Product download failed: invalid JSON")
        return
      }
      let products = Product.array(jsonArray: jsonArray)
      DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.products = products
        strongSelf.collectionView.refreshControl?.endRefreshing()
        strongSelf.collectionView.reloadData()
      }
    })
    task.resume()
  }
    
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    loadProducts()
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    guard let selectedItem = collectionView.indexPathsForSelectedItems else { return }
    selectedItem.forEach { collectionView.deselectItem(at: $0, animated: false) }
  }
  
  // MARK: - Segue
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let viewController = segue.destination as? ProductDetailsViewController else { return }
    let indexPath = collectionView.indexPathsForSelectedItems!.first!
    let product = products[indexPath.row]
    viewController.product = product
  }
}

// MARK: - UICollectionViewDataSource
extension HomeProductsViewController: UICollectionViewDataSource {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellIdentifier = "ProductCell"
    
    let product = products[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                  for: indexPath) as! ProductCollectionViewCell
    cell.label.text = product.title
    
    imageTasks[indexPath]?.cancel()
    
    if let url = product.imageURL {
      let task = session.dataTask(with: url, completionHandler: { [weak cell]
        (data, response, error) in
        
        if let error = error {
          print("Image download failed: \(error)")
          return
        }
        
        guard let cell = cell,
          let data = data,
          let image = UIImage(data: data) else {
            print("Image download failed: invalid image data!")
            return
        }
        DispatchQueue.main.async { [weak cell] in
          guard let cell = cell else { return }
          cell.imageView.image = image
        }
      })
      imageTasks[indexPath] = task
      task.resume()
    }
    return cell
  }
}
