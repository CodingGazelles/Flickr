//
//  FlkrWebServices.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




/*
 Services to access Flickr API
 */
class FlkrWebServices {
    
    
    // Singleton
    private init(){}
    private static let defaultInstance = FlkrWebServices()
    static func defaultServices() -> FlkrWebServices {
        return defaultInstance
    }
    
    
    // Keys to access Flick
    private let api_key = "1c79a7fe1e0ab81719c97dd51e825627"
    private let secret = "0b28fde6a9ef1feb"
    
    
    // URLs
    enum Url: String {
        
        
        // Loading image
        case LoadImage = "https://farm%@.staticflickr.com/%@/%@_%@.jpg"
        
        
        // Calling Flickr Services
        case EndPointRest = "https://api.flickr.com/services/rest/?"
        case ArgApiKey = "api_key="
        case ArgFormatJson = "format=json"
        case ArgNoCallback = "nojsoncallback=1"
        
        
        // Listing hot tags
        case MethodListTags = "method=flickr.tags.getHotList"
        case ArgPeriod = "period=week"
        
        
        // Listing photos
        case MethodListPhotosWithTag = "method=flickr.photos.search"
        case ArgTags = "tags="
        
    }
    
    
    
    /*
    */
    func buildUrl( args: String ...) -> NSURL{
        
        var result: String = ""
        
        for arg in args {
            result += arg
        }
        
        return NSURL( string: result)!
    }
    
    
    
    /*
     Loading image from Flickr and storing it into the cache
    */
    func loadImageData( image: FlkrImage, callback: (image: FlkrImage) -> Void) {
        NSLog("Loading image from Flickr \(image.title)")
        
        
        assert( image.farm != nil && image.server != nil && image.id != nil && image.secret != nil, "Can't call this method witg empty Image")
        
        
        let url = NSURL( string: String( format: Url.LoadImage.rawValue, image.farm!, image.server!, image.id!, image.secret!))
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            
            guard error == nil else {
                NSLog("Error: \(error)")
                NSLog("Response: \(response)")
                NSLog("Data: \(data)")
                
                let unknownImage = UIImage.init(named: "unknown-image")
                
                var image = image
                image.data = UIImagePNGRepresentation( unknownImage!)!
            
                callback(image: image)
                
                return
            }
            
            
            var image = image
            image.data = data
            
            callback(image: image)
            
        }
        
        task.resume()
        
    }
    
    
    
    
    /*
     Loads the tags and execute the callback
    */
    func loadTags( callback: ( tags: [FlkrTag]) -> Void) {
        NSLog("Loading tags from Flickr")
        
        let url = buildUrl(
            Url.EndPointRest.rawValue,
            Url.ArgApiKey.rawValue + api_key,
            "&" + Url.ArgNoCallback.rawValue,
            "&" + Url.ArgFormatJson.rawValue,
            "&" + Url.MethodListTags.rawValue
        )
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            
            guard error == nil else {
                NSLog("Error: \(error)")
                NSLog("Response: \(response)")
                NSLog("Data: \(data)")
                
                
                // Execute callback with empty tag array
                callback(tags: [FlkrTag]())
                
                
                return
            }
            
            
            // Parse Json
            let parser = FlkrTagListJsonParser( data: data!)
            let tagList = parser.parse()
        
            
            // Execute callback
            callback( tags: tagList)
            
        }
        
        
        task.resume()
        
    }
    
    
    
    /*
     Loads the images and execute the callback
     */
    func loadImagesWithTag( tag: FlkrTag, callback: ( tags: [FlkrImage]) -> Void) {
        NSLog("Loading images with tag from Flickr: \(tag.label)")
        
        
        assert(tag.label != nil, "Can't call this method with nil tag")
        
        
        let url = buildUrl(
            Url.EndPointRest.rawValue,
            Url.ArgApiKey.rawValue + api_key,
            "&" + Url.ArgNoCallback.rawValue,
            "&" + Url.ArgFormatJson.rawValue,
            "&" + Url.MethodListPhotosWithTag.rawValue,
            "&" + Url.ArgTags.rawValue + tag.label!
        )
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            
            guard error == nil else {
                NSLog("Error: \(error)")
                NSLog("Response: \(response)")
                NSLog("Data: \(data)")
                
                
                // Execute callback with empty array
                callback(tags: [FlkrImage]())
                
                
                return
            }
            
            
            // Parse Json
            let parser = FlkrImageListJsonParser( tag: tag.label!,  data: data!)
            let imageList = parser.parse()
            
            
            // Execute callback
            callback( tags: imageList)
            
        }
        
        
        task.resume()
        
    }
    
}


