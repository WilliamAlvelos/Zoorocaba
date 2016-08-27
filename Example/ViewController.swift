//
//  ViewController.swift
//  Iniciacao
//
//  Created by Marjorie Alvelos on 2015-09-06.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pageTitles = ["Mamíferos","Aves","Anfíbios","Répteis","Aracnídeos"]
    var images = ["long3.png","long4.png","long1.png","long2.png"]
    var count = 0
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    @IBAction func swipeLeft(sender: AnyObject) {
        print("SWipe left")
    }
    @IBAction func swiped(sender: AnyObject) {
        
        self.pageViewController.view .removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
    
    func reset() {
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        

        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.navigationController!.didMoveToParentViewController(self)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
    }
    

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! PageContentViewController).pageIndex!
        
    index++
        
    if(index == self.pageTitles.count){
    return nil
    }
    return self.viewControllerAtIndex(index)
    
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! PageContentViewController).pageIndex!
    if(index == 0){
    return nil
    }
        
        
    index--
    return self.viewControllerAtIndex(index)
    
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
    if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
    return nil
    }
    let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
    
//    pageContentViewController.imageName = self.images[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        self.colorNavigation(self.pageTitles[index])
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
        func colorNavigation(text:String){
    
            if(text == "Mamíferos"){
                self.navigationController?.navigationBar.barTintColor = Mamifero.Caracteristicas

                self.view.backgroundColor = Mamifero.Fundo
            }else if(text == "Aves"){
                self.navigationController?.navigationBar.barTintColor = Aves.Caracteristicas
                self.view.backgroundColor = Aves.Fundo
            }else if(text == "Anfíbios"){
                self.navigationController?.navigationBar.barTintColor = Anfibios.Caracteristicas
                self.view.backgroundColor = Anfibios.Fundo
            }else if(text == "Répteis"){
                self.navigationController?.navigationBar.barTintColor = Repteis.Caracteristicas
                self.view.backgroundColor = Repteis.Fundo
            }else if(text == "Aracnídeos"){
                self.navigationController?.navigationBar.barTintColor = Aracnideos.Caracteristicas
                self.view.backgroundColor = Aracnideos.Fundo
            }
            
        }


}
