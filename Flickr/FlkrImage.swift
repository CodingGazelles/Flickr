//
//  FlkrImage.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




/*
 */
struct FlkrImage {
    
    var id: String?
    var title: String?
    var tag: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: String?
    var data: NSData?
    var timestamp: Double?
    
    
    var image: UIImage? {
        return self.data != nil ? UIImage(data: data!) : nil
    }
    
    var hasData: Bool {
        return data != nil
    }
    
}

