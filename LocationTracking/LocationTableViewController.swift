//
//  LocationTableViewController.swift
//  Ass1
//
//  Created by haofang Liu on 26/8/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationTableViewController: UITableViewController,UISearchResultsUpdating,DatabaseListener {

    

    
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
//            filteredHeroes = allHeroes.filter({(hero: SuperHero) -> Bool in
//                return hero.name.lowercased().contains(searchText)
//            })
//        }
//        else {
//            filteredHeroes = allHeroes;
//        }
//
//        tableView.reloadData();
//    }
//
    
    var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    //var allSites: [LocationAnnotation] = []
    //var allSites: [LocationAnnotation] = []
    var filteredSites: [LocationAnnotation] = []
    weak var databaseController: DatabaseProtocol?
    //var listenerType: ListenerType
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
//        var location = LocationAnnotation(newTitle: "Federation Square", newSubtitle: "When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", lat: -37.8180, long: 144.9691)
//            locationList.append(location)
//            mapViewController?.mapView.addAnnotation(location)
//
//        location = LocationAnnotation(newTitle: "Royal Botanic Gardens", newSubtitle: "Royal Botanic Gardens are among the finest of their kind in the world", lat: -33.8642, long: 151.2166)
//            locationList.append(location)
//            mapViewController?.mapView.addAnnotation(location)
        
        
//        locationList.sorted(by: { UIContentSizeCategory(rawValue: $0.title!) > UIContentSizeCategory(rawValue: $1.title!) })
//        locationList.sort { (<#LocationAnnotation#>, <#LocationAnnotation#>) -> Bool in
//            <#code#>
//        }
        
        filteredSites = locationList
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Site"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
//    We override both the viewWillAppear and viewWillDisappear methods so that we
//    can add/remove the VC as a listener of the database controller.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
//    We implement onTeamChange and onHeroListChange delegate methods.
//    o Due to the type, onTeamChange shouldn’t be called.
//    o For onHeroListChange we just repopulate the arrays and reload the table (by
//    running the search update method). Refreshing the entire table view is not
//    terribly efficient but is simple.
//    o This tutorial is designed for a simple example of Core Data. This can (and
//    should) be expanded for more complicated app designs.
    
    var listenerType = ListenerType.site
//    func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero]) {
//        // Won't be called.
//    }
    
    func onSiteListChange(change: DatabaseChange, sites: [Site]) {
        
        var locationList1 = [LocationAnnotation]()
        for site1 in sites{
            let annotation = LocationAnnotation(site: site1)
            locationList1.append(annotation)
            mapViewController?.mapView.addAnnotation(annotation)
        }
        
        locationList = locationList1
        
        
//        allSites = site
       updateSearchResults(for: navigationItem.searchController!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredSites = locationList.filter({(site: LocationAnnotation) -> Bool in
                return site.title!.lowercased().contains(searchText)
                //name.lowercased().contains(searchText)
            })
        }
        else {
            filteredSites = locationList;
        }
        
        tableView.reloadData();
    }
    

    // MARK: - Table view data source
    
    func locationAnnotationAdded(site: LocationAnnotation)
    {
        locationList.append(site)
        mapViewController?.mapView.addAnnotation(site)
        tableView.insertRows(at: [IndexPath(row: locationList.count - 1, section: 0)], with:.automatic)
    }
    
    //tableView.insertRows(at: [IndexPath(row: locationList.count - 1, section: 0)], with: .automatic)

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredSites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let annotation = self.filteredSites[indexPath.row]
        cell.textLabel?.text = annotation.title
        cell.detailTextLabel?.text = annotation.subtitle
        //"Lat: \(String(describing: annotation.siteLat)) Long:\(String(describing: annotation.siteLong))"
        //cell.imageView?.image = annotation.
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var annotation1 = LocationAnnotation(newTitle: self.locationList[indexPath.row].siteTitle!,newSubtitle: self.locationList[indexPath.row].siteDes!,lat: Double(self.locationList[indexPath.row].siteLat!) as! Double,long: Double(self.locationList[indexPath.row].siteLong!) as! Double,siteFile: self.locationList[indexPath.row].siteFile!);
        
        
        
        //prepare
        if !UIDevice.current.orientation.isLandscape {
            self.navigationController?.pushViewController(self.mapViewController!, animated: true)
        }
        mapViewController?.focusOn(annotation: self.locationList[indexPath.row])
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            locationList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            let siteAnn = LocationAnnotation(site: filteredSites[indexPath.row])
            let LocationAnn = filteredSites[indexPath.row]
            let siteAnn = LocationAnn.site
            databaseController?.deleteSite(site: siteAnn!)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

  

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == "toMap"{
//        _ = segue.destination as! MapViewController
     }
}

