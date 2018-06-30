//
//  CurrentWeather.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-28.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    private var _cityName: String!
    
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    /// Downloading Current Weather Data
    ///
    /// - Parameter completed: Completion Handler.
    func downloadCurrentWeather(completed: @escaping DownloadComplete){
        Alamofire.request(API_URL).responseJSON { (response) in
            //print(response)
            //print(response)
            let result = response.result
            //print(result.value)
            let json = JSON(result.value)
            self._cityName = json["name"].stringValue
            
            self._weatherType = json["weather"][0]["main"].stringValue
            let downloadedTemp = json["main"]["temp"].double
            self._currentTemp = (downloadedTemp! - 273.15).rounded(toPlaces: 0)
            completed()
        }
        
    }
    
    
    
}

    
    


