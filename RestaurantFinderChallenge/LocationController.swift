//
//  LocationController.swift
//  RestaurantFinderChallenge
//
//  Created by Parker Donat on 3/31/16.
//  Copyright © 2016 Parker Donat. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationController: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    static let sharedInstance = LocationController()
    
    var locationHandler: ((location: CLLocation?)->())?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    //MARK: -LocationManager delegate functions
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No location")
            locationHandler?(location: nil)
            return
        }
        print(location)
        locationHandler?(location: location)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location request failed with error: \(error)")
        locationHandler?(location: nil)
    }
    
    func requestAuthorization() {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: -Location and nearby site search
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
    func addressFromLocation(location: CLLocation, completion: (city: String?)->Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if let placemarks = placemarks,
                city = placemarks.first?.subAdministrativeArea {
                completion(city: city)
            } else {
                completion(city: nil)
            }
        }
    }
    
    func searchRequest(searchString: String, location: CLLocation, searchRadius: CLLocationDistance, completion: (mapItems: [MKMapItem])->Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Restaurants"
        request.region = MKCoordinateRegionMakeWithDistance(location.coordinate, searchRadius, searchRadius)
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) -> Void in
            guard let response = response else {
                print("Search error: \(error)")
                completion(mapItems: [])
                return
            }
            completion(mapItems: response.mapItems)
        }
    }
    
    
}
