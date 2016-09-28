//
//  FlkrTagCollectionViewController.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




/*
 */
class FlkrTagCollectionViewController: UICollectionViewController {
    
    
    // Tag list
    var tagList: [FlkrTag]?
    
    
    // Collection Cell View reuse ID
    let cellReuseID = FlkrTagCellView.storyboardReuseID
    let cellNibName = FlkrTagCellView.storyboardReuseID
    var cellViewNib: UINib!
    
    
    // Parent view
    var container: FlkrMasterViewController!
    
    
    /*
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Awaked FlkrTagCollectionViewController")
        
        //
        initUI()
        loadTags()
        
    }
    
    
    
    /*
     Configures the UI
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
     Load the tag list
    */
    private func loadTags() {
        
        
        // List hot tags
        FlkrModel.defaultModel().listTags { tags in
            NSLog("Loaded tags, now executing callback")
            
            
            // return to Main Thread
            dispatch_async(dispatch_get_main_queue(), {
                
                // Update View
                self.tagList = tags
                self.collectionView?.reloadData()
                
            })
            
        }
        
    }
    
}




// MARK: - conformance to UICollectionViewDataSource

/*
 */
extension FlkrTagCollectionViewController {
    
    
    
    /*
     3 lines in the collection
     */
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    
    /*
     3 tags per lines
     TODO: calculate how many tags we can put on a line
     */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Only 3 tags per row, let's start with that
        return tagList != nil ? 3 : 0
    }
    
    
    
    /*
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = getCell(indexPath)
        configureCell(&cell, indexPath: indexPath)
        cell.tagLabel.sizeToFit()
        
        return cell
    }
    
    
    
    /*
     */
    func getCell( indexPath: NSIndexPath) -> FlkrTagCellView {
        return collectionView!.dequeueReusableCellWithReuseIdentifier( cellReuseID, forIndexPath: indexPath) as! FlkrTagCellView
    }
    
    
    
    /*
     */
    func configureCell( inout cell: FlkrTagCellView, indexPath: NSIndexPath) {
        let tag = tagList![ indexPath.section * 3 + indexPath.row]
        cell.tagLabel.text = tag.label
    }
    
}




// MARK: - Conformance to UICollectionViewDelegate

/*
 */
extension FlkrTagCollectionViewController {
    
    
    /*
     User clicked on a tag, launch the search
    */
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let tag = tagList![ indexPath.section * 3 + indexPath.row]
        container.searchBar.text = tag.label
        container.launchSearch()
        
        return true
    }
    
}




// MARK: - conformance to UICollectionViewDelegateFlowLayout

/*
 */
extension FlkrTagCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    /*
     Calculate the size of each tag cell
    */
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let tag = tagList![indexPath.section * 3 + indexPath.row]
        let size = tag.labelSize()
        
//        NSLog("sizeForItemAt: \(indexPath), tag: \(tag.label), w: \(size.width), h: \(size.height)")
        
        return CGSize(width: size.width, height: size.height)
        
    }
    
}





/*
 Extension on FlkrTag to calculate label size
 */
extension FlkrTag {
    
    
    /*
     Calculate the size of a string as it will be drawn on the screen
    */
    func labelSize() -> (width: Double, height: Double) {
        
        let maxLabelSize = CGSize(width: 300, height: 30)
        let attrLabel = NSAttributedString( string: label!, attributes: [ NSFontAttributeName: UIFont.systemFontOfSize(17) ])
        
        
        let rect = attrLabel.boundingRectWithSize(
            maxLabelSize,
            options: [ .UsesLineFragmentOrigin, .UsesFontLeading],   //, .UsesFontLeading, .UsesDeviceMetrics
            context: nil)
        
        return ( Double(rect.width) + 10, 30)
        
    }
}


