//
//  CollectionViewController.swift
//  HHacessorios
//
//  Created by William Alvelos on 28/05/16.
//  Copyright © 2016 Helga. All rights reserved.
//

import UIKit
import Photos

protocol CollectionDelegate : class{
    func finishedSelectingImage(image:UIImage?)
}

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CroppingDelegate {
    
    weak var delegate:CollectionDelegate?
    let collectionHeightFactor:CGFloat = 0.3
    var previewScrollView: UIScrollView!
    var imageView: UIImageView!
    var collectionView: UICollectionView!
    var assetArray = [PHAsset]()
    var selectedImage:UIImage?
    var type:PictureType?
    var croppingView:PictureCroppingView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let okButton = UIButton(frame: CGRectMake(self.view.frame.width - 10 - self.view.frame.height * 0.09, 10, self.view.frame.height * 0.09, self.view.frame.height * 0.09))
        let backButton = UIButton(frame: CGRectMake(10, 10, self.view.frame.height * 0.09, self.view.frame.height * 0.09))
        
        okButton.addTarget(self, action: #selector(CollectionViewController.startCroppingSelectedImage), forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: #selector(CollectionViewController.cancelCollectionSelection), forControlEvents: UIControlEvents.TouchUpInside)
        
        okButton.backgroundColor = Colors.Azul
        backButton.backgroundColor = Colors.Azul
        
        okButton.layer.cornerRadius = okButton.frame.height / 2
        backButton.layer.cornerRadius = backButton.frame.height / 2
        
        okButton.layer.zPosition = 2
        backButton.layer.zPosition = 2
        
        backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        okButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        
        okButton.setTitle(NSLocalizedString("ok", comment: ""), forState: UIControlState.Normal)
        okButton.setTitleColor(Colors.Rosa, forState: UIControlState.Normal)
        
        backButton.setImage(UIImage(named: "icon_exit_camera"), forState: UIControlState.Normal)
        
        self.view.addSubview(okButton)
        self.view.addSubview(backButton)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - (self.view.frame.height * collectionHeightFactor)))
        
        let collectionRect = CGRectMake(0, self.imageView.frame.maxY, self.view.frame.width, self.view.frame.height - self.imageView.frame.height)
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.scrollDirection = scrollDirection
        
        self.collectionView = UICollectionView(frame: collectionRect, collectionViewLayout: flowLayout)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.registerClass(CollectionCustom.self, forCellWithReuseIdentifier: "cell")
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        for x in 0 ..< fetchResult.count {
            if let asset = fetchResult.objectAtIndex(x) as? PHAsset {
                assetArray.append(asset)
            }
        }
        
        self.view.addSubview(imageView)
        self.view.addSubview(collectionView)
    }
    
    
    func startCroppingSelectedImage() {
        
        if selectedImage == nil {
            return
        }
        
        if type == nil {
            type = .Profile
            
            debugPrint("Error: Picture type of collection is nil. Setting as profile. Please fix this problem, as it can cause severe problems.")
        }
        
        
        if type == .Event {
            croppingView = PictureCroppingView(frame: self.view.frame, image: selectedImage!, croppingType: .Event)
        }
            
        else {
            croppingView = PictureCroppingView(frame: self.view.frame, image: selectedImage!, croppingType: .Profile)
        }
        
        
        
        
        croppingView.layer.zPosition = 3
        croppingView.delegate = self
        self.view.addSubview(croppingView)
        
    }
    
    func cancelCollectionSelection() {
        selectedImage = nil
        delegate?.finishedSelectingImage(selectedImage)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (self.assetArray.count)
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(self.view.frame.height * collectionHeightFactor, self.view.frame.height * collectionHeightFactor)
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionCustom
        
        cell.frame.size.height = self.view.frame.height * collectionHeightFactor
        cell.frame.size.width = cell.frame.width
        
        cell.imageView.frame.size = cell.frame.size
        
        let asset = assetArray[indexPath.row]
        
        let options = PHImageRequestOptions()
        options.version = .Current
        options.deliveryMode = .HighQualityFormat
        options.resizeMode = .Exact
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: cell.frame.size, contentMode: PHImageContentMode.AspectFill, options:options) { (image:UIImage?, info:[NSObject : AnyObject]?) -> Void in
            
            if image != nil {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let asset = assetArray[indexPath.row]
        
        let options = PHImageRequestOptions()
        options.version = .Current
        options.deliveryMode = .HighQualityFormat
        
        let size = CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight))
        
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode: PHImageContentMode.AspectFill, options:options) { (image:UIImage?, info:[NSObject : AnyObject]?) -> Void in
            
            if image != nil {
                self.imageView.image = image
                self.selectedImage = image
            }
        }
    }
    
    func finishedCroppingImage(image:UIImage) {
        selectedImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.finishedSelectingImage(selectedImage)
    }
    
    func croppingCanceled() {
        croppingView.removeFromSuperview()
    }
}