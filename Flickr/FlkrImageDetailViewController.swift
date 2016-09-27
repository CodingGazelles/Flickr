//
//  FlkrImageDetailViewController.swift
//  Flickr
//
//  Created by Tancrède on 9/26/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit





class FlkrImageDetailViewController: UIViewController {
    
    
    // Outlet
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    
    // the image to display
    var image: FlkrImage!
    
    
    
    /*
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLog("Awaked FlkrImageDetailViewController")
    }
    
    
    
    /*
     Set the state of activity monitor
    */
    override func viewWillAppear(animated: Bool) {
        if image.image == nil && activityIndicator != nil {
            activityIndicator!.startAnimating()
        }
    }
    
    
    
    /*
     Set the image and update the view
    */
    func setImage( image: FlkrImage) {
        self.image = image
        loadImageData()
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
                if self.imageView != nil {
                    self.imageView!.image = image.image!
                } else {
                    NSLog("ImageView not yet initialized. Unable to set Image.")
                }
                
                
                // stop the activity monitor
                if self.activityIndicator != nil {
                    self.activityIndicator!.stopAnimating()
                    self.activityIndicator!.hidden = true
                } else {
                    NSLog("Activity Indicator not yet initialized.")
                }
                
                
                // reload the view
                self.view.setNeedsLayout()
                
            })
            
        }
        
    }
    
    
}
