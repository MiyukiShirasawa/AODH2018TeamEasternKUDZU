//
//  ViewController.swift
//  YouMeetsGuide
//
//  Created by Ryou on 2018/07/21.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
class ViewController: UIViewController, MKMapViewDelegate {
    var database:Firestore!
    var mapView:MKMapView!
    var updateTimer:Timer?
    var locationMng:LocationManager!
    var spotType:AppSettingConst.SpotType = AppSettingConst.SpotType.none
    var volunteerPinArray:Dictionary<String, MKPointAnnotation>! = Dictionary()
    var callingView:UIView = UIView()
    var requestBtn:UIButton = UIButton()
    var emargencyView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.locationMng = LocationManager.shared
        self.view.backgroundColor = UIColor.white
        if !UserDefaults.standard.bool(forKey: "firstboot") {
            let selectLanguageVC = SelectLanguageVC()
            self.navigationController?.pushViewController(selectLanguageVC, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(notif:)), name: NSNotification.Name(rawValue: "update-location"), object: nil)
        database = Firestore.firestore()
        database.collection("realtimelocations").addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update-location"), object: snapshot)
        }
        
        let reqBtnSize:CGFloat = self.view.frame.width * 0.4
        self.requestBtn.frame = CGRect(x: self.view.frame.width - reqBtnSize * 0.5, y: self.view.frame.height - reqBtnSize * 0.5, width: reqBtnSize, height: reqBtnSize)
        self.requestBtn.backgroundColor = AppSettingConst.baseGreenColor
        self.requestBtn.addTarget(self, action: #selector(didTouchRequestBtn(btn:)), for: .touchUpInside)
        self.requestBtn.layer.cornerRadius = reqBtnSize * 0.5
        
        self.callingView.frame = self.view.bounds
        self.callingView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        self.callingView.alpha = 0.0
        
        self.emargencyView.frame = self.view.bounds
        self.emargencyView.backgroundColor = UIColor.red
        self.emargencyView.alpha = 0.0
        
        let emagencyLabel = UIButton()
        emagencyLabel.frame = CGRect(x: 20.0, y: self.view.frame.height * 0.4, width: self.view.frame.width - 40.0, height: 180.0)
        emagencyLabel.setTitleColor(UIColor.black, for: .normal)
        emagencyLabel.setTitle("EmargencyMode \nPush to Around People", for: .normal)
        emagencyLabel.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 30.0)
        emagencyLabel.titleLabel?.numberOfLines = 0
        emagencyLabel.addTarget(self, action: #selector(didTouchEmarBtn(btn:)), for: .touchUpInside)
        emagencyLabel.layer.shadowRadius = AppSettingConst.shadowRadius
        emagencyLabel.layer.shadowOffset = AppSettingConst.shadowOffset
        emagencyLabel.layer.shadowOpacity = AppSettingConst.shadowOpacity
        emagencyLabel.layer.shadowColor = UIColor.black.cgColor
        emagencyLabel.backgroundColor = UIColor.red
        emargencyView.addSubview(emagencyLabel)
        
        let ecancelBtn = UIButton()
        ecancelBtn.frame = CGRect(x: 20.0, y: self.view.frame.height - 80.0, width: self.view.frame.width - 40.0, height: 50.0)
        ecancelBtn.setTitleColor(UIColor.red, for: .normal)
        ecancelBtn.setTitle("Cancel", for: .normal)
        ecancelBtn.backgroundColor = UIColor.white
        ecancelBtn.layer.borderColor = UIColor.white.cgColor
        ecancelBtn.layer.borderWidth = 1.0
        ecancelBtn.layer.cornerRadius = 10.0
        ecancelBtn.addTarget(self, action: #selector(self.didTouchCancelBtn(btn:)), for: .touchUpInside)
        self.emargencyView.addSubview(ecancelBtn)
        
        let callingLabel = UILabel()
        callingLabel.frame = CGRect(x: 0.0, y: self.view.frame.height * 0.4, width: self.view.frame.width, height: 80.0)
        callingLabel.textAlignment = .center
        callingLabel.textColor = UIColor.white
        callingLabel.text = "Request sending\n to Guide"
        callingLabel.font = UIFont(name: "Avenir-Medium", size: 30.0)
        callingLabel.numberOfLines = 0
        callingView.addSubview(callingLabel)
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: 20.0, y: self.view.frame.height - 80.0, width: self.view.frame.width - 40.0, height: 50.0)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.layer.borderColor = UIColor.white.cgColor
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.cornerRadius = 10.0
        cancelBtn.addTarget(self, action: #selector(self.didTouchCancelBtn(btn:)), for: .touchUpInside)
        self.callingView.addSubview(cancelBtn)
        
        self.mapView = MKMapView()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.view = self.mapView
        self.mapView.addSubview(requestBtn)
        self.mapView.addSubview(callingView)
        self.mapView.addSubview(emargencyView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.setup()
        LocationManager.shared.startUpdating()
    }
    
    @objc func didTouchWifiBtn(){
        let wifiArray = DataManager.csvToArray(name: "wifi-spot")
        for annotation in self.mapView.annotations {
            if annotation is PointAnnotation {
                let ann = annotation as! PointAnnotation
                if ann.type == .wifi {
                    self.mapView.removeAnnotation(annotation)
                }
            }
        }
        for infoStr in wifiArray as! [String] {
            var info = DataManager.csvToArray(str: infoStr)
            let annotation = PointAnnotation()
            let latStr = info![9]
            let lngStr = info![10]
            let wifiId = info![1]

            let lat = Double( NumberFormatter().number(from: latStr)!) ?? 0.0
            let lng = Double( NumberFormatter().number(from: lngStr)!) ?? 0.0
            if !(lat == 0 && lng == 0) {
                annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
                annotation.title = info![4]
                annotation.subtitle = "🌟🌟🌟"
                annotation.type = .wifi
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    @objc func didTouchPublicBtn(){
        let publicSpotArray = DataManager.csvToArray(name: "sabae")
        for annotation in self.mapView.annotations {
            if annotation is PointAnnotation {
                let ann = annotation as! PointAnnotation
                if ann.type == .wifi {
                    self.mapView.removeAnnotation(annotation)
                }
            }
        }
        var cnt:Int = 0
        for infoStr in publicSpotArray as! [String] {
            var info = DataManager.csvToArray(str: infoStr)
            let annotation = PointAnnotation()
            if (info?.count)! < 2 {
                continue
            }
            let latStr = info![12]
            let lngStr = info![13]
            let wifiId = info![0]
            if latStr.isEmpty || lngStr.isEmpty {
                continue
            }
            let lat = Double( NumberFormatter().number(from: latStr)!) ?? 0.0
            let lng = Double( NumberFormatter().number(from: latStr)!) ?? 0.0
            if !(lat == 0 && lng == 0) {
                annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
                annotation.title = info![0]
                annotation.subtitle = "🌟🌟🌟"
                annotation.type = AppSettingConst.SpotType.spot
                self.mapView.addAnnotation(annotation)
                self.volunteerPinArray[wifiId] = annotation
            }
            cnt += 1
            if cnt > 20 {
                break
            }
        }
    }
    
    @objc func didTouchRequestBtn(btn:UIButton) {
        UIView.animate(withDuration: 0.25) {
            if btn.tag == 0 {
                btn.tag = 1
                btn.transform = CGAffineTransform.init(translationX: -40.0, y: -40.0)
            }else{
                btn.tag = 0
                btn.transform = CGAffineTransform.identity
                self.callingView.alpha = 1.0
            }
        }
        
    }
    @objc func didTouchCancelBtn(btn:UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.callingView.alpha = 0.0
            self.emargencyView.alpha = 0.0
        }
    }
    @objc func didUpdateLocation(notif:Notification){
        let snapshot = notif.object as! QuerySnapshot
        for annotation in self.mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
        for document in snapshot.documents {
            let coordinate = document.data()["location"] as! GeoPoint
            let isVolunteer:Bool = document.data()["isVolunteer"] as? Bool ?? false
            if !isVolunteer {
//                continue
            }
            let annotation = PointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
            annotation.title = "Agent 1"
            annotation.subtitle = "🌟🌟🌟"
            annotation.type = AppSettingConst.SpotType.volunteer
//            annotation.type = AppSettingConst.SpotType.volunteer
            self.mapView.addAnnotation(annotation)
//            self.volunteerPinArray[document.documentID] = annotation
        }
        self.didTouchWifiBtn()
//        self.didTouchPublicBtn()
    }
    
    // MAP DELEGATE
    var firstLocation:Bool = false
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !firstLocation {
            self.firstLocation = true
            if !firstLocation {
                firstLocation = true
                let coordinate = mapView.userLocation.coordinate
                let span = MKCoordinateSpanMake(0.005, 0.005)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated:true)
            }
        }
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PointAnnotation {
            let testPinView = MKAnnotationView()
            testPinView.canShowCallout = true
            testPinView.annotation = annotation
            let ann = annotation as! PointAnnotation
            if ann.type == .wifi {
                testPinView.image = UIImage(named: "pict_wifiPin.png")
            }else if ann.type == .aed {
                testPinView.image = UIImage(named: "pict_aedPin.png")
            }else if ann.type == .volunteer {
                testPinView.image = UIImage(named: "pict_guide.png")
            }
            
            return testPinView
        }else{
            let testPinView = MKAnnotationView()
            testPinView.canShowCallout = true
            testPinView.annotation = annotation
            return testPinView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Emargency")
            UIView.animate(withDuration: 0.25) {
                self.emargencyView.alpha = 1.0
            }
        }
    }
    @objc func didTouchEmarBtn(btn:UIButton) {
        LocationManager.shared.playSound(fileName: "payment_success")
        SpeechManager.sharedManager.playSpeech(speechText: "誰か！助けてください！私は韓国じんです。韓国語がわかる人はいませんか？", language: "ja-JP")
    }
}

