//
//  aviator_gameApp.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
 
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
}

@main
struct aviator_gameApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
