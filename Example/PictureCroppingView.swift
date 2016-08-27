//
//  PictureCroppingView.swift
//  HHacessorios
//
//  Created by William Alvelos on 28/05/16.
//  Copyright © 2016 Helga. All rights reserved.
//

import UIKit

enum CroppingType {
    case Profile
    case Event
}

protocol CroppingDelegate: class {
    func croppingCanceled()
    func finishedCroppingImage(image:UIImage)
}

class PictureCroppingView: UIView, UIScrollViewDelegate {
    
    var finishButton: UIButton!
    var cancelButton: UIButton!
    
    let maskWidthFactor:CGFloat = 0.8482
    let maskBorderFactor:CGFloat = 0.06933
    
    weak var delegate:CroppingDelegate?
    var scrollPreview:UIScrollView!
    var photoPreview:UIImageView!
    var maskPreview:UIImageView!
    var contentPreview:UIView!
    var type:CroppingType!
    
    convenience init(frame:CGRect, image:UIImage, croppingType:CroppingType) {
        
        self.init()
        
        self.frame = frame
        
        cancelButton = UIButton(frame: CGRectMake(10, self.frame.height - 30.0 - (self.frame.height * 0.09), self.frame.height * 0.09, self.frame.height * 0.09))
        
        finishButton = UIButton(frame: CGRectMake(self.frame.width - 10 - (self.frame.height * 0.09), cancelButton.frame.origin.y, cancelButton.frame.width, cancelButton.frame.height))
        
        cancelButton.addTarget(self, action: #selector(PictureCroppingView.cancelCropping), forControlEvents: UIControlEvents.TouchUpInside)
        finishButton.addTarget(self, action: #selector(PictureCroppingView.finishCropping), forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelButton.backgroundColor = Colors.Azul
        finishButton.backgroundColor = Colors.Azul
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        finishButton.layer.cornerRadius = finishButton.frame.height / 2
        
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        finishButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        
        cancelButton.setImage(UIImage(named: "icon_exit_camera"), forState: UIControlState.Normal)
        finishButton.setTitle(NSLocalizedString("ok", comment: ""), forState: UIControlState.Normal)
        
        finishButton.setTitleColor(Colors.Rosa, forState: UIControlState.Normal)
        
        self.layer.zPosition = 1
        type = croppingType
        startCroppingWithMask(image)
        
        self.addSubview(cancelButton)
        self.addSubview(finishButton)
    }
    
    override func layoutSubviews() {
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        finishButton.layer.cornerRadius = finishButton.frame.height / 2
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentPreview
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if type == .Event {
            return
        }
        
        let minimum = (scrollView.zoomScale - 1) * ((self.frame.width * maskWidthFactor) / 2)
        
        if scrollView.contentOffset.y < minimum {
            scrollView.contentOffset.y = minimum
        }
        
        let maximum = scrollView.contentSize.height - minimum - self.frame.height
        
        if scrollView.contentOffset.y > maximum {
            scrollView.contentOffset.y = maximum
        }
    }
    
    
    func startCroppingWithMask(photo:UIImage) {
        
        var maskImage:UIImage
        
        if type == .Profile {
            maskImage = UIImage(named: "profileMask")!
        }
            
        else {
            maskImage = UIImage(named: "eventMask.png")!
        }
        
        
        maskPreview = UIImageView(frame: CGRectMake(0, 0, self.frame.width, 0))
        maskPreview.frame.size.height = (maskImage.size.height / maskImage.size.width) * maskPreview.frame.width
        maskPreview.center = self.center
        maskPreview.image = maskImage
        maskPreview.alpha = 0.6
        
        if type != .Profile {
            maskPreview.alpha = 0.0
        }
        
        contentPreview = UIView(frame: CGRectMake(0, 0, self.frame.width, (self.frame.height * 2) - (self.frame.width * maskWidthFactor)))
        contentPreview.backgroundColor = UIColor.blackColor()
        
        photoPreview = UIImageView(image: photo)
        photoPreview.contentMode = UIViewContentMode.ScaleAspectFit
        photoPreview.frame.size.height = self.frame.size.height
        photoPreview.frame.size.width = self.frame.size.width
        photoPreview.center = contentPreview.center
        
        contentPreview.addSubview(photoPreview)
        
        scrollPreview = UIScrollView(frame: self.frame)
        scrollPreview.backgroundColor = UIColor.blackColor()
        
        scrollPreview.contentSize = contentPreview.frame.size
        scrollPreview.addSubview(contentPreview)
        scrollPreview.contentOffset.y = photoPreview.frame.origin.y
        scrollPreview.decelerationRate = 0.1
        
        photoPreview.center.y = scrollPreview.contentSize.height / 2
        
        
        scrollPreview.minimumZoomScale = 1.0
        scrollPreview.maximumZoomScale = 5.0
        scrollPreview.delegate = self
        
        if type == .Event {
            scrollPreview.contentSize = self.frame.size
            scrollPreview.contentOffset = CGPointZero
            
            photoPreview.frame.size = self.frame.size
            photoPreview.frame.origin = CGPointZero
            contentPreview.frame.size = self.frame.size
            contentPreview.frame.origin = CGPointZero
        }
        
        self.addSubview(scrollPreview)
        self.addSubview(maskPreview)
        
    }
    
    func finishCropping() {
        
        maskPreview.removeFromSuperview()
        cancelButton.removeFromSuperview()
        finishButton.removeFromSuperview()
        
        //Snapshot of view
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        self.layer.renderInContext(context)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var rect:CGRect
        
        if type == .Profile {
            rect = CGRectMake(
                (self.frame.width - self.frame.width * maskWidthFactor) / 2,
                (self.frame.height - self.frame.width * maskWidthFactor) / 2,
                self.frame.width * maskWidthFactor,
                self.frame.width * maskWidthFactor)
        }
            
        else {
            rect = CGRectMake(0, 0, self.frame.width, self.frame.height)
        }
        
        let reference = CGImageCreateWithImageInRect(snap.CGImage, rect)
        
        scrollPreview.removeFromSuperview()
        
        delegate?.finishedCroppingImage(UIImage(CGImage: reference!))
    }
    
    func cancelCropping() {
        delegate?.croppingCanceled()
    }
    
}
