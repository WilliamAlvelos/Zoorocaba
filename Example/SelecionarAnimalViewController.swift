//
//  SelecionarAnimalViewController.swift
//  Zoorocaba
//
//  Created by William Alvelos on 11/04/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

import UIKit
import MapKit
import Darwin
import Foundation

class SelecionarAnimalViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var mapView: MKMapView!
    
    var coordinate: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()

    var charArray: Array<Coordenada> = [pontos.a, pontos.b, pontos.c,pontos.d, pontos.e];
    
    var viewDataAnimals :UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Zoorocaba.Cor
        self.viewDataAnimals = UIView(frame: CGRect(x: 50, y: 30, width: 300, height: 500))
        self.viewDataAnimals?.addSubview(UIImageView(image: UIImage(named: "img.leão")))
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true;
        
        let longTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SelecionarAnimalViewController.long(_:)))
        
        self.view.addGestureRecognizer(longTap)
        
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        self.locationManager.requestWhenInUseAuthorization();
        self.locationManager.startMonitoringSignificantLocationChanges();
        self.locationManager.startUpdatingLocation();
        self.coordinate = self.locationManager.location?.coordinate
        



    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Zoorocaba.Cor
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.delegate = self
        self.image.multipleTouchEnabled = true
        
        self.scrollView.scrollEnabled = true
        self.scrollView.minimumZoomScale = 3.0;
        self.scrollView.maximumZoomScale = 7.0;
        self.image.userInteractionEnabled = true
        
        self.view.backgroundColor = Zoorocaba.Cor
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelecionarAnimalViewController.test(_:))))
        self.scrollView.zoomScale = 4.0;

    }
    
    
    func long(sender: UILongPressGestureRecognizer){
        self.viewDataAnimals!.layer.cornerRadius = 80.3;
        self.viewDataAnimals!.clipsToBounds = true;
        self.view.addSubview(self.viewDataAnimals!)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.viewDataAnimals!.removeFromSuperview()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.viewDataAnimals!.removeFromSuperview()
    }

    func test(gesture: UIGestureRecognizer){
        let location = gesture.locationInView(self.image)
        self.viewDataAnimals!.removeFromSuperview()

        var localAnimal: Int32 = 0;
        if(location.x < 57.875 && location.x > 14.75 && location.y > 255.75 && location.y < 275.125){
            print("avestruz")
            localAnimal = Int32(101);
        }else{
            print(location)
            //esta fora da tela de camera
        }
        
        
        if(localAnimal != 0){
            let output: CInt = 0
            
            
            if(locationManager.location != nil){
                let x = Float(locationManager.location!.coordinate.latitude);
                let y = Float(locationManager.location!.coordinate.longitude);
                
                var min:Double = Double(INT_MAX);
                var r: Coordenada = Coordenada(x: 0, y: 0)
                var j: Int32 = 0
                var atual:Double = 0;
                
                for(var i = 0; i < self.charArray.count; i++){
                   
                    if(self.coordinate == nil){
                        print("erro")
                        return;
                    }else{
                        
                        atual = distancia((self.locationManager.location?.coordinate)!, ponto: self.charArray[i])
                    }
                    if(atual < min){
                        min = atual;
                        r = self.charArray[i];
                        j = Int32(i)
                    }
                }
                //SUPONDO QUE O AVESTRUZ ESTEJA NA PRACA 2
                
                var i: Int32 = GetInt(x, y, j, localAnimal)
                let arrayLocais = NSMutableArray()
                arrayLocais.addObject(Int(i))
                
                while(i != localAnimal){
                    i = GetInt(x, y, i-93, localAnimal)
                    arrayLocais.addObject(Int(i))
                }

                let a = defaults(name: arrayLocais)
                a.save(arrayLocais)
                
                
//                let a = Singleton().bananas = arrayLocais
                
                //antes de trocar a tela vai calcular a rota
                let vc: UIViewController = UIStoryboard(name: "LocationBasedAR", bundle: nil).instantiateViewControllerWithIdentifier("LocationBasedAR")
                vc.title = "101"
                self.presentViewController(vc, animated: true, completion: nil)
                //passa para a tela de camera
            }else{
                print("PORRA")
            }
        }
        
    }
    
    func distancia(local: CLLocationCoordinate2D, ponto: Coordenada)->Double{
        
        let LY:Double = Double(local.latitude);
        let LX:Double = Double(local.longitude);
        
        let PY:Double = Double(ponto.y);
        let PX:Double = Double(ponto.x);
        
        var result: Double = (PX-LX) * (PX-LX)
        result += (PY-LY) * (PY-LY)
        
        let total = sqrt(result);
        
        return total
    }



    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.image
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
