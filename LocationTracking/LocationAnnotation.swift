//
//  LocationAnnotation.swift
//  Ass1
//
//  Created by haofang Liu on 26/8/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject,MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var siteFile:String?
    var site:Site?
    //var icon: String?
    
    init(newTitle:String,newSubtitle:String,lat:Double,long:Double,siteFile:String) {
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.siteFile = siteFile
    }
    
    init(site: Site) {
        self.title = site.siteTitle
        self.subtitle = site.siteDes
        coordinate = CLLocationCoordinate2D(latitude: Double(site.siteLat!) as! CLLocationDegrees, longitude: Double(site.siteLong!) as! CLLocationDegrees)
        self.siteFile = site.siteFile
        self.site = site
    }

}
