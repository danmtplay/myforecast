//
//  ViewController.swift
//  myforecast
//
//  Created by Dan on 26/05/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ForecastIO

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var gifScreenView: UIImageView!
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let locationManager = CLLocationManager()
    var myLocation : CLLocationCoordinate2D!
    var isGetLocation = false
    var forecastCount = 0
    var forecastItems : [DataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifScreenView.image = UIImage.gifWithName("cloud")
        gifScreenView.hidden = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "forecastSegue") {
            let des = segue.destinationViewController as! ForecastListVC
            des.forecastCount = self.forecastCount
            des.forecastItems = self.forecastItems
            gifScreenView.hidden = true
        }
    }
    
    func getTodayForecastJSON(lat : Double, long : Double) {
        let forecastIOClient = APIClient(apiKey: appDel.DARKSKYAPIKEY)
        forecastIOClient.units = .Auto
        forecastIOClient.getForecast(latitude: lat, longitude: long) {
            (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                print("current forecast : \(currentForecast)")
                self.forecastCount = (currentForecast.hourly?.data?.count)!
                self.forecastItems = (currentForecast.hourly?.data)!
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("forecastSegue", sender: self)
                })
            } else if let error = error {
                print("fail : \(error.description)")
            }
        }
    }
    
    func getToday() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        let sDate = dateFormatter.stringFromDate(currentDate)
        return sDate
    }
    
    // MARK: - Location Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        myLocation = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        print("my location: \(String(myLocation.latitude),String(myLocation.longitude))")
        if isGetLocation == false {
            isGetLocation = true
            self.performSegueWithIdentifier("forecastSegue", sender: self)
            getTodayForecastJSON(myLocation.latitude, long: myLocation.longitude)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: \(error.localizedDescription)")
    }

}

