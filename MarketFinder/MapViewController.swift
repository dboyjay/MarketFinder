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
    
    private var businesses: [Business] = []
    
    
    let initialLocation = CLLocation(latitude: 37.51898253315565, longitude: 126.97548306876546)
    let radius: Int = 500
    
    let api = Api()
    let itemKey = "item"
    let dictionaryKeys = Set<String>(["bizesId","bizesNm", "rdnmAdr", "lon", "lat"])
    
    // a few variables to hold the results as we parse the XML

    var results: [[String: String]]?       // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue: String?                // the cu

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let boundaryRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: 2_000_000,
            longitudinalMeters: 2_000_000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: boundaryRegion), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2_000_000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        let initialRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 15_000, longitudinalMeters: 15_000)
        mapView.setRegion(initialRegion, animated: true)
        
        mapView.register(BusinessMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadData()

    }
    
    func loadData() {
        //Fetch data with API and parse.
        if let url = api.getUrl(at: initialLocation.coordinate, ofRadius: radius) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }

                let parser = XMLParser(data: data)
                parser.delegate = self
                if parser.parse() {
                    print(self.results ?? "No results")
                    
                    for result in self.results ?? [] {
                        let id: Int = Int(result["bizesId"] ?? "no data") ?? 0
                        let name: String = result["bizesNm"] ?? "no data"
                        let address: String = result["rdnmAdr"] ?? "no data"
                        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                            latitude: Double(result["lat"] ?? "no data") ?? 0,
                            longitude: Double(result["lon"] ?? "no data") ?? 0
                        )
                        let business = Business(id: id, name: name, address: address, coordinate: coordinate)
                        self.businesses.append(business)
                    }
                    self.mapView.addAnnotations(self.businesses)
                    print(self.businesses.count)
                }
            }
            task.resume()
        }
    }
    
    
    
    
}

//MARK: - MKMapView extension
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}

//MARK: - XMLParserDelegate
extension MapViewController: XMLParserDelegate {
    // initialize results structure

    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }

    // start element
    //
    // - If we're starting a "record" create the dictionary that will hold the results
    // - If we're starting one of our dictionary keys, initialize `currentValue` (otherwise leave `nil`)

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == itemKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }

    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }

    // end element
    //
    // - If we're at the end of the whole dictionary, then save that dictionary in our array
    // - If we're at the end of an element that belongs in the dictionary, then save that value in the dictionary

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == itemKey {
            results!.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = nil
        }
    }

    // Just in case, if there's an error, report it. (We don't want to fly blind here.)

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)

        currentValue = nil
        currentDictionary = nil
        results = nil
    }

}


extension MapViewController: MKMapViewDelegate {
//  // 1
//  func mapView(
//    _ mapView: MKMapView,
//    viewFor annotation: MKAnnotation
//  ) -> MKAnnotationView? {
//    // 2
//    guard let annotation = annotation as? Business else {
//      return nil
//    }
//    // 3
//    let identifier = "business"
//    var view: MKMarkerAnnotationView
//    // 4
//    if let dequeuedView = mapView.dequeueReusableAnnotationView(
//      withIdentifier: identifier) as? MKMarkerAnnotationView {
//      dequeuedView.annotation = annotation
//      view = dequeuedView
//    } else {
//      // 5
//      view = MKMarkerAnnotationView(
//        annotation: annotation,
//        reuseIdentifier: identifier)
//      view.canShowCallout = true
//      view.calloutOffset = CGPoint(x: -5, y: 5)
//      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//    }
//    
//    return view
//  }
    
    
}

