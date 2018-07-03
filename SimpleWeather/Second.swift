//
//  Second.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-29.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import UIKit
import Alamofire
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
}

class Second: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    //Outlets
    @IBOutlet weak var monthLabel: UILabel!
  
    
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var viewTap: UIView!
     

    
    //Variales
    var forecastWeathe: ForecastWeather!
    var forecastArray = [ForecastWeather]()
    var tapGesture = UITapGestureRecognizer()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gradient background
  /*      let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.purpleEnd.cgColor, UIColor.purpleStart.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
     */
        callDelegate()
       
        // Declare an observer for UIApplicationDidBecomeActive
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleTimer), name:  .UIApplicationDidBecomeActive, object: nil)
        
        // change the background each time the view is opened
        changeBackground()
        
        
        // function which is triggered when handleTap is called
       
        
        let now = Date()
        let dayyFormatter = DateFormatter()
        dayyFormatter.dateFormat = "d"
        let nameOfDay = dayyFormatter.string(from: now)
        
        dateLabel.text = "\(nameOfDay)"
        
        
        
        
        //let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        
        monthLabel.text = "\(nameOfMonth)".uppercased()
        
        // Tapp
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewTap.addGestureRecognizer(tapGesture)
        viewTap.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }
    
    // Calling Tap
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
       
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! ViewController
        homeView.modalTransitionStyle = .crossDissolve
        present(homeView, animated: true, completion: nil)

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
    
    
    // Changing backgound color
    @objc func scheduleTimer() {
        // schedule the timer
        timer = Timer(fireAt: Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 6..<21 ~= Date().hour ? 21 : 6), matchingPolicy: .nextTime)!, interval: 0, target: self, selector: #selector(changeBackground), userInfo: nil, repeats: false)
        print(timer.fireDate)
        RunLoop.main.add(timer, forMode: .commonModes)
        print("new background chenge scheduled at:", timer.fireDate.description(with: .current))
    }
    
    @objc func changeBackground(){
        // check if day or night shift
        self.view.backgroundColor =  6..<21 ~= Date().hour ? UIColor.init(patternImage: #imageLiteral(resourceName: "day")) :  UIColor.init(patternImage: #imageLiteral(resourceName: "night"))
        
        // schedule the timer
        scheduleTimer()
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
