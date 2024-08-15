//
//  TestBeaconAppApp.swift
//  TestBeaconApp
//
//  Created by t&a on 2024/08/14.
//

import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let beaconManager = BeaconPeripheralManager.shared
        beaconManager.startBeacon()
        return true
    }

}


@main
struct TestBeaconAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
