//
//  GeolocationTestViewController.swift
//  Iniciacao
//
//  Created by Marjorie Alvelos on 2015-09-06.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import CoreMotion

class AnimalViewController: UIViewController {
    
    
    @IBOutlet var imagem: UIImageView!
    
    @IBOutlet var Camera: UIImageView!
    
    @IBOutlet var pegada: UIImageView!
    
    @IBOutlet var cameraButton: UIButton!
    
    @IBOutlet var MapaButton: UIButton!
    
    var titleText: String?
    
    var animal = Animal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBarHidden = false

        self.imagem.image = self.animal.imageCarta
        
//        self.navigationController?.title = titleText!;
        
        self.colorNavigation(self.titleText!)
        

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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBar.topItem!.title = self.animal.nome;
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(AnimalViewController.screenShotMethod))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @IBAction func test(sender: AnyObject) {
        let vc: UIViewController = UIStoryboard(name: "LocationBasedAR", bundle: nil).instantiateViewControllerWithIdentifier("LocationBasedAR")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    @IBAction func camera(sender: AnyObject) {
        
        let vc: UIViewController = UIStoryboard(name: "InteractiveFurniture", bundle: nil).instantiateViewControllerWithIdentifier("InteractiveFurniture")
        self.presentViewController(vc, animated: true, completion: nil)
        
//        UIViewController* vc = [[UIStoryboard storyboardWithName:tutorialId bundle:nil] instantiateInitialViewController];
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:vc animated:YES completion:nil];
        
        
    }
    @IBAction func cartas(sender: AnyObject) {
        let vc: UIViewController = UIStoryboard(name: "LocationBasedAR", bundle: nil).instantiateViewControllerWithIdentifier("LocationBasedAR")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func actionBuscaCarta(sender: AnyObject) {
        
        
    }
    
    
    func colorNavigation(text:String){
        if(text == "Mamíferos"){
            self.navigationController?.navigationBar.barTintColor = Mamifero.Fundo
        }else if(text == "Aves"){
            self.navigationController?.navigationBar.barTintColor = Aves.Fundo
        }else if(text == "Anfíbios"){
            self.navigationController?.navigationBar.barTintColor = Anfibios.Fundo
        }else if(text == "Répteis"){
            self.navigationController?.navigationBar.barTintColor = Repteis.Fundo
        }else if(text == "Aracnídeos"){
            self.navigationController?.navigationBar.barTintColor = Aracnideos.Fundo
        }
        
    }
    
    @IBAction func voltarAction(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
