import Foundation
import MapKit

class Business: NSObject, MKAnnotation {
    let id: Int?
    let name: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    var title: String? {
        return name
    }
    var locationName: String? {
        return name
    }
    var subtitle: String? {
      return address
    }
    
    var markerTintColor: UIColor = .systemPink
    
    init(id: Int, name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }
    
    
}
