//
//  RestaurantListTableViewController.swift
//  RestaurantFinderChallenge
//
//  Created by Parker Donat on 3/31/16.
//  Copyright © 2016 Parker Donat. All rights reserved.
//

/*
 Challenge: Restaurant Finder
 
 Build an application that lists nearby restaurants based on the device's current location.
 Display the results in a table view on the initial view controller.
 Set the title for the navigation bar to the street address, city, or zip code of the user's current location.
 Hints: CLLocationManager. MKLocalSearch. CLGeocoder. MKMapView. MKDirections.
 
 Black Diamond
 Build a detail view that displays the location on a map.
 Double Black Diamond: List navigation instructions to the location.
 */

import UIKit
import CoreLocation
import MapKit

class RestaurantListTableViewController: UITableViewController {
    
    var restaurants: [MKMapItem] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationHandler()
    }
    
    func setLocationHandler() {
        LocationController.sharedInstance.locationHandler = { location in
            if let location = location {
                LocationController.sharedInstance.addressFromLocation(location, completion: { (city) in
                    if let city = city {
                        self.navigationItem.title = city
                    } else {
                        LocationController.sharedInstance.requestLocation()
                    }
                })
                self.setupRestaurantSearch(location)
            } else {
                LocationController.sharedInstance.requestLocation()
            }
        }
    }
    
    func setupRestaurantSearch(location: CLLocation) {
        LocationController.sharedInstance.searchRequest("restaurant", location: location, searchRadius: 5000) { (mapItems) in
            self.restaurants = mapItems
        }
    }
    
    @IBAction func findNearbyRestaurantsButtonTapped(sender: AnyObject) {
        LocationController.sharedInstance.requestAuthorization()
        LocationController.sharedInstance.requestLocation()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = restaurants[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapView = segue.destinationViewController as? MapViewController {
            let mapItem = restaurants[tableView.indexPathForSelectedRow!.row]
            mapView.restaurant = mapItem
        }
    }
    
}
