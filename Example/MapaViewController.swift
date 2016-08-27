//
//  MapaViewController.swift
//  Iniciacao
//
//  Created by William Alvelos on 10/09/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit




class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchControllerDelegate{
    
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
    }
    
    @IBAction func scanner(sender: AnyObject) {
        
        let vc: UIViewController = UIStoryboard(name: "ContentTypes", bundle: nil).instantiateViewControllerWithIdentifier("ContentTypes")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = Zoorocaba.Cor
        
        self.navigationController?.navigationBar.barTintColor = Zoorocaba.Cor
        
        self.navigationController?.navigationBarHidden = true

        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    @IBAction func addAvestruz(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "avestruz")
        defaults.setBool(true, forKey: "sapo")
        defaults.setBool(true, forKey: "aranha")
        defaults.setBool(true, forKey: "iguana")
        defaults.setBool(true, forKey: "leao")

        defaults.synchronize()
        
    }
    

    
    @IBAction func mapaAction(sender: AnyObject) {
        
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        var view = mainStoryboard.instantiateViewControllerWithIdentifier("MapaViewController") as! SelecionarAnimalViewController
//        self.navigationController?.pushViewController(view, animated: true)
//        
    }
    
    
    
    @IBAction func removeAvestruz(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "avestruz")
        defaults.setBool(false, forKey: "sapo")
        defaults.setBool(false, forKey: "aranha")
        defaults.setBool(false, forKey: "iguana")
        defaults.setBool(false, forKey: "leao")
        defaults.synchronize()
    }
    
    
    func mapView(mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                
                return nil
                
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.canBecomeFirstResponder()
                pinView!.pinColor = .Purple
                
                
                annotation.coordinate
                
                
                
                let roleButton = UIButton(type: UIButtonType.Custom)
                
                roleButton.addTarget(self, action: "selectRole:", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                roleButton.frame.size.width = 44
                roleButton.frame.size.height = 44
                roleButton.setImage(UIImage(named: "main_seta"), forState: .Normal)
                
                
                
                //var rightButton :UIButton = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
                
                
                
                pinView!.rightCalloutAccessoryView = roleButton
                
                //                    var icon = UIImageView(image: UIImage(named: "teste.png"))
                //                    pinView!.leftCalloutAccessoryView = icon
                
            }
            else {
                pinView!.annotation = annotation
            }
            
            
            return pinView
    }

    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
//        var annView = view.annotation
//
//        let nextViewController = TransitionManager.creatView("PartidaTableViewController") as! PartidaTableViewController
//        var event = Event()
//        
//        
//        event.localizacao = Localizacao()
//        event.localizacao?.name = annView.title
//        
//        event.localizacao?.latitude = Float(annView.coordinate.latitude)
//        event.localizacao?.longitude = Float(annView.coordinate.longitude)
//        
//        nextViewController.event = event
//        
//        nextViewController.location = annView.coordinate
//        
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        
        
        //        annotation *annView = view.annotation;
        //        detailedViewOfList *detailView = [[detailedViewOfList alloc]init];
        //        detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        detailView.address = annView.address;
        //        detailView.phoneNumber = annView.phonenumber;
        //        [self presentModalViewController:detailView animated:YES];
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            //showActivity()
            
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.AuthorizedAlways:
                shouldIAllow = true
            default:
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            
            if (shouldIAllow == true) {
                // Start location services
                locationManager.startUpdatingLocation()
            }
            
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coord, 0, 0)
        
//        geoLocation = coord
//        
//        if(self.bool){
//            addPointsOfInterest("", name: "", location: geoLocation, pageToken: "")
//            self.bool = false
//        }
        mapView.setRegion(region, animated: true)
        
        mapView.userLocation.title = "VOCE"
        
    
    
    }
    

    
    
    
}