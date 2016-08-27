//
//  CameraDefault.swift
//  Zoorocaba
//
//  Created by William Alvelos on 04/06/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

class CameraDefaultViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stickerView: UIImageView!
    

    @IBOutlet var animaisStickerView: UIView!
    
    var arrayImages = Array<UIImage>()
    var indexImages = 0;
    var newMedia: Bool?
    var finish: Bool?

    var buttonEvent: Bool?

    var showStickers: Bool?

    @IBOutlet var btn2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.userInteractionEnabled = true;
        self.stickerView.userInteractionEnabled = true;
        
        imageView.image = UIImage(named: "menu_camera.jpg");

        finish = false
        
        buttonEvent = false
        
        showStickers = false
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(CameraDefaultViewController.pinchGestureRecognizer(_:)))
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CameraDefaultViewController.handlePan(_:)))
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(CameraDefaultViewController.rotate(_:)))
        
        
        self.stickerView.addGestureRecognizer(gesture)
        self.stickerView.addGestureRecognizer(pan)
        self.stickerView.addGestureRecognizer(rotate)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CameraDefaultViewController.right(_:)))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.imageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CameraDefaultViewController.left(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.imageView.addGestureRecognizer(swipeLeft)
        
        
        self.arrayImages.append(UIImage(named: "leao")!);
        self.arrayImages.append(UIImage(named: "afrodite")!);
        self.arrayImages.append(UIImage(named: "lito")!);
        self.arrayImages.append(UIImage(named: "tico")!);
        
        self.arrayImages.append(UIImage(named: "sticker_macaco1")!);
        self.arrayImages.append(UIImage(named: "sticker_macaco2")!);
        self.arrayImages.append(UIImage(named: "sticker_macaco3")!);
        
        self.arrayImages.append(UIImage(named: "sticker_leao1")!);
        self.arrayImages.append(UIImage(named: "sticker_leao2")!);
        self.arrayImages.append(UIImage(named: "sticker_leao3")!);
        
        self.arrayImages.append(UIImage(named: "sticker_avestruz1")!);
        self.arrayImages.append(UIImage(named: "sticker_avestruz2")!);
        self.arrayImages.append(UIImage(named: "sticker_avestruz3")!);
        
        gesture.delegate = self;
        pan.delegate = self;
        rotate.delegate = self;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.barTintColor = Zoorocaba.Cor
    }
    
    
    func rotate(recognizer: UIRotationGestureRecognizer){
        recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        
        recognizer.rotation = 0
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
                                          y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func pinchGestureRecognizer(recognizer:UIPinchGestureRecognizer){
        
        let state :UIGestureRecognizerState = recognizer.state;
        
        if (state == .Began || state == .Changed)
        {
            //let translation = recognizer.translationInView(recognizer.view)
            //recognizer.view?.transform
            
            recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
            //recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            recognizer.scale = 1
            
        }
        
    }

    
    func right(recognizer:UIPinchGestureRecognizer){
        if(self.indexImages > 0){
            self.indexImages -= 1;
        }
        if(finish == true){
            self.stickerView.image = self.arrayImages[self.indexImages]
        }
    }
    func left(recognizer:UIPinchGestureRecognizer){
        if(self.indexImages < self.arrayImages.count - 1){
            self.indexImages += 1;
        }
        if(finish == true){
            self.stickerView.image = self.arrayImages[self.indexImages]
    
        }
    }
    
    func useCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = true
        }
    }

    
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = true
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(finish == true){
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(CameraDefaultViewController.screenShotMethod))
            self.navigationItem.rightBarButtonItem = button
        }
    }
    
    
    func screenShotMethod() {
        
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        let alertController : UIAlertController = UIAlertController(title: "Sucesso", message: "Foto salva na galeria com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if(mediaType == (kUTTypeImage as String)){
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
            finish = true
            
            self.stickerView.image = self.arrayImages[0];
            
            self.btn1.hidden = true
            self.btn2.hidden = true
            
            
            let bottomBar = UIView(frame: CGRect(x: 0, y: 555, width: 375, height: 50))
            
            let buttonAnimal = UIButton(frame: CGRect(x: 320, y: 5, width: 40, height: 40))
                
            buttonAnimal.setImage(UIImage(named: "icon_stickers"), forState: UIControlState.Normal)
            
            buttonAnimal.addTarget(self, action: #selector(CameraDefaultViewController.showButtons), forControlEvents: UIControlEvents.TouchUpInside)
            
            bottomBar.backgroundColor = Zoorocaba.Cor

            bottomBar.addSubview(buttonAnimal)
            
            self.view.addSubview(bottomBar)
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(CameraDefaultViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType == (kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    @IBAction func animal1(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[5]

    }
    
    @IBAction func animal2(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[6]

    }
    @IBAction func animal3(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[9]

    }
    @IBAction func animal4(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[4]

    }
    @IBAction func animal5(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[8]

    }
    @IBAction func animal6(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[10]

    }
    @IBAction func animal7(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[7]

    }
    @IBAction func animal8(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[11]

    }
    @IBAction func animal9(sender: AnyObject) {
        StickerButtonHidden()
        
        self.stickerView.image = self.arrayImages[12]
        
    }
    
    func StickerButtonHidden(){
        if(showStickers == true){ showStickers = false }
        else{ showStickers = true }
        
        animaisStickerView.hidden = showStickers!
    }
    
    func showButtons(){
        
//        if(buttonEvent == false){
        
            if(showStickers == true){ showStickers = false }
            else{ showStickers = true }
            
            animaisStickerView.hidden = showStickers!
            
            animaisStickerView.backgroundColor = Zoorocaba.Cor
            
            animaisStickerView.alpha = 0.9
            buttonEvent = true
//        }else{
//            buttonEvent = false
//        }
//        
        
    }
    
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                                       completion: nil)
        }
    }
    
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = false
        }
    }
    
    
}
