//
//  Site+CoreDataProperties.swift
//  Ass1
//
//  Created by haofang Liu on 1/9/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//
//

import Foundation
import CoreData


extension Site {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Site> {
        return NSFetchRequest<Site>(entityName: "Site")
    }

    @NSManaged public var siteTitle: String?
    @NSManaged public var siteDes: String?
    @NSManaged public var siteLat: String?
    @NSManaged public var siteLong: String?
    @NSManaged public var siteFile: String?

}
