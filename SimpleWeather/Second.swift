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
  
    @IBOutlet weak var background: UIImageView!
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
       
       
        
        
        // function which is triggered when handleTap is called
       
        
        let now = Date()
        let dayyFormatter = DateFormatter()
        dayyFormatter.dateFormat = "d"
        let nameOfDay = dayyFormatter.string(from: now)
        
        dateLabel.text = "\(nameOfDay)"
        
        
        
        let remoteImageURL = URL(string: "https://source.unsplash.com/daily?weather")!
        
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    self.background.image = UIImage(data: data)
                    
                }
            }
        }
        //let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        
        monthLabel.text = "\(nameOfMonth)".uppercased()
        applyEffect()
        
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
        
       // MARK - Tatpic feedback
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
        
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! ViewController
        homeView.modalTransitionStyle = .crossDissolve
        present(homeView, animated: true, completion: nil)
        generator.impactOccurred()

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
    
    
   
    
    func applyEffect(){
        
        slideEffect(view: background, intensity: 45)
        
        
    }
    
    func slideEffect( view: UIView, intensity: Double)
    {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        
        horizontal.minimumRelativeValue =  -intensity
        horizontal.maximumRelativeValue = intensity
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -intensity
        vertical.maximumRelativeValue = intensity
        
        //attaching both axis
        let movement = UIMotionEffectGroup()
        movement.motionEffects = [horizontal, vertical]
        view.addMotionEffect(movement)
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
