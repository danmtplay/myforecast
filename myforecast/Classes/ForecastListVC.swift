//
//  ForecastListVC.swift
//  myforecast
//
//  Created by Dan on 26/05/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import ForecastIO

class ForecastListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var forecastListView: UITableView!
    @IBOutlet weak var backImageView: UIImageView!

    var myLatitude : Double!
    var myLongitude : Double!
    var forecastCount = 0
    var forecastItems : [DataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backImageView.image = UIImage.gifWithName("cloud")
        forecastListView.delegate = self
        forecastListView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("forecastCell", forIndexPath: indexPath) as! ForecastListTVCell
        if let icon : Icon = forecastItems[indexPath.row].icon {
            cell.iconImageView.image = UIImage(named: icon.rawValue)
        }
        if let time : String = forecastItems[indexPath.row].time.description {
            cell.hourLabel.text = time
        }
        if let temp : Float = forecastItems[indexPath.row].temperature {
            cell.temperatureLabel.text = "Temperature : \(String(Int(round(temp))))°"
        }
        if let summary : String = forecastItems[indexPath.row].summary {
            cell.summaryLabel.text = summary
        }
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
