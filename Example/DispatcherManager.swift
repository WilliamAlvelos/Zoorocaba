//
//  DispatcherManager.swift
//  HHacessorios
//
//  Created by William Alvelos on 28/05/16.
//  Copyright © 2016 Helga. All rights reserved.
//

import Foundation

class DispatcherManager
{
    class func runOnMainThread(functionToRunOnMainThread: () -> ())
    {
        dispatch_async(dispatch_get_main_queue(), functionToRunOnMainThread)
    }
    class func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
}