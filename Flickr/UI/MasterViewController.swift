//
//  MasterViewController.swift
//  Flickr
//
//  Created by Tancrède on 9/22/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




/*
 */
class FlkrMasterViewController: UIViewController {
    
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tagContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    
    
    // Children
    var tagCollectionVC: FlkrTagCollectionViewController!
    var imageCollectionVC: FlkrImageCollectionViewController!
    
    
    // Segues that open to the TagCollection container and the ImageCollection container
    let tagContainerEmbedSegueID = "TagContainerSegueID"
    let imageContainerEmbedSegueID = "ImageContainerSegueID"
    
    
    
    /*
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Awaked FlkrMasterViewController")
    }
    
    
    
    /*
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.delegate = self
    }
    
    
    
    /*
     Configures the TagCollection container and the ImageCollection container
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == tagContainerEmbedSegueID {
            tagCollectionVC = segue.destinationViewController as! FlkrTagCollectionViewController
            tagCollectionVC.container = self
        }
        
        
        if segue.identifier == imageContainerEmbedSegueID {
            imageCollectionVC = segue.destinationViewController as! FlkrImageCollectionViewController
            imageCollectionVC.container = self
        }
        
    }
    
    
    
    /*
     Called when user clicked on the search button or on a tag
    */
    func launchSearch() {
        let tag = FlkrTag( label: searchBar.text)
        imageCollectionVC.setTag(tag)
    }
    
}




// MARK : - Conformance to UISearchBarDelegate

/*
 */
extension FlkrMasterViewController: UISearchBarDelegate {
    
    
    /*
     Begin the search for images, called when user clicked on the search button
    */
    func searchBarSearchButtonClicked( searchBar: UISearchBar) {
        launchSearch()
    }
    
}


