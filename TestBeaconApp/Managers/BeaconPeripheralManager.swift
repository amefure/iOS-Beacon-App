//
//  BeaconPeripheralManager.swift
//  TestBeaconApp
//
//  Created by t&a on 2024/08/14.
//

import CoreLocation
import CoreBluetooth

class BeaconPeripheralManager: NSObject, CLLocationManagerDelegate {
    
    private var localBeacon : CLBeaconRegion!
    private var beaconPeripheralData: NSDictionary!
    private var peripheralManager: CBPeripheralManager!
    
    static let PROXIMITY_UUID = UUID(uuidString: "00000000-0000-1111-1111-111111111111")!
    static let MAJOR: CLBeaconMajorValue = 10
    static let MINOR: CLBeaconMinorValue = 30
    static let BEACON_ID = "BEACON"
    
    /// CLBeaconRegionを生成
    private func createBeaconRegion() -> CLBeaconRegion? {
        return CLBeaconRegion(
            uuid: BeaconPeripheralManager.PROXIMITY_UUID,
            major: BeaconPeripheralManager.MAJOR,
            minor: BeaconPeripheralManager.MINOR,
            identifier: BeaconPeripheralManager.BEACON_ID
        )
    }
    
    /// Beaconを起動
    public func startBeacon() {
        localBeacon = createBeaconRegion()!
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    /// Beaconを停止
    private func stopBeacon() {
        peripheralManager.stopAdvertising()
        localBeacon = nil
        beaconPeripheralData = nil
        peripheralManager = nil
    }
}

extension BeaconPeripheralManager: CBPeripheralManagerDelegate {
    /// Peripheralの状態が変化するタイミングで呼ばれる
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}
