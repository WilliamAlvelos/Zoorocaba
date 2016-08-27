//
//  StickerViewController.swift
//  Zoorocaba
//
//  Created by William Alvelos on 30/05/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

//
import Foundation
import UIKit

class stickerViewController: UIViewController, UIGestureRecognizerDelegate, CameraDelegate, CollectionDelegate{
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var resultView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.userInteractionEnabled = true;
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(stickerViewController.pinchGestureRecognizer(_:)))
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(stickerViewController.handlePan(_:)))
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(stickerViewController.rotate(_:)))
        
        
        self.imageView.addGestureRecognizer(gesture)
        self.imageView.addGestureRecognizer(pan)
        self.imageView.addGestureRecognizer(rotate)
        
        gesture.delegate = self;
        pan.delegate = self;
        rotate.delegate = self;
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func showCamera(sender: AnyObject) {
        let cam = TransitionManager.createViewController("CameraViewController") as! CameraViewController
        cam.delegate = self
        cam.startCameraWithType(.Event)
        self.presentViewController(cam, animated: true, completion: nil)
    }
    
    func showCollection() {
        let collectionController = CollectionViewController()
        collectionController.delegate = self
        collectionController.type = .Event
        self.presentViewController(collectionController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageFinished(image: UIImage){
        resultView.image = image
    }
    func getVideoFinished(data:NSData){
        
    }
    func unauthorizedAccess(){
    }
    
    func finishedSelectingImage(image:UIImage?){
        
    }
    
}

