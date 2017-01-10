//
//  FlkrDataStack.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import Foundation
import CoreData
import CoreImage




/*
 Image cache using CoreData and In Memory Store
 */
class FlkrCache {
    
    
    
    // Singleton
    private init(){}
    private static let defaultInstance = FlkrCache()
    static func defaultCache() -> FlkrCache {
        return defaultInstance
    }
    
    
    // Entities in the model
    enum Entity: String {
        case CachedImage = "FlkrCachedImage"
    }
    
    
    // ManagedObjectContext
    private var managedObjectContext: NSManagedObjectContext!
    
    
    // Cache duration 30 secs
    let cacheDuration: Double = 30 * 1000
    
    
    /*
     */
    func initCache() {
        NSLog("Initiating cache")
        
        
        var moc: NSManagedObjectContext
        
        
        // Accessing Model
        guard let modelURL = NSBundle.mainBundle().URLForResource( "FlkrModel", withExtension: "momd") else {
                
                let error = FlkrError.FailedSetup(
                    message: "Error loading model from bundle",
                    rootError: nil)
                
                NSLog("\(error)")
                
                return
        }
        
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            
            let error = FlkrError.FailedSetup(
                message: "Error initializing Managed Object Model from: \(modelURL)",
                rootError: nil)
            
            NSLog("\(error)")
            
            return
        }
        
        
        // Initiating StoreCoordinator
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        
        //Use InMemory Store (see specs of the test)
        do {
            
            try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            
            self.managedObjectContext = moc
            
        } catch {
            
            let error = FlkrError.FailedSetup(
                message: "Error occured while connecting to DB",
                rootError: error)
            
            NSLog("\(error)")
            
        }
        
    }
    
    
    
    /*
    */
    func storeImage( image: FlkrImage) {
        NSLog("Storing Image in cache \(image.id)")
        
        
        guard image.data != nil else {
            let error = FlkrError.FailedSavingToCache(
                message: "Failed to save image to cache", rootError: nil)
            
            NSLog("\(error)")
            
            return
        }
        
        
        do {
            
            let cachedImaged = NSEntityDescription.insertNewObjectForEntityForName( Entity.CachedImage.rawValue, inManagedObjectContext: managedObjectContext) as! FlkrCachedImage

            cachedImaged.initWith(image)
            
            try managedObjectContext.save()
            
            
        } catch {
            let error = FlkrError.FailedSavingToCache(
                message: "Failed to save image to cache",
                rootError: error)
            
            NSLog("\(error)")
            
        }
        
    }
    
    
    
    /*
     */
    func loadImageData( image: FlkrImage) -> FlkrImage? {
        NSLog("Loading image data from cache \(image.title)")
        
        
        let fetch = NSFetchRequest(entityName: Entity.CachedImage.rawValue)
        fetch.predicate = NSPredicate( format: "id == %@", image.id!)
        
        
        do {
            
            
            let image = try managedObjectContext.executeFetchRequest(fetch).first as! FlkrCachedImage?
            return image?.convertTo()
            
            
        } catch {
            
            NSLog("Failed to load image data from cache \(image.title)")
            
            return nil
            
        }
        
    }
    
    
    /*
    */
    func loadImagesWithTag( tag: String) -> [FlkrImage] {
        NSLog("Loading Images from cache with tag \(tag)")
        
        
        // fetch images with tag and timestamp less than 30 seconds
        let fetch = NSFetchRequest(entityName: Entity.CachedImage.rawValue)
        fetch.predicate = NSPredicate( format: "tag == %@ and timestamp <= %@ ", tag, 	NSDate().timeIntervalSince1970 - cacheDuration )
        
        
        do {
            
            
            let images = try managedObjectContext.executeFetchRequest(fetch) as! [FlkrCachedImage]
            
            return images.map { cachedImage in
                return cachedImage.convertTo()
            }
            
            
        } catch {
            
            let error = FlkrError.FailedLoadingFromCache(
                message: "Failed to load images",
                rootError: error)
            
            NSLog("\(error)")
            
            return [FlkrImage]()
            
        }
        
    }
    
    
    
}