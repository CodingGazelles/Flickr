//
//  FlkrImageCollectionViewController.swift
//  Flickr
//
//  Created by Tancrède on 9/26/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




/*
 */
class FlkrImageCollectionViewController: UICollectionViewController {
    
   
    // state of the VC
    var tag: FlkrTag?
    var imageList: [FlkrImage]?
    var selectedImage: FlkrImage?
    
    
    // Collection Cell View reuse ID
    let cellReuseID = FlkrImageCellView.storyboardReuseID
    let cellNibName = FlkrImageCellView.storyboardReuseID
    var cellViewNib: UINib!
    
    
    // Container view
    var container: FlkrMasterViewController!
    
    
    // Segue identifier
    let imageDetailShowSegueID = "ImageDetailSegueID"
    
    
    
    /*
     */
    override func awakeFromNib() {
        super.viewDidLoad()
        
        NSLog("Awaked FlkrImageCollectionViewController")
        
        
        //
        initUI()
        
    }
    
    
    
    /*
     Set the tag used to search the images
     */
    func setTag( tag: FlkrTag) {
        self.tag = tag
        loadImages()
    }
    
    
    
    /*
     Set up the UI
     */
    private func initUI() {
        
        // Register datasource and delegate
        collectionView!.dataSource = self
        collectionView!.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView!.delegate = self
        
        
        // Register collection cell view
        cellViewNib = UINib.init(nibName: cellNibName, bundle: nil)
        collectionView!.registerNib( cellViewNib, forCellWithReuseIdentifier: cellReuseID)
        
    }
    
    
    
    /*
     Load the list of images attached to the tag
    */
    private func loadImages() {
        
        if tag != nil {
            FlkrModel.defaultModel().listImagesWithTag(tag!) { imageList in
                NSLog("Executing callback of FlkrImageCollectionViewController loadImages")
                
                
                // return to Main Thread
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Update View
                    self.imageList = imageList
                    self.collectionView?.reloadData()
                    
                })
            }
        }
    }
    
    
    
    /*
     Configure the Detail Image View Controller
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == imageDetailShowSegueID {
            
            let indexPath = sender as! NSIndexPath
            let imageDetailVC = segue.destinationViewController as! FlkrImageDetailViewController
            
            imageDetailVC.setImage( self.imageList![indexPath.row])
            
        }
        
    }
    
}




// MARK: - conformance to UICollectionViewDataSource

/*
 */
extension FlkrImageCollectionViewController {
    
    
    
    /*
     */
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    /*
     */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }
    
    
    
    /*
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = getCell(indexPath)
        configureCell(&cell, indexPath: indexPath)
        
        return cell
    }
    
    
    
    /*
     */
    func getCell( indexPath: NSIndexPath) -> FlkrImageCellView {
        
        let cell = collectionView!.dequeueReusableCellWithReuseIdentifier( cellReuseID, forIndexPath: indexPath) as! FlkrImageCellView
        cell.reset()
        
        return cell
    }
    
    
    
    /*
     */
    func configureCell( inout cell: FlkrImageCellView, indexPath: NSIndexPath) {
        let image = imageList![indexPath.row]
        cell.setImage(image)
    }
    
}




// MARK: - Conforçance to UICollectionViewDelegate

/*
 */
extension FlkrImageCollectionViewController {
    
    
    /*
    */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier( imageDetailShowSegueID, sender: indexPath)
    }
    
}



