//
//  Extensions.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-28.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import Foundation

extension Double {
    //Round the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
