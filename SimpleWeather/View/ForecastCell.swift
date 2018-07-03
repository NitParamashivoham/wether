//
//  ForecastCell.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-29.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

   
    
    //Outlets
    @IBOutlet weak var forecastDay: UILabel!
    @IBOutlet weak var forecastTemp: UILabel! //Min temp
    @IBOutlet weak var forecastMax: UILabel!  //Max temp
   
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(forecastData: ForecastWeather)   {
        self.forecastDay.text = "\(forecastData.date)"
        self.forecastTemp.text = "\(Int(forecastData.temp))↓"
        self.forecastMax.text = "\(Int(forecastData.max))↑"
        
        
    }
}
