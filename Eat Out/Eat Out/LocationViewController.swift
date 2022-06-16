/**
* LocationViewController: This is the 2nd screen which shows the current location of user.. If user has disabled location services, an alert is shown asking user to enable location services
*
* @author  Sai Swetha Chiguruvada and Vy Ngo
*/

import CoreLocation
import Foundation
import UIKit
import MapKit

var currentLatitude: String = ""
var currentLongitude: String = ""

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet var locationView: MKMapView!
    @IBOutlet weak var getRes: UIButton!
    @IBAction func randomizeButtonPressed(sender: AnyObject) {
        self.performSegue(withIdentifier: "ResultViewSegue", sender: self)
    }
    @IBOutlet weak var preferenceButton: UIBarButtonItem!
    @IBAction func prefAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PreferenceSegue", sender: self)
    }
    
    @IBAction func savedAction(_ sender: Any) {
        self.performSegue(withIdentifier: "SavedRestaurantsSegue", sender: self)
    }
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print ("Err GPS")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Before running the application, choose a simulator: In features -> Locations option either choose
    // custom location & enter values, or choose Apple
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let pin = MKPointAnnotation()
        
        locationView.setRegion(region, animated: true)
        
        pin.coordinate = coordinate
        
        locationView.addAnnotation(pin)
        
        currentLatitude = String(format: "%f", location.coordinate.latitude)
        currentLongitude = String(format: "%f", location.coordinate.longitude)
    }
    
}



