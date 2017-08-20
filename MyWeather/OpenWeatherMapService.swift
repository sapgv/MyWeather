//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON
import Alamofire
import CoreData

struct OpenWeatherMapService: WeatherServiceProtocol {

    //  fileprivate let urlPath = "http://api.openweathermap.org/data/2.5/forecast"

   fileprivate let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?"
   fileprivate let APIKEY = "1aae2e140a7ba571e59f72a806506454"
    
    func retrieveWeather( _ cityName: String?, location: CLLocation?, completionHandler: @escaping WeatherCompletionHandler) {
        
        var parameters: Parameters = ["APPID": APIKEY,
                                      "units": "metric",
                                      ]

        if let name = cityName {
            parameters["q"] = name
        }
        else {
            parameters["lat"] = location?.coordinate.latitude
            parameters["lon"] = location?.coordinate.longitude
        }
        
        Alamofire.request(weatherUrl, parameters: parameters).responseJSON { response in
            
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                
                // Get temperature, location and icon and check parsing error
                guard let tempDegrees = json["main"]["temp"].double,
                    let weatherCondition = json["weather"][0]["id"].int,
                    let location = json["name"].string,
                    let iconString = json["weather"][0]["icon"].string else {
                        let error = SWError(errorCode: .jsonParsingFailed)
                        completionHandler(nil, error)
                        return
                }
                
                var weatherBuilder = WeatherBuilder()
                weatherBuilder.temperature = String(tempDegrees)
                weatherBuilder.location = location
                
                let weatherIcon = WeatherIcon(condition: weatherCondition, iconString: iconString)
                weatherBuilder.iconText = weatherIcon.iconText
                
                completionHandler(weatherBuilder.build(), nil)
                
                //Core data
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.managedObjectContext
                
                let listData = NSEntityDescription.insertNewObject(
                    forEntityName: "List",
                    into: managedContext) as! List
                listData.name = location
                listData.temp = String(tempDegrees)
                listData.date = NSDate()
            
                
                do {
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Save error: \(error), description: \(error.userInfo)")
                }
                
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
//    func retrieveWeatherInfoByCityName(_ cityName: String, completionHandler: @escaping WeatherCompletionHandler) {
//        
//        let cityName = cityName
//        let parameters: Parameters = [
//            "q": cityName,
//            "units": "metric",
//            "APPID": APIKEY,
//            ]
//        
//        Alamofire.request(weatherUrl, parameters: parameters).responseJSON { response in
//            
//            
//            switch response.result {
//            case .success(let value):
//                
//                let json = JSON(value)
//                
//                
//                // Get temperature, location and icon and check parsing error
//                guard let tempDegrees = json["main"]["temp"].double,
//                    let weatherCondition = json["weather"][0]["id"].int,
//                    let iconString = json["weather"][0]["icon"].string else {
//                        let error = SWError(errorCode: .jsonParsingFailed)
//                        completionHandler(nil, error)
//                        return
//                }
//                
//                var weatherBuilder = WeatherBuilder()
//                weatherBuilder.temperature = String(tempDegrees)
//                weatherBuilder.location = cityName
//                
//                let weatherIcon = WeatherIcon(condition: weatherCondition, iconString: iconString)
//                weatherBuilder.iconText = weatherIcon.iconText
//                
//                completionHandler(weatherBuilder.build(), nil)
//                
//                
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
//        
//    }

//  func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler) {
//    
//    let cityName = "Paris"
//    let parameters: Parameters = [
//        "q": cityName,
//        "units": "metric",
//        "APPID": APIKEY,
//        ]
//    
//    Alamofire.request(weatherUrl, parameters: parameters).responseJSON { response in
//        
//        
//        switch response.result {
//        case .success(let value):
//            
//            let json = JSON(value)
//            
//            
//            // Get temperature, location and icon and check parsing error
//            guard let tempDegrees = json["main"]["temp"].double,
//                let weatherCondition = json["weather"][0]["id"].int,
//                let iconString = json["weather"][0]["icon"].string else {
//                    let error = SWError(errorCode: .jsonParsingFailed)
//                    completionHandler(nil, error)
//                    return
//            }
//            
//            var weatherBuilder = WeatherBuilder()
//            weatherBuilder.temperature = String(tempDegrees)
//            weatherBuilder.location = cityName
//            
//            let weatherIcon = WeatherIcon(condition: weatherCondition, iconString: iconString)
//            weatherBuilder.iconText = weatherIcon.iconText
//            
//            completionHandler(weatherBuilder.build(), nil)
//            
//            
//
//            
//            
//        case .failure(let error):
//            print(error)
//        }
//        
//    }
    
}
    

