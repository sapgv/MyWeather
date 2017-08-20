//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {
  // MARK: - Constants
  fileprivate let emptyString = ""

  // MARK: - Properties
  let hasError: Observable<Bool>
  let errorMessage: Observable<String?>

  let location: Observable<String>
  let iconText: Observable<String>
  let temperature: Observable<String>
    
  var city: City?
    
  // MARK: - Services
  fileprivate var locationService: LocationService
  fileprivate var weatherService: WeatherServiceProtocol

  // MARK: - init
  init() {
    hasError = Observable(false)
    errorMessage = Observable(nil)

    location = Observable(emptyString)
    iconText = Observable(emptyString)
    temperature = Observable(emptyString)

    // Can put Dependency Injection here
    locationService = LocationService()
    weatherService = OpenWeatherMapService()
  }

  // MARK: - public
  func startLocationService() {
    locationService.delegate = self
    if let city = city {
        
        weatherService.retrieveWeather(city.name, location: nil) { (weather, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedError = error {
                    print(unwrappedError)
                    self.update(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                self.update(unwrappedWeather)
            })
        }
        
    }
    else {
        locationService.requestLocation()
    }
  }

  // MARK: - private
  fileprivate func update(_ weather: Weather) {
      hasError.value = false
      errorMessage.value = nil

      location.value = weather.location
      iconText.value = weather.iconText
      temperature.value = weather.temperature


  }

  fileprivate func update(_ error: SWError) {
      hasError.value = true

      switch error.errorCode {
      case .urlError:
        errorMessage.value = "The weather service is not working."
      case .networkRequestFailed:
        errorMessage.value = "The network appears to be down."
      case .jsonSerializationFailed:
        errorMessage.value = "We're having trouble processing weather data."
      case .jsonParsingFailed:
        errorMessage.value = "We're having trouble parsing weather data."
      }

      location.value = emptyString
      iconText.value = emptyString
      temperature.value = emptyString
//      self.forecasts.value = []
  }
}

// MARK: LocationServiceDelegate
extension WeatherViewModel: LocationServiceDelegate {
    
  func locationDidUpdate(_ service: LocationService, location: CLLocation) {
    
    
    weatherService.retrieveWeather(nil, location: location) { (weather, error) -> Void in
        DispatchQueue.main.async(execute: {
            if let unwrappedError = error {
                print(unwrappedError)
                self.update(unwrappedError)
                return
            }
            
            guard let unwrappedWeather = weather else {
                return
            }
            self.update(unwrappedWeather)
        })
    }
    
  }
    
}
