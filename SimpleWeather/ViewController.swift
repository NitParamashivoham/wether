//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Nitesh on 2018-06-28.
//  Copyright © 2018 Nitesh. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //Outlets
    @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var cloudyLabel: UILabel!
    @IBOutlet weak var qutoeMainLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var dayOfWeek: UILabel!
    
    // Constants
    
    let locationManager = CLLocationManager()
    
    
    //Variables
    var currentWeather: CurrentWeather!
    var currentLocation: CLLocation!
    var tapGesture = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.purpleEnd.cgColor, UIColor.purpleStart.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
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
            self.updateUI()
        }
        
        
        
        
        }
       else{  //User refused
        
        locationManager.requestWhenInUseAuthorization()  //  Prompting again
        locationAuthCheck() //Check
        
        }
    }
    
    // Calling Tap
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! Second
        homeView.modalTransitionStyle = .crossDissolve
        present(homeView, animated: true, completion: nil)
        
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
    }


}

