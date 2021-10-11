import Foundation
import MapKit

class BusinessMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            
            guard let business = newValue as? Business else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            rightCalloutAccessoryView?.tintColor = business.markerTintColor
            markerTintColor = business.markerTintColor
            glyphImage = #imageLiteral(resourceName: "coffee")
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = business.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}

class BusinessView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let business = newValue as? Business else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            image = UIImage(named: "coffee")
            
        }
    }
}

