//
//  ViewController.swift
//  Project 22
//
//  Created by Jose Blanco on 7/1/22.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var currentBeacon: UILabel!
    @IBOutlet var circleView: UIView!
    var locationManager: CLLocationManager?
    var beaconDetected = false
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        //locationManager?.requestWhenInUseAuthorization()
        
        view.backgroundColor = .gray
        circleView.layer.cornerRadius = 128
        circleView.contentScaleFactor = 0.001
        circleView.backgroundColor = .gray.darker
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //do stuff
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "Apple Air Locate 5A")
        let uuid2 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 123, minor: 456, identifier: "Apple AirLocate E2")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(in: beaconRegion2)
    }
    
    func update(distance: CLProximity) {
        if !beaconDetected && distance != .unknown {
            beaconDetected = true
            let ac = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.circleView.backgroundColor = .blue.darker
               
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.contentScaleFactor = 0.5
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.circleView.backgroundColor = .orange.darker
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "Right Here"
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.circleView.backgroundColor = .red.darker
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.circleView.backgroundColor = .gray.darker
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            currentBeacon.text = "\(beacon.proximityUUID)"
        } else if let beacon = beacons.last {
            update(distance: beacon.proximity)
            currentBeacon.text = "\(beacon.proximityUUID)"
        }
    }
}

extension UIColor {

    var darker: UIColor {

    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        guard self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            print("** some problem demuxing the color")
            return .gray
        }

        let nudged = b * 0.85

        return UIColor(hue: h, saturation: s, brightness: nudged, alpha: a)
    }
}
