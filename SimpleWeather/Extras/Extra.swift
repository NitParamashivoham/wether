//
//  Extra.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-28.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import Foundation

let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latidue!)&lon=\(Location.sharedInstance.longitude!)&appid=833b83abc4393c5e8d18f85acb2457ce"

let Forcast_API_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latidue!)&lon=\(Location.sharedInstance.longitude!)&cnt=8&appid=7c609f73c5df2dff2f32e3e3cc33cd23"



typealias DownloadComplete = () -> ()

