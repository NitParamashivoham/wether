//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-28.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GhostTypewriter
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //Outlets
   
    @IBAction func infoButton(_ sender: UIButton) {
        let gestureTap = UIImpactFeedbackGenerator(style: .medium)
        gestureTap.impactOccurred()
        
    }
    @IBAction func shareButton(_ sender: UIButton) {
        let gestureTap1 = UIImpactFeedbackGenerator(style: .medium)
        gestureTap1.impactOccurred()
        
    }
    @IBAction func settingsButton(_ sender: UIButton) {
        let gestureTap2 = UIImpactFeedbackGenerator(style: .medium)
        gestureTap2.impactOccurred()
        
        
    }
    @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var cloudyLabel: UILabel!
    @IBOutlet weak var qutoeMainLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var quoteLabel: TypewriterLabel!
    @IBOutlet weak var weatherLabel: TypewriterLabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var dayOfWeek: UILabel!
   
   
    // Constants
    
    let locationManager = CLLocationManager()
    
    
    //Variables
    var currentWeather: CurrentWeather!
    var dailyQuotes: DailyQuotes!
    var currentLocation: CLLocation!
    var tapGesture = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteLabel.typingTimeInterval = 0.1
        //Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.purpleEnd.cgColor, UIColor.purpleStart.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
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
        
        
        //Download quotes
        
       
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        applyEffect()
        setupLocation()
        callDelegate()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewTap.addGestureRecognizer(tapGesture)
        viewTap.isUserInteractionEnabled = true

        
        currentWeather = CurrentWeather()
        dailyQuotes = DailyQuotes()
        dailyQuotes.downloadQuotes {
            self.updateQuotesUI()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let str = dateFormatter.string(from: Date())
        dayOfWeek.text = "\(str)".uppercased()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthCheck()
    }

    
    // Location Manager
    func callDelegate()
    {
        locationManager.delegate = self
        
    }
    
    func setupLocation()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        
        locationManager.requestWhenInUseAuthorization()   // Take permission from user
        locationManager.startMonitoringSignificantLocationChanges()
        
        
    }
    
    func locationAuthCheck() {
        
       if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
       {
        //Get location from the device
        
        currentLocation = locationManager.location
        // Pass the coordinate to our API
        Location.sharedInstance.latidue = currentLocation.coordinate.latitude
        Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        
      
        
        
        
        
        // Dwload API data
        currentWeather.downloadCurrentWeather {
            
            
            //Update UI after downloading
            self.updateUI()       }
        
        
        
        
        }
       else{  //User refused
        
        locationManager.requestWhenInUseAuthorization()  //  Prompting again
        locationAuthCheck() //Check
        
        }
    }
    
    // Calling Tap
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! Second
        homeView.modalTransitionStyle = .crossDissolve
        present(homeView, animated: true, completion: nil)
        generator.impactOccurred()
        
    }
    
    // Parallax
    
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
    
    
    func updateUI(){
        
        locationLabel.text = currentWeather.cityName
        cloudyLabel.text = currentWeather.weatherType.uppercased()
       
        weatherLabel.text = "\(Int(currentWeather.currentTemp))"
         weatherLabel.startTypewritingAnimation(completion: nil)
    }


   func  updateQuotesUI(){
   quoteLabel.text = dailyQuotes.quotes
    quoteLabel.startTypewritingAnimation(completion: nil)
    
    authorLabel.text = dailyQuotes.author
    }
    
    @IBAction func shareB(_ sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: [ self.quoteLabel.text, self.authorLabel.text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion:  nil)
        
    }
    
    //share
    
    
    
}




