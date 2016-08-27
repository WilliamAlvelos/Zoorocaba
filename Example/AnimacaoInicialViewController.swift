//
//  AnimacaoInicialViewController.swift
//  Zoorocaba
//
//  Created by William Alvelos on 29/06/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

import Foundation

class AnimacaoInicialViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animate()
    }
    
    func animate(){
        var imgListArray = [UIImage]()
        for countValue in 22...175
        {
            var strImageName : String = "teaser_00\(countValue).png"
            
            if(countValue < 100){
                strImageName = "teaser_000\(countValue).png"
            }
            
            let image  = UIImage(named:strImageName)
            imgListArray.append(image!)
        }
    
        self.imageView.animationImages = imgListArray;
        self.imageView.animationDuration = 7.0
        self.imageView.startAnimating()
        
        self.performSelector(#selector(AnimacaoInicialViewController.afterAnimation), withObject: nil, afterDelay: imageView.animationDuration)
    }
    
    func afterAnimation() {
        imageView.stopAnimating()
        
        imageView.image = UIImage(named:"teaser_24.png")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("iniciaApp") as! UINavigationController
        self.presentViewController(vc, animated: false, completion: nil)

    }
}