//
//  CameraView.swift
//  HHacessorios
//
//  Created by William Alvelos on 28/05/16.
//  Copyright © 2016 Helga. All rights reserved.
//

import AVFoundation
import UIKit
import Photos

enum PictureType {
    case Profile
    case Event
}

protocol CameraViewDelegate : class {
    func startedCropping()
    func croppingCanceled()
    func finishedCroppingWithImage(image:UIImage)
    func finishedVideoData(data:NSData)
}

class CameraView: UIView, UIScrollViewDelegate, CroppingDelegate, AVCaptureFileOutputRecordingDelegate {
    
    var backgroundRecordingID:UIBackgroundTaskIdentifier!
    
    var videoData:NSData?
    
    let maskWidthFactor:CGFloat = 0.95
    
    var isRecordingVideo = false
    weak var delegate:CameraViewDelegate?
    var isFrontCamera:Bool!
    var captureSession = AVCaptureSession()
    var frontCaptureInput:AVCaptureDeviceInput?
    var flashState:AVCaptureFlashMode!
    var backCaptureInput:AVCaptureDeviceInput?
    var cameraLayer:AVCaptureVideoPreviewLayer?
    var stillImageOutput:AVCaptureStillImageOutput?
    var videoOutput:AVCaptureMovieFileOutput?
    var alertLabel:UILabel!
    var alertTimer:NSTimer!
    var croppingView:PictureCroppingView?
    var isPreviewing:Bool!
    var type:PictureType?
    
    convenience init(frame: CGRect, type:PictureType?) {
        self.init()
        
        self.type = type
        self.frame = frame
        isPreviewing = false
        
        alertLabel = UILabel(frame: CGRectMake(0.0, 0.0, self.frame.width * 0.5, self.frame.height / 14.0))
        alertLabel.textColor = Colors.Braco
        alertLabel.backgroundColor = Colors.Rosa
        alertLabel.alpha = 0.0
        alertLabel.textAlignment = NSTextAlignment.Center
        alertLabel.layer.cornerRadius = alertLabel.frame.height / 2
        alertLabel.center = self.center
        alertLabel.layer.masksToBounds = true
        
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            
            if device.hasMediaType(AVMediaTypeVideo) {
                
                if device.position == AVCaptureDevicePosition.Back {
                    do {
                        backCaptureInput = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    } catch _ {
                        backCaptureInput = nil
                    }
                }
                    
                else if device.position == AVCaptureDevicePosition.Front {
                    do {
                        frontCaptureInput = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    } catch _ {
                        frontCaptureInput = nil
                    }
                }
            }
        }
        
        
        if frontCaptureInput != nil {
            isFrontCamera = true
            captureSession.addInput(frontCaptureInput)
        }
            
        else if backCaptureInput != nil {
            //debugPrint("Failed to find the front capture device. Using the back device...")
            captureSession.addInput(backCaptureInput)
            isFrontCamera = false
        }
            
        else {
            //debugPrint("Failed to find the front capture device. Using the back device...")
            //debugPrint("Failed to find the back capture device. Camera view failed.")
            
            return
        }
        
        flashState = AVCaptureFlashMode.Off
        
        //Config the camera
        do {
            try backCaptureInput!.device.lockForConfiguration()
            
            if backCaptureInput!.device.isFlashModeSupported(.Auto) {
                flashState = AVCaptureFlashMode.Auto
                backCaptureInput!.device.flashMode = AVCaptureFlashMode.Auto
            }
            
            if backCaptureInput!.device.isTorchModeSupported(.Auto) {
                backCaptureInput!.device.torchMode = .Auto
            }
            
            if backCaptureInput!.device.isFocusModeSupported(.ContinuousAutoFocus) {
                backCaptureInput!.device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
            }
            
            backCaptureInput!.device.unlockForConfiguration()
            
        } catch _ {
            debugPrint("Failed to configure the capture device.")
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        videoOutput = AVCaptureMovieFileOutput()
        captureSession.addOutput(videoOutput)
        
        cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraLayer!.frame = self.frame
        
        self.layer.addSublayer(cameraLayer!)
        
        debugPrint(cameraLayer!.frame)
        
        self.addSubview(alertLabel)
        
        captureSession.startRunning()
    }
    
    //MARK: Camera functions
    func stopCameraSession() {
        captureSession.stopRunning()
    }
    
    func changeFlashState() {
        
        debugPrint(cameraLayer!.frame)
        
        if isFrontCamera == false {
            
            var torchState:AVCaptureTorchMode
            
            if flashState == .Auto || flashState == .Off {
                flashState = .On
                torchState = .On
                alertLabel.text = NSLocalizedString("flash_on", comment: "")
            }
                
            else {
                flashState = .Off
                torchState = .Off
                alertLabel.text = NSLocalizedString("flash_off", comment: "")
            }
            
            do {
                try backCaptureInput!.device.lockForConfiguration()
                
                if backCaptureInput!.device.isFlashModeSupported(flashState) {
                    backCaptureInput!.device.flashMode = flashState
                }
                    
                else {
                    flashState = .Off
                    alertLabel.text = NSLocalizedString("flash_invalid", comment: "")
                }
                
                if backCaptureInput!.device.isTorchModeSupported(torchState) {
                    backCaptureInput!.device.torchMode = torchState
                }
                
                backCaptureInput!.device.unlockForConfiguration()
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.alertLabel.alpha = 0.7
                })
                
                alertTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CameraView.hideAlert), userInfo: nil, repeats: false)
                
            } catch _ {
                //debugPrint("Failed to configure the capture device.")
            }
        }
    }
    
    func changeCamera() {
        
        captureSession.beginConfiguration()
        
        
        if isFrontCamera == true {
            captureSession.removeInput(frontCaptureInput)
            captureSession.addInput(backCaptureInput)
        }
            
        else {
            captureSession.removeInput(backCaptureInput)
            captureSession.addInput(frontCaptureInput)
        }
        
        isFrontCamera = !isFrontCamera
        
        captureSession.commitConfiguration()
    }
    
    func startRecordingVideo() {
        
        //backgroundRecordingID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let outputPath = "\(documentsPath)/output.mov"
        let outputFileUrl = NSURL(fileURLWithPath: outputPath)
        
        videoOutput?.startRecordingToOutputFileURL(outputFileUrl, recordingDelegate: self)
    }
    
    func stopRecordingVideo() {
        
        videoOutput?.stopRecording()
    }
    
    
    func takePicture() {
        
        stillImageOutput!.captureStillImageAsynchronouslyFromConnection(stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo)) { (buffer:CMSampleBuffer!, error:NSError!) -> Void in
            
            if error == nil {
                if buffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    
                    if let image = UIImage(data: imageData) {
                        self.startCroppingWithMask(image)
                    }
                }
            }
            
        }
    }
    
    private func startCroppingWithMask(image:UIImage) {
        
        var photo:UIImage
        
        if isFrontCamera == true {
            photo = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.LeftMirrored)
        }
            
        else {
            photo = image
        }
        
        if type != nil {
            if type == .Profile {
                
                croppingView = PictureCroppingView(frame: self.frame, image: photo, croppingType:.Profile)
            }
                
            else if type == .Event {
                croppingView = PictureCroppingView(frame: self.frame, image: photo, croppingType:.Event)
            }
            
            croppingView!.delegate = self
            
            self.addSubview(croppingView!)
            
            delegate?.startedCropping()
            captureSession.stopRunning()
            isPreviewing = true
        }
            
        else {
            //debugPrint("Error: This CameraView has been instanced without the camera type. Please review this in your code and fix it.")
            
        }
        
    }
    
    //MARK: Hide alert timer
    func hideAlert() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.alertLabel.alpha = 0.0
        }
    }
    
    //MARK: Cropping functions for buttons
    func finishCropping() {
        
        if isPreviewing == true {
            croppingView!.finishCropping()
        }
        
    }
    
    func cancelCropping() {
        
        if isPreviewing == true {
            
            croppingView?.removeFromSuperview()
            captureSession.startRunning()
            
            isPreviewing = false
        }
    }
    
    //MARK: Picture Cropping Delegate
    func finishedCroppingImage(image:UIImage) {
        delegate?.finishedCroppingWithImage(image)
    }
    
    func croppingCanceled() {
        cancelCropping()
        delegate?.croppingCanceled()
    }
    
    //MARK: Capture Video Output Delegate
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        
        isRecordingVideo = false
        
        if error != nil {
            //debugPrint(error)
        }
            
        else {
            
            videoData = NSData(contentsOfURL: outputFileURL)
            
            delegate?.finishedVideoData(videoData!)
        }
    }
    
    @available(iOS 9.0, *)
    func saveVideoOnGallery() {
        
        if videoData == nil {
            return
        }
        
        let outputFileURL = NSURL(fileURLWithPath: String(data: videoData!, encoding: NSUTF8StringEncoding)!)
        
        PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) -> Void in
            
            if status == .Authorized {
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                    
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    
                    let request = PHAssetCreationRequest.creationRequestForAsset()
                    request.addResourceWithType(.Video, fileURL: outputFileURL, options: options)
                    
                    }, completionHandler: { (bool:Bool, error:NSError?) -> Void in
                        
                })
            }
                
            else {
                //debugPrint("No access to camera .-.")
                
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(outputFileURL)
                    
                } catch {
                    debugPrint("Failed to remove video.")
                }
            }
        })
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        
        isRecordingVideo = true
        
    }
}