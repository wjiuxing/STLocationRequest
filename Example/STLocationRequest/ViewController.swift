//
//  ViewController.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 12/03/2015.
//  Copyright (c) 2015 Sven Tiigi. All rights reserved.
//

import UIKit
import CoreLocation
import STLocationRequest

class ViewController: UIViewController, CLLocationManagerDelegate, STLocationRequestControllerDelegate {
    
    /// Storyboard IBOutlet for the Request Location Button
    @IBOutlet weak var requestLocationButton: UIButton!
    
    /// Initialize CLLocationManager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Intialize the locationManager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter=kCLDistanceFilterNone
    }
    
    /// requestLocationButtonTouched Method
    @IBAction func requestLocationButtonTouched(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied {
                // Location Services are denied
                print("Location Services are denied")
            } else {
                if CLLocationManager.authorizationStatus() == .notDetermined{
                    // The user has never been asked about his location show the locationRequest Screen
                    // Just play around with the setMapViewAlphaValue and setBackgroundViewColor parameters, to match with your design of your app
                    // Also you can initialize an STLocationRequest Object and set all attributes
                    // and at the end call presentLocationRequestController
                    self.presentLocationRequestController()
                } else {
                    // The user has already allowed your app to use location services
                    self.startUpdatingLocation()
                }
            }
        } else {
            // Location Services are disabled
            print("Location Services are disabled")
        }
    }
    
    /// Initialize and present STLocationRequestController
    func presentLocationRequestController(){
        let locationRequestController = STLocationRequestController.getInstance()
        locationRequestController.titleText = "We need your location for some awesome features"
        locationRequestController.allowButtonTitle = "Alright"
        locationRequestController.notNowButtonTitle = "Not now"
        locationRequestController.mapViewAlpha = 0.9
        locationRequestController.backgroundColor = UIColor.lightGray
        locationRequestController.authorizeType = .requestWhenInUseAuthorization
        locationRequestController.delegate = self
        locationRequestController.present(onViewController: self)
    }
    
    /// STLocationRequest Delegate Methods
    func locationRequestControllerDidChange(_ event: STLocationRequestControllerEvent) {
        switch event {
        case .locationRequestAuthorized:
            print("The user accepted the use of location services")
            self.startUpdatingLocation()
            break
        case .locationRequestDenied:
            print("The user denied the use of location services")
            break
        case .notNowButtonTapped:
            print("The Not now button was tapped")
            break
        case .didPresented:
            print("STLocationRequestController did presented")
            break
        case .didDisappear:
            print("STLocationRequestController did disappear")
            break
        }
    }
    
    /// Start updating user location
    func startUpdatingLocation(){
        self.locationManager.startUpdatingLocation()
    }
    
    /// CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error. The Location couldn't be found. \(error)")
    }
    
    /// CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        print("didUpdateLocations UserLocation: \(locations.last)")
    }
    
}
