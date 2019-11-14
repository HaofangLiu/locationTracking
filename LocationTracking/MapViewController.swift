//
//  MapViewController.swift
//  Ass1
//
//  Created by haofang Liu on 26/8/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPointOnMap : LocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        
        // set initial location in Melbourne
        let initialLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius,longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
        }
        centerMapOnLocation(location: initialLocation)

//        let location = LocationAnnotation(newTitle: "Melbourne", newSubtitle: "Welcome to Melbourne", lat: -37.8136, long: 144.9631)
//        mapView.addAnnotation(location)
//
//        let zoomRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500,longitudinalMeters: 500)
//        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)

        // Do any additional setup after loading the view.
    }
    
    //The focusOn method re-centres the map around a specified annotation. It also pops
    //up the detail window for the annotation.
    //o It zooms to show 1km of latitudinal and longitudinal context.
    func focusOn(annotation:MKAnnotation){
        mapView.selectAnnotation(annotation,animated: true)

        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let controller = segue.destination as! LocationDetailViewController
            controller.annotation = self.selectedPointOnMap!
    }
    

}
    
}

extension MapViewController: MKMapViewDelegate {
    
    
    //reference:https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? LocationAnnotation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    //show detail of site and pass obj in prepear
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showDetail", sender: nil)
        
    }
    
    //get the on that is selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedPointOnMap = mapView.selectedAnnotations[0] as? LocationAnnotation
    }
    
    
}

