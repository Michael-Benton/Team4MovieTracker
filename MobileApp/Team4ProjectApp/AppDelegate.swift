//
//  AppDelegate.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/13/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var user: AppUser?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window?.backgroundColor = UIColor.black
    
    let center  = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.sound, .alert, .badge]) {
      (granted, error) in
      if error == nil{
        DispatchQueue.main.async(execute: {
          UIApplication.shared.registerForRemoteNotifications()
        })
      }
    }
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print(token)
    
    print(deviceToken.description)
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
    }
    UserDefaults.standard.setValue(token, forKey: "ApplicationIdentifier")
    UserDefaults.standard.synchronize()
    
    
  }
  
}

