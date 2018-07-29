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

public final class NetworkClient {
  
  // MARK: - Instance Properties
  internal let baseURL: URL
  internal let session = URLSession.shared
  
  internal let authClient: AuthTokenProvider
  
  // MARK: - Class Constructors
  public static let shared: NetworkClient = {
    let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: file)!
    let urlString = dictionary["service_url"] as! String
    let url = URL(string: urlString)!
    return NetworkClient(authClient: AuthClient.shared, baseURL: url)
  }()
  
  // MARK: - Object Lifecycle
  private init(authClient: AuthTokenProvider, baseURL: URL) {
    self.authClient = authClient
    self.baseURL = baseURL
  }
  
  public func getProducts(forType type: Product.ProductType,
                          success _success: @escaping ([Product]) -> Void,
                          failure _failure: @escaping (NetworkError) -> Void) {
    let success: ([Product]) -> Void = { products in
      DispatchQueue.main.async { _success(products) }
    }
    let failure: (NetworkError) -> Void = { error in
      DispatchQueue.main.async { _failure(error) }
    }
    let url = baseURL.appendingPathComponent("products/\(type.rawValue)")
    
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
      
      guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode.isSuccessHTTPCode,
      let data = data,
      let jsonObject = try? JSONSerialization.jsonObject(with: data),
        let json = jsonObject as? [[String: Any]] else {
          if let error = error {
            failure(NetworkError(error: error))
          } else {
            failure(NetworkError(response: response))
          }
          return
      }
      
      let products = Product.array(jsonArray: json)
      success(products)
    })
    
    task.resume()
  }
  
  // MARK: - Quotes
  public func sendQuoteRequest(for product: Product,
                               success _success: @escaping (QuoteRequest) -> Void,
                               failure _failure: @escaping (NetworkError) -> Void){
    
    let success: (QuoteRequest) -> Void = { quoteRequest in
      DispatchQueue.main.async { _success(quoteRequest) }
    }
    let failure: (NetworkError) -> Void = { error in
      DispatchQueue.main.async { _failure(error) }
    }
    
    authClient.requestAuthToken(self, success: { [weak self] (token, _) in
      
      guard let strongSelf = self else { return }
      let url = strongSelf.baseURL.appendingPathComponent("quotes/product/\(product.identifier!)")
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      token.setAuthenticationHeaders(on: &request)
      
      let task = strongSelf.session.dataTask(with: request) { (data, response, error) in
        guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode.isSuccessHTTPCode,
          let data = data,
          let jsonObject = try? JSONSerialization.jsonObject(with: data),
          let dictionary = jsonObject as? [AnyHashable: Any],
          let quoteRequest = QuoteRequest(dictionary: dictionary) else {
            if let error = error {
              let networkError = NetworkError(error: error)
              print("Send quote failed: \(networkError)")
              failure(networkError)
            } else {
              let networkError = NetworkError(response: response)
              guard !networkError.isAuthError else {
                print("Send quote failed: not authenticated... invalidating token and retrying...")
                strongSelf.authClient.invalidateAuthToken()
                strongSelf.sendQuoteRequest(for: product, success: success, failure: failure)
                return
              }
              print("Send quote failed: \(networkError)")
              failure(networkError)
            }
            return
        }
        success(quoteRequest)
      }
      task.resume()
      
      }, userCancelled: {
        print("Send quote failed: user cancelled")
        failure(.userCancelled)
    })
  }
  
  public func getQuotes(success _success: @escaping ([QuoteRequest]) -> Void,
                        failure _failure: @escaping (NetworkError) -> Void) {
    
    let success: ([QuoteRequest]) -> Void = { quoteRequests in
      DispatchQueue.main.async { _success(quoteRequests) }
    }
    let failure: (NetworkError) -> Void = { error in
      DispatchQueue.main.async { _failure(error) }
    }
    
    authClient.requestAuthToken(self, success: { [weak self] (token, _) in
      
      guard let strongSelf = self else { return }
      let url = strongSelf.baseURL.appendingPathComponent("quotes")
      var request = URLRequest(url: url)
      token.setAuthenticationHeaders(on: &request)
      
      let task = strongSelf.session.dataTask(with: request) { (data, response, error) in
        
        guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode.isSuccessHTTPCode,
          let data = data,
          let jsonObject = try? JSONSerialization.jsonObject(with: data),
          let jsonArray = jsonObject as? [[AnyHashable: Any]] else {
            if let error = error {
              let networkError = NetworkError(error: error)
              print("Send quote failed: \(networkError)")
              failure(networkError)
            } else {
              let networkError = NetworkError(response: response)
              guard !networkError.isAuthError else {
                print("Get quotes failed: not authenticated... invalidating token and retrying...")
                strongSelf.authClient.invalidateAuthToken()
                strongSelf.getQuotes(success: success, failure: failure)
                return
              }
              guard networkError != .notFound else {
                success([])
                return
              }
              print("Get quotes failed: \(networkError)")
              failure(networkError)
            }
            return
        }
        let array = QuoteRequest.array(from: jsonArray)
        success(array)
      }
      task.resume()
      
      }, userCancelled: {
        print("Send quote failed: user cancelled")
        failure(.userCancelled)
    })
  }
  
  // MARK: - HomeInfo
  
  public func getHomeInfo(success _success: @escaping (HomeInfo?) -> Void,
                          failure _failure: @escaping (NetworkError) -> Void){
    
    let success: (HomeInfo?) -> Void = { homeInfo in
      DispatchQueue.main.async { _success(homeInfo) }
    }
    let failure: (NetworkError) -> Void = { error in
      DispatchQueue.main.async { _failure(error) }
    }
    
    authClient.requestAuthToken(self, success: { [weak self] (token, _) in
      
      guard let strongSelf = self else { return }
      let url = strongSelf.baseURL.appendingPathComponent("users/homeInfo")
      var request = URLRequest(url: url)
      token.setAuthenticationHeaders(on: &request)
      
      let task = strongSelf.session.dataTask(with: request) { (data, response, error) in
        guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode.isSuccessHTTPCode else {
            if let error = error {
              let networkError = NetworkError(error: error)
              print("Send HomeInfo failed: \(networkError)")
              failure(networkError)
            } else {
              let networkError = NetworkError(response: response)
              guard !networkError.isAuthError else {
                print("Get HomeInfo failed: not authenticated... invalidating token and retrying...")
                strongSelf.authClient.invalidateAuthToken()
                
                strongSelf.getHomeInfo(success: success, failure: failure)
                return
              }
              guard networkError != .notFound else {
                print("Get HomeInfo Succeeded but HomeInfo Not Found")
                success(nil)
                return
              }
              
              print("Get HomeInfo failed: \(networkError)")
              failure(networkError)
            }
            return
        }
        guard let data = data,
          let homeInfo = HomeInfo(jsonData: data) else {
            success(nil)
            return
        }
        success(homeInfo)
      }
      task.resume()
      
      }, userCancelled: { _ in
        print("Get HomeInfo failed: user cancelled")
        failure(.userCancelled)
    })
  }
  
  public func sendHomeInfo(_ sendHomeInfo: HomeInfo,
                           success _success: @escaping (HomeInfo) -> Void,
                           failure _failure: @escaping (NetworkError) -> Void) {
    
    let success: (HomeInfo) -> Void = { homeInfo in
      DispatchQueue.main.async { _success(homeInfo) }
    }
    let failure: (NetworkError) -> Void = { error in
      DispatchQueue.main.async { _failure(error) }
    }
    
    authClient.requestAuthToken(self, success: { [weak self] (token, _) in
      
      guard let strongSelf = self else { return }
      let url = strongSelf.baseURL.appendingPathComponent("users/homeInfo")
      var request = URLRequest(url: url)
      request.httpMethod = "PUT"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = sendHomeInfo.encodeJSON()
      token.setAuthenticationHeaders(on: &request)
      
      let task = strongSelf.session.dataTask(with: request) { (data, response, error) in
        guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode.isSuccessHTTPCode,
          let jsonData = data,
          let receivedHomeInfo = HomeInfo(jsonData: jsonData) else {
            if let error = error {
              let networkError = NetworkError(error: error)
              print("Send HomeInfo failed: \(networkError)")
              failure(networkError)
            } else {
              let networkError = NetworkError(response: response)
              guard !networkError.isAuthError else {
                print("Send HomeInfo failed: not authenticated... invalidating token and retrying...")
                strongSelf.authClient.invalidateAuthToken()
                strongSelf.sendHomeInfo(sendHomeInfo, success: success, failure: failure)
                return
              }
              print("Send HomeInfo failed: \(networkError)")
              failure(networkError)
            }
            return
        }
        success(receivedHomeInfo)
      }
      task.resume()
      
      }, userCancelled: { _ in
        print("Send HomeInfo failed: user cancelled")
        failure(.userCancelled)
    })
  }
}
