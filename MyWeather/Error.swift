//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation

struct SWError {
  enum Code: Int {
    case urlError                 = -6000
    case networkRequestFailed     = -6001
    case jsonSerializationFailed  = -6002
    case jsonParsingFailed        = -6003
  }

  let errorCode: Code
}
