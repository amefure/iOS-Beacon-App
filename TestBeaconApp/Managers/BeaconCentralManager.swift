//
//  BeaconCentralManager.swift
//  TestBeaconApp
//
//  Created by t&a on 2024/08/15.
//

import UIKit
import CoreLocation


class BeaconCentralManager: NSObject {
    
    static let shared = BeaconCentralManager()
    
    // CLLocationManagerインスタンスを作成
    var locationManager: CLLocationManager!
    private var beaconRegion : CLBeaconRegion!
    private var beaconIdentityConstraint : CLBeaconIdentityConstraint!
    
    // 受信するBeaconのUUID、メジャー、マイナーを指定
    static let PROXIMITY_UUID = UUID(uuidString: "00000000-0000-1111-1111-111111111111")!
    static let BEACON_ID = "BEACON"
    
    /// CLBeaconRegionを生成
    private func createBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(
            uuid: BeaconCentralManager.PROXIMITY_UUID,
            identifier: BeaconCentralManager.BEACON_ID
        )
    }
    /// CLBeaconIdentityConstraintを生成
    private func createBeaconIdentityConstraint() -> CLBeaconIdentityConstraint {
        return CLBeaconIdentityConstraint(
            uuid: BeaconCentralManager.PROXIMITY_UUID
        )
    }
    
    public func startMonitoring() {
        // CLLocationManagerの初期化とデリゲートの設定
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 位置情報の使用許可を要求
        locationManager.requestWhenInUseAuthorization()
        
        // Beacon領域の設定
        beaconRegion = createBeaconRegion()
        // Beacon領域の設定
        beaconIdentityConstraint = createBeaconIdentityConstraint()
        
        // Beaconのモニタリングを開始
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }
    
}

extension BeaconCentralManager: CLLocationManagerDelegate {
    
    // Beacon領域内に入ったことを検知したときに呼ばれるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Beacon領域に入りました。")
    }
    //  Beacon領域内から出たことを検知したときに呼ばれるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Beacon領域から出ました。")
    }
    
    // Beacon情報を取得したときに呼ばれるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconIdentityConstraint: CLBeaconIdentityConstraint) {
        if let nearestBeacon = beacons.first {
            switch nearestBeacon.proximity {
            case .immediate:
                print("非常に近い距離にBeaconが検出されました。")
            case .near:
                print("近い距離にBeaconが検出されました。")
            case .far:
                print("遠い距離にBeaconが検出されました。")
            default:
                print("Beaconの距離を検出できません。")
            }
        }
        for beacon in beacons {
            print("UUID: \(beacon.uuid)")
            print("Major: \(beacon.major)")
            print("Minor: \(beacon.minor)")
            print("Proximity: \(beacon.proximity)")
        }
    }

    
    // 許可の状態が変更されたときに呼ばれるデリゲートメソッド
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            // Beaconのモニタリングを開始
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(satisfying: beaconIdentityConstraint)
        }
    }
}

