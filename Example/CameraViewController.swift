//
//  CameraViewController.swift
//  HHacessorios
//
//  Created by William Alvelos on 28/05/16.
//  Copyright © 2016 Helga. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol CameraDelegate: class {
    func getImageFinished(image: UIImage)
    func getVideoFinished(data:NSData)
    func unauthorizedAccess()
}

class CameraViewController: UIViewController, CameraViewDelegate, CollectionDelegate, UIGestureRecognizerDelegate{
    
    private let holdTime = 0.4
    private let recordLimit = 15.0
    
    var recordTimer:NSTimer?
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var takeButton: UIButton!
    
    weak var delegate: CameraDelegate?
    var finishedImage:UIImage?
    var isCropping:Bool!
    var camera:CameraView!
    var type:PictureType?
    var collectionController:CollectionViewController?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);

    
    
    override func viewDidLayoutSubviews() {
        
        flashButton.layer.cornerRadius = flashButton.frame.height / 2.0
        closeButton.layer.cornerRadius = closeButton.frame.height / 2.0
        pictureButton.layer.cornerRadius = pictureButton.frame.height / 2.0
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2.0
        takeButton.layer.cornerRadius = takeButton.frame.height / 2.0
        
        takeButton.layer.masksToBounds = true
        cameraButton.layer.masksToBounds = true
        pictureButton.layer.masksToBounds = true
        closeButton.layer.masksToBounds = true
        flashButton.layer.masksToBounds = true
        
        cameraButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        flashButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        
        takeButton.layer.borderWidth = takeButton.frame.height / 14.0
        takeButton.layer.borderColor = Colors.Rosa.CGColor
    }
    
    func buttonTouchDown() {
        recordTimer = NSTimer.scheduledTimerWithTimeInterval(holdTime, target: self, selector: #selector(CameraViewController.shouldStartRecording), userInfo: nil, repeats: false)
    }
    
    func buttonTouchDragExit() {
        if recordTimer != nil {
            
            recordTimer!.invalidate()
            recordTimer = nil
        }
        
        if camera.isRecordingVideo == true {
            shouldStopRecording()
        }
    }
    
    func shouldStartRecording() {
        camera.startRecordingVideo()
        
        recordTimer = NSTimer.scheduledTimerWithTimeInterval(recordLimit, target: self, selector: #selector(CameraViewController.shouldStopRecording), userInfo: nil, repeats: false)
        
        cameraButton.hidden = true
        pictureButton.hidden = true
        closeButton.hidden = true
        flashButton.hidden = true
    }
    
    func shouldStopRecording() {
        
        if recordTimer != nil {
            
            recordTimer!.invalidate()
            recordTimer = nil
        }
        
        cameraButton.hidden = false
        pictureButton.hidden = false
        closeButton.hidden = false
        flashButton.hidden = false
        
        camera.stopRecordingVideo()
        
        //@@@@ AM @@@@@ temporarily dismiss the view when the video is done recording, still needing this view FELIPE
    }
    
    func startCameraWithType(type:PictureType!) {
        
        self.type = type
        
        isCropping = false
        
        debugPrint(self.view.frame)
        
        camera = CameraView(frame: self.view.frame, type: self.type)
        camera.delegate = self
        
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized
        {
            startCamera()
        }
            
        else
        {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    DispatcherManager.runOnMainThread({ () -> () in
                        self.startCamera()
                    })
                }
                else
                {
                    DispatcherManager.runOnMainThread({ () -> () in
                        debugPrint("No access granted for camera.")
                        self.delegate?.unauthorizedAccess()
                    })
                }
            });
        }
        
        
        
    }
    
    private func startCamera() {
        
        takeButton.addTarget(self, action: #selector(CameraViewController.buttonTouchDown), forControlEvents: .TouchDown)
        takeButton.addTarget(self, action: #selector(CameraViewController.buttonTouchDragExit), forControlEvents: .TouchDragExit)
        
        self.view.addSubview(camera)
        self.view.sendSubviewToBack(camera)
        
        getLastImageFromUser()
    }
    
    
    func getLastImageFromUser() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            debugPrint(fetchResult.count)
            
            if let lastAsset = fetchResult.lastObject as? PHAsset {
                
                let options = PHImageRequestOptions()
                //options.resizeMode = .Exact
                options.version = .Current
                options.deliveryMode = .HighQualityFormat
                
                PHImageManager.defaultManager().requestImageForAsset(lastAsset, targetSize: CGSizeMake(100, 100), contentMode: PHImageContentMode.AspectFill, options:options) { (image:UIImage?, info:[NSObject : AnyObject]?) -> Void in
                    
                    if image != nil {
                        self.pictureButton.setImage(image, forState: UIControlState.Normal)
                    }
                    
                }
            }
                
            else {
                debugPrint("Failed to get the pictures on the camera roll.")
            }
        }
            
        else {
            debugPrint("There is no picture on the camera roll.")
        }
    }
    
    
    @IBAction func flashHandler(sender: UIButton) {
        
        camera.changeFlashState()
        
        if camera.flashState == .On || camera.flashState == .Auto {
            sender.setImage(UIImage(named: "icon_enable_flash"), forState: UIControlState.Normal)
        }
            
        else {
            sender.setImage(UIImage(named: "icon_no_flash"), forState: UIControlState.Normal)
        }
    }
    
    
    @IBAction func closeHandler(sender: UIButton) {
        
        camera.stopCameraSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cameraHandler(sender: UIButton) {
        camera.changeCamera()
        
        if camera.isFrontCamera == true {
            sender.setImage(UIImage(named: "icon_pic_selfie"), forState: UIControlState.Normal)
        }
            
        else {
            sender.setImage(UIImage(named: "icon_pic_front"), forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func picHandler(sender: UIButton) {
        
        collectionController = CollectionViewController()
        collectionController?.delegate = self
        collectionController?.type = self.type
        self.presentViewController(collectionController!, animated: true, completion: nil)
    }
    
    @IBAction func takeHandler(sender: UIButton) {
        
        if camera.isRecordingVideo == true {
            shouldStopRecording()
        }
            
        else {
            camera.takePicture()
            
            if recordTimer != nil {
                
                recordTimer!.invalidate()
                recordTimer = nil
            }
        }
    }
    
    
    func finishedCroppingWithImage(image: UIImage) {
        
        //IMAGE HAS SUCCESFULLY BEEN CROPPED
        finishedImage = image
        delegate?.getImageFinished(finishedImage!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startedCropping() {
        isCropping = true
        
        closeButton.hidden = true
        takeButton.hidden = true
        cameraButton.hidden = true
        flashButton.hidden = true
        pictureButton.hidden = true
    }
    
    func croppingCanceled() {
        isCropping = false
        
        closeButton.hidden = false
        takeButton.hidden = false
        cameraButton.hidden = false
        flashButton.hidden = false
        pictureButton.hidden = false
    }
    
    func finishedSelectingImage(image:UIImage?) {
        
        if image != nil {
            finishedCroppingWithImage(image!)
        }
    }
    
    func finishedVideoData(data:NSData) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.getVideoFinished(data)
    }
    
}
