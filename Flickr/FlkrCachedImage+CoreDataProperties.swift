//
//  FlkrCachedImage+CoreDataProperties.swift
//  Flickr
//
//  Created by Tancrède on 9/26/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FlkrCachedImage {

    @NSManaged var data: NSData?
    @NSManaged var farm: String?
    @NSManaged var id: String?
    @NSManaged var owner: String?
    @NSManaged var secret: String?
    @NSManaged var server: String?
    @NSManaged var title: String?
    @NSManaged var timestamp: NSNumber?
    @NSManaged var tag: String?

}
