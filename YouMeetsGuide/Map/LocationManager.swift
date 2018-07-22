//
//  LocationManager.swift
//  YouMeetsGuide
//
//  Created by Ryou on 2018/07/21.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import FirebaseFirestore
class LocationManager: NSObject, CLLocationManagerDelegate {
    var locMng:CLLocationManager! = CLLocationManager()
    static var shared:LocationManager = {
        return LocationManager();
    }();
    func setup(){
        locMng = CLLocationManager()
        locMng.delegate = self
        locMng.requestWhenInUseAuthorization()
        locMng.requestAlwaysAuthorization()
        

    }
    func startUpdating(){
        locMng.startUpdatingLocation()
        locMng.startUpdatingHeading()
    }
    var player:AVAudioPlayer!
    func playSound(fileName:String){
        if UserDefaults.standard.bool(forKey: "sound-off") {
            return
        }
        let soundURL = Bundle.main.url(forResource: fileName, withExtension: "m4a")
        do {
            // 効果音を鳴らす
            player = try AVAudioPlayer(contentsOf: soundURL!)
            player.volume = 1.0
            player.play()
        } catch {
            print("error...")
        }
    }
    class func playSystemSound(soundIdRing:SystemSoundID){
        var sidRing:SystemSoundID = soundIdRing
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
            AudioServicesCreateSystemSoundID(soundUrl, &sidRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }

    // 位置情報
    var heading:CLLocationDirection! = 0.0
    var location:GeoPoint! = GeoPoint(latitude: 0.0, longitude: 0.0)
    let database = Firestore.firestore()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = GeoPoint(latitude: (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!)
        self.updateLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading.trueHeading
        self.updateLocation()
    }
    func updateLocation(){
        var uuid:String? = UserDefaults.standard.object(forKey: "uuid") as? String
        if uuid == nil {
            uuid = NSUUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "uuid")
            UserDefaults.standard.synchronize()
        }
        database.collection("realtimelocations").document(uuid!).setData(["location":self.location, "heading":heading, "isVolunteer":AppSettingConst.isVolunteer], merge: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(Date(), error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // アプリケーションに関してまだ選択されていない
            manager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
            break
        case .authorizedWhenInUse:
            print("位置情報取得(起動時のみ)が許可されました")
            break
        case .denied:
            print("位置情報取得が拒否されました")
            break
            
        // ・・・省略・・・
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
}
