//
//  ForecastWeather.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-29.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import Foundation
class ForecastWeather {
    
    private var _date: String!
    private var _temp: Double!
    private var _max: Double!

    
    
    var date: String{
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    
    
    var temp   : Double{
        if _temp == nil{
            _temp = 0.0
        }
        return _temp
    }
  
    var max   : Double{
        if _max == nil{
            _max = 0.0
        }
        return _max
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
       
        
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject>
        {
            
            
            if let dayTemp = temp["min"] as? Double{
                let rawValue = (dayTemp - 273.15).rounded(toPlaces: 0)
                self._temp = rawValue
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let rawDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self._date = "\(rawDate.dayOfTheWeek())"
        }
        
        if let tempMax = weatherDict["temp"] as? Dictionary<String, AnyObject>
        {
            if let maxTemp = tempMax["max"] as? Double{
                let rawValue = (maxTemp - 273.15).rounded(toPlaces: 0)
                self._max = rawValue
            }
        }
        
        

        
        
    
        

        
    }
}
