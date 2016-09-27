//
//  FlkrJsonSerialization.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import Foundation




/*
 */
typealias JsonDictionary = Dictionary<String, AnyObject>
typealias JsonArray = Array<JsonDictionary>




/*
 Reads the json file and intanciates Tags
 */
struct FlkrTagListJsonParser {
    
    
    // Store the json
    let data: NSData
    
    
    /*
     Keys of the json file
     */
    enum JsonKey: String {
        case Callback = "jsonFlickrApi"
        case HotTags = "hottags"
        case Tag = "tag"
        case Index = "Index"
        case Content = "_content"
    }
    
    
    /*
     */
    init( data: NSData) {
        self.data = data
    }
    
    
    
    /*
     */
    func parse() -> [FlkrTag] {
        
        
        var tagList = [FlkrTag]()
        
        
        // Parsing Json
        let jsonData = try! NSJSONSerialization.JSONObjectWithData( self.data, options: [NSJSONReadingOptions.AllowFragments]) as! JsonDictionary
        let hottags = jsonData[JsonKey.HotTags] as! JsonDictionary
        let tags = hottags[JsonKey.Tag] as! JsonArray
        
        
        // Instanciates Tag list from data in Json
        for item in tags {
            
            
            // Parsing Json
            let label = item[JsonKey.Content] as! String
            
            
            // New Tag
            let tag = FlkrTag(label: label)
            
            
            //
            tagList.append(tag)
            
        }
        
        
        return tagList
        
    }
    
}




/*
 Reads the json file and intanciates Tags
 */
struct FlkrImageListJsonParser {
    
    
    // Store the json
    let data: NSData
    
    
    //
    var tag: String
    
    
    /*
     Keys of the json file
     */
    enum JsonKey: String {
        case Photos = "photos"
        case Photo = "photo"
        case Id = "id"
        case Owner = "owner"
        case Secret = "secret"
        case Server = "server"
        case Farm = "farm"
        case Title = "title"
    }
    
    
    /*
     */
    init( tag: String, data: NSData) {
        self.tag = tag
        self.data = data
    }
    
    
    
    /*
     */
    func parse() -> [FlkrImage] {
        
        
        var imageList = [FlkrImage]()
        
        
        // Parsong Json
        let jsonData = try! NSJSONSerialization.JSONObjectWithData( self.data, options: [NSJSONReadingOptions.AllowFragments]) as! JsonDictionary
        
        let photos = jsonData[JsonKey.Photos] as! JsonDictionary
        let photoArray = photos[JsonKey.Photo] as! JsonArray
        
        
        // Instanciates Tag list from data in Json
        for item in photoArray {
            
            
            // Parsing Json
            let id = item[JsonKey.Id] as! String
            let owner = item[JsonKey.Owner] as! String
            let secret = item[JsonKey.Secret] as! String
            let server = item[JsonKey.Server] as! String
            let farm = String( item[JsonKey.Farm])
            let title = item[JsonKey.Title] as! String
            
            
            // New Image
            let image = FlkrImage(
                id: id,
                title: title,
                tag: self.tag,
                owner: owner,
                secret: secret,
                server: server,
                farm: farm,
                data: nil,
                timestamp: NSDate().timeIntervalSince1970
            )
            
            
            //
            imageList.append(image)
            
        }
        
        
        return imageList
        
    }
    
}




/*
 Overload Subscript of the JsonDictionary to accept a FOJsonKeys as Index
 */
extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {
    
    subscript(index: FlkrTagListJsonParser.JsonKey) -> AnyObject {
        get {
            return self[ index.rawValue as! Key] as! AnyObject
        }
    }
    subscript(index: FlkrImageListJsonParser.JsonKey) -> AnyObject {
        get {
            return self[ index.rawValue as! Key] as! AnyObject
        }
    }
    
}
