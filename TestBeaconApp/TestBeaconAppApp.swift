//
//  TestBeaconAppApp.swift
//  TestBeaconApp
//
//  Created by t&a on 2024/08/14.
//

import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // ペリフェラル(Beacon発信側)
        // let beaconPeripheralManager = BeaconPeripheralManager.shared
        // beaconPeripheralManager.startBeacon()
        
        // セントラル(Beacon受信側)
        let beaconCentralManager = BeaconCentralManager.shared
        beaconCentralManager.startMonitoring()
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
