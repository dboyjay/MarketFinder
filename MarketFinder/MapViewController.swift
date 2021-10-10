//
//  ViewController.swift
//  MarketFinder
//
//  Created by HMK on 2021/10/10.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 37.550589288227584, longitude: 126.98991832744348)
        mapView.centerToLocation(initialLocation)
        
        let boundaryRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: 2_000_000,
            longitudinalMeters: 2_000_000)
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: boundaryRegion), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2_000_000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        let initialRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 15_000, longitudinalMeters: 15_000)
        
        mapView.setRegion(initialRegion, animated: true)
        
    }
    
    
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
