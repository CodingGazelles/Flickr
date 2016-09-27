//
//  FlkrImageCellView.swift
//  Flickr
//
//  Created by Tancrède on 9/26/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




/*
 */
class FlkrImageCellView: UICollectionViewCell {
    
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // Storyboard ID
    static let storyboardReuseID = "FlkrImageCellView"
    
    
    // FlkrImage to display in the cell
    private var image: FlkrImage!
    
    
    
    /*
     Reset the view
     In case the view is reuse by the collection (don't know if it's usefull but just in case)
    */
    func reset() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    
    
    /*
     Set the image
     Load the data if image is empty
     Stop the activty inicator
     Reload the view
    */
    func setImage( image: FlkrImage) {
        
        self.image = image
        
        if image.data != nil {
            
            
            // set the image
            imageView.image = image.image
            
            
            // stop the activity monitor
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            
            
            // reload the view
            self.setNeedsLayout()
            
        } else {
            
            // if the image is empty, load its data
            loadImageData()
            
        }
        
    }
    
    
    
    /*
     Loads image data and reload the view
    */
    private func loadImageData() {
        
        FlkrModel.defaultModel().loadImageData(image) { image in
            NSLog("Executing callback of FlkrImageCellView loadImageData")
            
            
            // Return to Main Thread
            dispatch_async(dispatch_get_main_queue(), {
                
                
                // set the image
                self.image = image
                self.imageView.image = image.image!
                
                
                // stop the activity monitor
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                
                
                // reload the view
                self.setNeedsLayout()
                
            })
            
        }
        
    }
    
}
