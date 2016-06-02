//
//  NSUserDefault+isFirstLaunch.swift
//  JiYi
//
//  Created by Nohan Budry on 02.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    
    class func isFirstLaunch() -> Bool {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")  {
            
            return false
        }
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        return true
    }
}