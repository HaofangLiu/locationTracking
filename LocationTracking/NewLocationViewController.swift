//
//  NewLocationViewController.swift
//  Ass1
//
//  Created by haofang Liu on 26/8/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit
import MapKit

//protocol NewLocationDelegate {
//    func locationAnnotationAdded(annotation: LocationAnnotation)
//}

class NewLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var longitudeTextField: UITextField!
    
    //var delegate: NewLocationDelegate?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        // Do any additional setup after loading the view.
        // Get the database controller once from the App Delegate
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        currentLocation = location.coordinate
    }
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        if let currentLocation = currentLocation {
            latitudeTextField.text = "\(currentLocation.latitude)"
            longitudeTextField.text = "\(currentLocation.longitude)"
        }
        else {
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveLocation(_ sender: Any) {
        _ = LocationAnnotation(newTitle: titleTextField.text!, newSubtitle: descriptionTextField.text!, lat: Double(latitudeTextField.text!)!, long: Double(longitudeTextField.text!)!, siteFile: "1")
//
//            (newTitle: titleTextField.text!, newSubTitle:
//            descriptionTextField.text!, lat: Double(latitudeTextField.text!)!, long: Double(longitudeTextField.text!)!)
        _ = databaseController!.addSite(siteTitle: titleTextField.text!, siteDes: descriptionTextField.text!, siteLat: latitudeTextField.text!, siteLong: longitudeTextField.text!, siteImage: "1")
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
