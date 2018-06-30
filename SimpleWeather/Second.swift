//
//  Second.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-29.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import UIKit
import Alamofire
class Second: UIViewController {

    
    //Outlets
    
    @IBOutlet weak var tableVIew: UITableView!
    
    
    
    //Variales
    var forecastWeathe: ForecastWeather!
    var forecastArray = [ForecastWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegate()
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadForecastWeather {
            print("Data downloaded")
        }
    }

    func callDelegate(){
        tableVIew.delegate = self
        tableVIew.dataSource = self
    }

}

extension Second: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      let   cell = tableVIew.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        cell.configureCell(forecastData: forecastArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
        
    }
    
    func  downloadForecastWeather(completed: @escaping DownloadComplete){
        Alamofire.request(Forcast_API_URL).responseJSON { (response) in
            let result = response.result
            if let dictionary = result.value as? Dictionary<String, AnyObject>{
                if let list = dictionary["list"] as? [Dictionary<String, AnyObject>]{
                    for item in list {
                        let forecast = ForecastWeather(weatherDict: item)
                        self.forecastArray.append(forecast)
                    }
                    self.forecastArray.remove(at: 0)
                    
                    self.tableVIew.reloadData()
                }
            }
            completed()
        }
        
    }
    
}
