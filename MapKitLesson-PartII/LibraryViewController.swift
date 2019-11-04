import UIKit
import MapKit
import CoreLocation

class LibraryViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var locationEntry: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    let initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417)
    let searchRadius: CLLocationDistance = 2000
    
    private var libraries = [LibraryWrapper]() {
        didSet {
            mapView.addAnnotations(libraries.filter{ $0.hasValidCoordinates})
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        locationEntry.delegate = self
        mapView.userTrackingMode = .follow
        locationAuthorization()
        loadData()
       
    }
    
    func loadData() {
        libraries = LibraryWrapper.getLibraries(from: GetLocation.getData(name: "BklynLibraryInfo", type: "json"))
    }
    
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            locationManager.requestWhenInUseAuthorization()
            
        }
    }


}

extension LibraryViewController: CLLocationManagerDelegate {
    
}

extension LibraryViewController: MKMapViewDelegate {
    
}

extension LibraryViewController: UISearchBarDelegate {
    
}
