//
//  CoreDataController.swift
//  Ass1
//
//  Created by haofang Liu on 31/8/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

//We must import CoreData when dealing with any part of the framework. Up until
//now we haven't needed to import Frameworks, but we will increasing need to do this
//    as we work with various Frameworks in additional weeks.

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {

    
    
//    - There is a constant with the name for the default team.
    //let DEFAULT_SITE_NAME = "Site Name"
    
    
    
//        - The class contains a listeners property which any listeners. These are classes that
//    will be sent messages when changes are made to the database.
    var listeners = MulticastDelegate<DatabaseListener>()
//    The NSPersistentContainer property is the main link to the database. This class
//    instance contains the methods and properties needed to work with Core Data.
    var persistantContainer: NSPersistentContainer
    
    // Results
    var allSitesFetchedResultsController: NSFetchedResultsController<Site>?
    //var siteImageFetchedResultsController: NSFetchedResultsController<Site>?
    
    
//    - Override Init
//    o Our initializer is where we load up our Core Data database.
//    o We create a new NSPersistentContainer with the name "Week04-
//    SuperHeroes".
//     This name MUST match the Data Model we created previously
//     It is possible to have multiple of these persistent containers for
//    separate Data Models, if we desire.
//    o Once we have created the persistent store coordinator, we attempt to load
//    the database. We also provide a closure for when it has finished.
//     This loadPersistentStores method can fail if it cannot load the
//    database. For us, this is most likely if the Database doesn’t exist.
//     If the database fails to load, there is not point continuing and we call
//    fatalError.
//    o We then call our super initializer for any setup it requires
//    o Once the parent initializer has been called, we then make an attempt to get
//    all heroes from the database. This is to check if the database has any data in
//    it.
//     If the database does not have any heroes, then it is the first time
//    running and we call the createDefaultEntries method to populate the
//    database with some hardcoded values.
    override init() {
        persistantContainer = NSPersistentContainer(name: "Model")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        // If there are no heroes in the database assume that the app is running
        // for the first time. Create the default team and initial superheroes.
        if fetchAllSite().count == 0 {
            createDefaultEntries()
        }
    }
    
//    Fetch All Heroes
//    o Performs a fetch request on the Core Data database and returns all super
//    heroes
//    o This uses a NSFetchedResultsController. This class monitors the database
//    and notifies a delegate is the results change. The delegate is self and the
//    method called for the notification is the controllerDidChangeContent method
//    (see below).
//    Fetched Results Controllers need to set an ordering for the fetch. We sort
//    the superhero names alphabetically.
//    o The fetch is done only once and future calls to this method just return the
//    results from the Fetched Results Controller.
    
    func fetchAllSite() -> [Site]{
        if allSitesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Site> = Site.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "siteTitle", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allSitesFetchedResultsController = NSFetchedResultsController<Site>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            allSitesFetchedResultsController?.delegate = self
            do {
                try allSitesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        var sites = [Site]()
        if allSitesFetchedResultsController?.fetchedObjects != nil {
            sites = (allSitesFetchedResultsController?.fetchedObjects)!
        }
        
        return sites
    }
    
//    Fetch Team Heroes
//    o Almost identical to the fetchAllHeroes method.
//    o Instead of returning all heroes, this method returns only heroes in the default
//    team. This selection is done by setting an NSPredicate as part of the fetch
//    request.
//    func fetchTeamHeroes() -> [SuperHero] {
//        if teamHeroesFetchedResultsController == nil {
//            let fetchRequest: NSFetchRequest<SuperHero> = SuperHero.fetchRequest()
//            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//            fetchRequest.sortDescriptors = [nameSortDescriptor]
//            let predicate = NSPredicate(format: "ANY teams.name == %@", DEFAULT_TEAM_NAME)
//            fetchRequest.predicate = predicate
//            teamHeroesFetchedResultsController =
//                NSFetchedResultsController<SuperHero>(fetchRequest: fetchRequest, managedObjectContext:
//                    persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//            teamHeroesFetchedResultsController?.delegate = self
//
//            do {
//                try teamHeroesFetchedResultsController?.performFetch()
//            } catch {
//                print("Fetch Request failed: \(error)")
//            }
//        }
//
//        var heroes = [SuperHero]()
//        if teamHeroesFetchedResultsController?.fetchedObjects != nil {
//            heroes = (teamHeroesFetchedResultsController?.fetchedObjects)!
//        }
//
//        return heroes
//    }
    
    
//    Controller Did Change Content
//    o If the results of the All Heroes fetch change, notifies all listeners with the
//    “heroes” or “all” types.
//    o If the results of the Default Team Heroes fetch change, notifies all listeners
//    with the “team” or “all” types
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSitesFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.site || listener.listenerType == ListenerType.all {
                    listener.onSiteListChange(change: .update, sites: fetchAllSite())
                }
            }
        }
//        else if controller == teamHeroesFetchedResultsController {
//            listeners.invoke { (listener) in
//                if listener.listenerType == ListenerType.team || listener.listenerType == ListenerType.all {
//                    listener.onTeamChange(change: .update, teamHeroes: fetchTeamHeroes())
//                }
//            }
//        }
    }
        
        func createDefaultEntries() {
//            let _ = addSuperHero(name: "Bruce Wayne", abilities: "Is Rich")
//            let _ = addSuperHero(name: "Superman", abilities: "Super Powered Alien")
//            let _ = addSuperHero(name: "Wonder Woman", abilities: "Goddess")
//            let _ = addSuperHero(name: "The Flash", abilities: "Faster than speed of light")
//            let _ = addSuperHero(name: "Green Lantern", abilities: "Has a magic ring")
//            let _ = addSuperHero(name: "Cyborg", abilities: "Is a cyborg")
//            let _ = addSuperHero(name: "Aquaman", abilities: "Can breathe underwater")
            
//            var location = LocationAnnotation(newTitle: "Federation Square", newSubtitle: "When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", lat: -37.8180, long: 144.9691)
            //            locationList.append(location)
            //            mapViewController?.mapView.addAnnotation(location)
            //
            //        location = LocationAnnotation(newTitle: "Royal Botanic Gardens", newSubtitle: "Royal Botanic Gardens are among the finest of their kind in the world", lat: -33.8642, long: 151.2166)
            //            locationList.append(location)
            //            mapViewController?.mapView.addAnnotation(location)
            let _ = addSite(siteTitle: "Federation Square", siteDes:"When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", siteLat: "-37.8180", siteLong: "144.9691", siteImage: "test")
//            let _ = addSite(siteTitle: "Federation Square", siteDes:"When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", siteLat: "-37.8180", siteLong: "144.9691", siteImage: "3")
//            let _ = addSite(siteTitle: "Federation Square", siteDes:"When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", siteLat: "-37.8180", siteLong: "144.9691", siteImage: "3")
//            let _ = addSite(siteTitle: "Federation Square", siteDes:"When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", siteLat: "-37.8180", siteLong: "144.9691", siteImage: "3")
//            let _ = addSite(siteTitle: "Federation Square", siteDes:"When Federation Square opened in 2002 to commemorate 100 years of federation, it divided Melburnians", siteLat: "-37.8180", siteLong: "144.9691", siteImage: "3")
        }

//Save Context
//o Whenever we add, edit or delete a managed object the changes are made to
//the context but not to file. To make these changes persistent saveContext
//needs to be called.
//o This method first checks if changes have been made. If changes have been
//made it will save to file. It will crash if it can’t persist the changes.

    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
//    Add Super Hero
//    o This method is used to create a new Super Hero object in the database
//    o We pass in all information a super hero needs and return the object when
//    finished
//    o To create a hero managed by Core Data we must use the
//    NSEntityDescription.insertNewObject method.
//     We provide it the entity name. This must match a valid entity in our
//    data model
//     We provide it the object context that we want to insert the object into
//    (Our viewContext in this case)
//     When finished, it will return a managed object back to us. We explicitly
//    store it in a property of type SuperHero
//    Once the object is created, we can set the name and abilities properties that
//    were passed in.
//    o The last step before returning the object is to save the changes to the
//    database.
//     Saving changes can be resource intensive, so best practice is to
//    batch a number of changes and save the changes at the end.
//     For our app it’s fine to save after every change.
    func addSite(siteTitle: String, siteDes: String, siteLat: String, siteLong: String, siteImage : String) -> Site {
        let site = NSEntityDescription.insertNewObject(forEntityName: "Site", into:
            persistantContainer.viewContext) as! Site
//        hero.name = name
//        hero.abilities = abilities
        site.siteTitle = siteTitle
        site.siteDes = siteDes
        site.siteLat = siteLat
        site.siteLong = siteLong
        site.siteFile = siteImage
        // This less efficient than batching changes and saving once at end.
        saveContext()
        return site
    }
    
//    Add Team
//    o Functionally identical to Add Super Hero but for the Team entity.
//    func addImage(fileName: String) -> Image {
//        let image = NSEntityDescription.insertNewObject(forEntityName: "Image", into:
//            persistantContainer.viewContext) as! Image
//        image.fileName = fileName
//        // This less efficient than batching changes and saving once at end.
//        saveContext()
//        return image
//    }
    
//    - Add Hero to Team
//    o Given a Hero and a Team, we add the Hero into said Team.
//    func addImageToSite(image: Image, site: Site) -> Bool {
//        guard let images = site.sitePic, images.contains(image) == false else {
//            return false
//        }
//
//        //team.addToHeroes(hero)
//        site.addToSitePic(image)
//        // This less efficient than batching changes and saving once at end.
//        saveContext()
//        return true
//    }
    
//    Delete Super Hero
//    o Delete a given Hero from the database.
    func deleteSite(site: Site) {

        persistantContainer.viewContext.delete(site)
        // This less efficient than batching changes and saving once at end.
        saveContext()
    }
    
//    Delete Team
//    o Delete a given Team from the database.
//    func deleteImage(image: Image) {
//        persistantContainer.viewContext.delete(image)
//        // This less efficient than batching changes and saving once at end.
//        saveContext()
//    }
    
//    Remove Hero from Team
//    o Given a Hero and a Team, remove the Hero from the Team.
//    func removeImageFromSite(image: Image, site: Site) {
//        //team.removeFromHeroes(hero)
//        site.removeFromSitePic(image)
//        // This less efficient than batching changes and saving once at end.
//        saveContext()
//    }
    
//    Add Listener
//    o Add the given listener to the list of listeners.
//    o Depending on the listener type we fetch and notify the listener with a change
//    notification with an array of either the heroes in the default team or all heroes.
//    o The actual fetch is done by the fetchAllHeroes or fetchTeamHeroes, which
//    performs it only once, regardless of the number of listeners added.
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == ListenerType.site || listener.listenerType == ListenerType.all {
            listener.onSiteListChange(change: .update, sites: fetchAllSite())
        }
        
//        if listener.listenerType == ListenerType.site || listener.listenerType == ListenerType.all {
//            listener.onSiteListChange(change: .update, sites: fetchAllSite())
//        }
    }
    
//    Remove Listener
//    o Remove the given listener from the list of listeners.
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    

}
