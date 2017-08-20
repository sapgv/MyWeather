//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation

class Observable<T> {
  
typealias Observer = (T) -> Void
  var observer: Observer?

  func observe(_ observer: Observer?) {
    self.observer = observer
    observer?(value)
  }

  var value: T {
    didSet {
      observer?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }
}
