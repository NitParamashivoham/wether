//
//  DailyQuotes.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-07-03.
//  Copyright © 2018 Nitesh. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON


class DailyQuotes {
    
    
    private var _quotes: String!
    private var _author: String!
    //_________________________________
  
    
    
    var quotes: String
    {
        if _quotes == nil
        {
            _quotes = ""
        }
        return _quotes
    }
    
    var author: String
    {
        if _author == nil
        {
            _author = ""
        }
        return _author
    }
    
    //_________________________________
    
    func downloadQuotes(completed: @escaping DownloadComplete){
        
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(QuotesDaily).responseJSON { (response) in
                //print(response)
                //print(response)
                let result = response.result
                print(result.value)
                let json = JSON(result.value!)
             //   self._cityName = json["name"].stringValue
                
               // self._weatherType = json["contents"][0]["quotes"].stringValue
                self._quotes = json["contents"]["quotes"][0]["quote"].stringValue
                self._author = json["contents"]["quotes"][0]["author"].stringValue

                
                completed()
            }
            
        }}
    
    
    
    
    
}


