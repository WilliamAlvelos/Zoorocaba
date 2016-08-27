//
//  TransitionManager.swift
//  HHacessorios
//
//  Created by William Alvelos on 28/05/16.
//  Copyright © 2016 Helga. All rights reserved.
//

import Foundation
import UIKit

class TransitionManager: NSObject {
    
    class func presentViewController(identifier: String, animated: Bool, view: UIViewController){
        let nextViewController = TransitionManager.createViewController(identifier)
        view.presentViewController(nextViewController, animated:animated, completion:nil)
    }
    
    class func createViewController(identifier:String)->UIViewController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier)
        return nextViewController
    }
    class func pushViewController(identifier: String, animated: Bool, view: UINavigationController){
        let nextViewController = TransitionManager.createViewController(identifier)
        view.pushViewController(nextViewController, animated: animated)
    }
    
}