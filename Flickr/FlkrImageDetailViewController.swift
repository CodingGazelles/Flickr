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
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // the image to display
    var image: FlkrImage!
    
    
    
    /*
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Awaked FlkrImageDetailViewController")
        
        
        // Init UI
        activityIndicator!.startAnimating()
        titleLabel.text = image.title
        
        
        // Loading image data
        loadImageData()
        
    }
    
    
    
    /*
     Set the image and update the view
    */
    func setImage( image: FlkrImage) {
        self.image = image
    }
    
    
    
    /*
     Loads image data and reload the view
     */
    private func loadImageData() {
        
        FlkrModel.defaultModel().loadImageData(image) { image in
            NSLog("Image data loaded, executing callback")
            
            
            // Return to Main Thread
            dispatch_async(dispatch_get_main_queue(), {
                
                
                // Just in case
                if self.image == nil {
                    NSLog("ImageView not yet initialized. Unable to set Image.")
                }
                
                if self.activityIndicator == nil {
                    NSLog("Activity Indicator not yet initialized.")
                }
                
                
                // set the image
                self.image = image
                self.imageView!.image = image.image!

                
                // stop the activity monitor
                self.activityIndicator!.stopAnimating()
                self.activityIndicator!.hidden = true

                
                // reload the view
                self.view.setNeedsLayout()
                
            })
            
        }
        
    }
    
    
}
