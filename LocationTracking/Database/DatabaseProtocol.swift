//
//  DatabaseProtocol.swift
//  Ass1
//
//  Created by haofang Liu on 31/8/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import Foundation


//First, we create an enum called DatabaseChange
//o This enum is used as part of the delegate to inform it of what kind of change
//has occurred to the database.
//o This has several possible cases (add, remove or update), but we will only use
//update for this week. Other cases can be used for more complex
//implementations.
enum DatabaseChange {
    case add
    case remove
    case update
}

//Another enum called ListenerType is declared
//o As our database controller deals with both teams AND heroes, we use this to
//determine what changes the listener cares about (i.e., wants to receive
//updates about).
enum ListenerType {
    case site
    case all
}

//The protocol DatabaseListener defines a delegate that will be used for receiving
//    updates from the Database.
//o It has 3 things that anything implementing it must take care of:
// It must define what type of Database Delegate is it
// An onTeamChange method called when a change to heroes in the
//team have occurred
// An onHeroListChange method called when a list of all heroes is
//changed
//Any class that communicates with the database in our code will implement
//this. For this week that is CurrentPartyTableViewController and
//AllHeroesTableViewController
//o NOTE: This protocol is Database agnostic, i.e., the communication it defines
//can be the same regardless of the database being used.
// This means next week when we implement Firebase, we do not need
//to change this protocol at all!


protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
//    func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero])
//    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero])
    func onSiteListChange(change: DatabaseChange,sites:[Site])
}


//The DatabaseProtocol is defined here
//o This protocol outlines all core functionality that a database MUST implement
//for this application.
//    o It is generic enough that it is not tied to any one type of database.
//     We use a CoreData database this week, and a Firestore cloud
//    database next week.
//    o This protocol has a property that returns the default team.
//o It provides the ability to add or delete Heroes and Teams.
//o We must also allow for the adding and removal of Heroes from Teams.
//o Lastly, it defines two methods for adding and removing listeners.

protocol DatabaseProtocol: AnyObject {
    //var defaultTeam: Team {get}
    
//    func addSuperHero(name: String, abilities: String) -> SuperHero
//    func addTeam(teamName: String) -> Team
//    func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
//    func deleteSuperHero(hero: SuperHero)
//    func deleteTeam(team: Team)
//    func removeHeroFromTeam(hero: SuperHero, team: Team)
    
    func addSite(siteTitle: String, siteDes: String,siteLat: String,siteLong:String,siteImage : String) -> Site
    //func addImage(fileName: String) -> Image
    //func addImageToSite(image: Image, site: Site) -> Bool
    func deleteSite(site: Site)
    //func deleteImage(image: Image)
    //func removeImageFromSite(image: Image, site: Site)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
