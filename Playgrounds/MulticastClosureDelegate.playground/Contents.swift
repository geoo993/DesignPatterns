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
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import Foundation

// MARK: - MulticastClosureDelegate
public class MulticastClosureDelegate<Success, Failure> {
  
  // MARK: - Callback
  class Callback {
    let queue: DispatchQueue
    let success: Success
    let failure: Failure
    init(queue: DispatchQueue, success: Success, failure: Failure) {
      self.queue = queue
      self.success = success
      self.failure = failure
    }
  }
  
  // MARK: - Instance Properties
  internal var mapTable = SynchronizedValue(
    NSMapTable<AnyObject, NSMutableArray>.weakToStrongObjects()
  )
  
  public var count: Int {
    return getCallbacks(removeAfter: false).count
  }
  
  // MARK: - Instance Methods
  public func addClosurePair(for objectKey: AnyObject,
                             queue: DispatchQueue = .main,
                             success: Success,
                             failure: Failure) {
    
    mapTable.set { mapTable in
      let callBack = Callback(queue: queue, success: success, failure: failure)
      let array = mapTable.object(forKey: objectKey) ?? NSMutableArray()
      array.add(callBack)
      mapTable.setObject(array, forKey: objectKey)
    }
  }
  
  public func getSuccessTuples(removeAfter: Bool = true) -> [(Success, DispatchQueue)] {
    return getCallbacks(removeAfter: removeAfter).map {
      return ($0.success, $0.queue)
    }
  }
  
  public func getFailureTuples(removeAfter: Bool = true) -> [(Failure, DispatchQueue)] {
    return getCallbacks(removeAfter: removeAfter).map {
      return ($0.failure, $0.queue)
    }
  }
  
  fileprivate func getCallbacks(removeAfter: Bool = true) -> [Callback] {
    
    var callBacks: [Callback]!
    mapTable.set { mapTable in
      let objects = mapTable.keyEnumerator().allObjects as [AnyObject]
      callBacks = objects.reduce([]) { (combinedArray, objectKey) in
        let array = mapTable.object(forKey: objectKey)! as! [Callback]
        return combinedArray + array
      }
      guard removeAfter else { return }
      objects.forEach { mapTable.removeObject(forKey: $0) }
    }
    return callBacks
  }
}

// MARK: - Testing
typealias Success = () -> Void
typealias Failure = () -> Void

let multicastDelegate = MulticastClosureDelegate<Success, Failure>()
let delegate = NSObject()

multicastDelegate.addClosurePair(for: delegate, success: {
  print("Success")
}, failure: {
  print("Failure")
})

let callback = multicastDelegate.getCallbacks(removeAfter: false).first!
let success = callback.success
success()

let (successClosure, successQueue) = multicastDelegate.getSuccessTuples(removeAfter: false).first!
successClosure()

let (failureClosure, failureQueue) = multicastDelegate.getFailureTuples(removeAfter: false).first!
failureClosure()

print(multicastDelegate.count)


// MARK: - Multithreading
print("-- Multithreading --")
multicastDelegate.mapTable.unsafeValue.removeAllObjects()

let count = 3
for _ in 0 ..< 3 {
  DispatchQueue.global(qos: .background).async {
    multicastDelegate.addClosurePair(for: delegate, success: {
      
    }, failure: {
      
    })
    print("count: \(multicastDelegate.count)")
  }
}
