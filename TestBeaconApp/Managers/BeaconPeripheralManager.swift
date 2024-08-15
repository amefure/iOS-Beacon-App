//
//  BeaconPeripheralManager.swift
//  TestBeaconApp
//
//  Created by t&a on 2024/08/14.
//

import CoreLocation
import CoreBluetooth

class BeaconPeripheralManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = BeaconPeripheralManager()
    
    private var beaconRegion : CLBeaconRegion!
    private var beaconPeripheralData: NSDictionary!
    private var peripheralManager: CBPeripheralManager!
    
    static let PROXIMITY_UUID = UUID(uuidString: "00000000-0000-1111-1111-111111111111")!
    static let MAJOR: CLBeaconMajorValue = 10
    static let MINOR: CLBeaconMinorValue = 30
    static let BEACON_ID = "BEACON"
    
    /// CLBeaconRegionを生成
    private func createBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(
            uuid: BeaconPeripheralManager.PROXIMITY_UUID,
            major: BeaconPeripheralManager.MAJOR,
            minor: BeaconPeripheralManager.MINOR,
            identifier: BeaconPeripheralManager.BEACON_ID
        )
    }
    
    /// Beaconをセットアップしペリフェラルとして登録
    public func startBeacon() {
        beaconRegion = createBeaconRegion()
        // Beaconとして発信するために必要なデータ（アドバタイズメントデータ）を生成
        beaconPeripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        // デバイスをBluetoothペリフェラル（信号を送信する側）として動作開始
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    /// Beaconを停止
    private func stopBeacon() {
        peripheralManager.stopAdvertising()
        beaconRegion = nil
        beaconPeripheralData = nil
        peripheralManager = nil
    }
}

extension BeaconPeripheralManager: CBPeripheralManagerDelegate {
    /// Peripheralの状態が変化するタイミングで呼ばれる
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("ブロードキャスト開始")
            // ペリフェラルの電源がONになったタイミングでブロードキャスト開始
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}
