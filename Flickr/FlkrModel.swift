//
//  FLkrDataStack.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import Foundation





class FlkrModel {
    
    
    // Singleton
    private init(){}
    private static let defaultInstance = FlkrModel()
    static func defaultModel() -> FlkrModel {
        return defaultInstance
    }
    
    
    
    /*
    */
    func loadImageData( image: FlkrImage, callback: ( image: FlkrImage ) -> Void) {
        NSLog("Loading image: \(image.title)")
        
        
        // First fetch from cache
        let fullImage = FlkrCache.defaultCache().loadImageData(image)
        
        if fullImage != nil && fullImage?.data != nil {
            
            
            NSLog("Found image data in cache: \(image.title)")
            callback(image: fullImage!)
            
            
        } else {
            
            NSLog("Not found image data in cache loading from Flickr: \(image.title)")
            
            // if nothing in cache then fetch from Flickr
            // Call the web service
            FlkrWebServices.defaultServices().loadImageData(image) { image in
                NSLog("Image downloaded from Flickr, executing callback: \(image.title)")
                
                
                // Store in cache
                FlkrCache.defaultCache().storeImage(image)
                
                
                // Executes the callback
                callback( image: image)
                
            }
        }
        
    }
    
    
    
    /*
    */
    func listTags( callback: ( tags: [FlkrTag] ) -> Void) {
        NSLog("Listing hot tags")
        
        
        // Call the web service and then executes the callback
        FlkrWebServices.defaultServices().loadTags { tags in
            
            NSLog("Loaded tag list, now executing callback")
            callback( tags: tags)
            
        }
        
    }
    
    
    
    /*
    */
    func listImagesWithTag( tag: FlkrTag, callback: ( images: [FlkrImage]) -> Void) {
        NSLog("Listing images with tag: \(tag.label)")
        
        
        // First fetch from cache
        let imagesFromCache = FlkrCache.defaultCache().loadImagesWithTag(tag.label!)
        
        
        if imagesFromCache.count > 0 {
            
            NSLog("Found in cache images with tag \(tag.label), now executing callback")
            
            // Return what's there
            callback( images: imagesFromCache)
            
        } else {
            
            
            // if nothing in cache then fetch from Flickr
            // Call the web service and then executes the callback
            FlkrWebServices.defaultServices().loadImagesWithTag( tag) { images in
                NSLog("Loaded list of image with tag '\(tag.label)' from Flickr, now executing callback")
                
                callback( images: images)
                
            }
            
        }
        
    }
    
}