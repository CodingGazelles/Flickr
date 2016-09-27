//
//  FlkrCachedImage.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import Foundation
import CoreData


class FlkrCachedImage: NSManagedObject {

    
    
    /*
    */
    func initWith( image: FlkrImage) {
        self.id = image.id
        self.title = image.title
        self.tag = image.tag
        self.owner = image.owner
        self.secret = image.secret
        self.server = image.server
        self.farm = image.farm
        self.data = image.data
        self.timestamp = image.timestamp
    }
    
    
    /*
    */
    func convertTo() -> FlkrImage {
        
        let image = FlkrImage(
            id: self.id,
            title: self.title,
            tag: self.tag,
            owner: self.owner,
            secret: self.secret,
            server: self.server,
            farm: self.farm,
            data: self.data,
            timestamp: self.timestamp as! Double
        )
        
        return image
        
    }
    
}
