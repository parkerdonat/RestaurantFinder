//
//  MapViewController.swift
//  RestaurantFinderChallenge
//
//  Created by Parker Donat on 3/31/16.
//  Copyright © 2016 Parker Donat. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: MKMapItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = restaurant {
            updateMapWithLocation()
        }
    }
    
    func updateMapWithLocation() {
        guard let restaurant = restaurant,
            location = restaurant.placemark.location else {return}
        
        mapView.setRegion(MKCoordinateRegion(center: restaurant.placemark.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = restaurant.name
        mapView.addAnnotation(annotation)
    }
    
}

