//
//  MapViewController.swift
//  Meet-Halfway
//
//  Created by Laya Indukuri on 7/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import YelpAPI

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var selectedPin:MKPlacemark? = nil
    
    
    let locationManager = CLLocationManager()
    
    var address1 : String!
    var address2 : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Address1 Pin Implementation
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = SearchHelper.storedAddress1!.placemark.coordinate
        //annotation1.title = SearchHelper.storedAddress1!.name
        annotation1.title = "Me"
        self.mapView.addAnnotation(annotation1)
        
        //Address2 Pin Implementation
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = SearchHelper.storedAddress2!.placemark.coordinate
        //annotation2.title = SearchHelper.storedAddress2?.name
        annotation2.title = "Friend"
        self.mapView.addAnnotation(annotation2)
        
        //Midpoint Pin Implementation
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = MidpointHelper.assignMidpoint()
        annotation3.title = "Midpoint!"
        self.mapView.addAnnotation(annotation3)
        
        YelpHelper.yelpAccess { businesses in
            let coordinates: [CLLocationCoordinate2D] = businesses.map { business in
                
                let ylpCoordinate = business.location.coordinate!
                print(ylpCoordinate)
                let ylpCoordinateLatitude = ylpCoordinate.latitude
                let ylpCoordinateLongitude = ylpCoordinate.longitude
                let ylp = CLLocationCoordinate2D(latitude: ylpCoordinateLatitude, longitude: ylpCoordinateLongitude)
                
                
                let yelpAnnotation = MKPointAnnotation()
                yelpAnnotation.coordinate = ylp
                self.mapView.addAnnotation(yelpAnnotation)
                print(yelpAnnotation)
                return CLLocationCoordinate2D(latitude: ylpCoordinate.latitude, longitude: ylpCoordinate.longitude)
            }
        }
        
        
        
        
        YelpHelper.yelpAccess({ (businesses: [YLPBusiness]) -> Void in
            
        })
        
    }
    
    //Changes color of pin view
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        let annotationView = MKPinAnnotationView()
//        annotationView.pinTintColor = UIColor.orangeColor()
//        print("Pin Color Set")
//        return annotationView
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("location:: (location)")
        }

    }


}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}





