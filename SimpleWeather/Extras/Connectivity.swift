//
//  Connectivity.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-30.
//  Copyright © 2018 Nitesh. All rights reserved.
//
import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
