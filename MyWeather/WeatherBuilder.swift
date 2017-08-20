//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation

struct WeatherBuilder {
  var location: String?
  var iconText: String?
  var temperature: String?

//  var forecasts: [Forecast]?

  func build() -> Weather {
    return Weather(location: location!,
                      iconText: iconText!,
                   temperature: temperature!)
  }
}
