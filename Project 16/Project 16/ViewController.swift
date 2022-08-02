//
//  ViewController.swift
//  Project 16
//
//  Created by Jose Blanco on 6/15/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Capitals"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(mapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home of the 2012 Summer Olympics", webpage: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", webpage: "https://en.wikipedia.org/wiki/Oslo" )
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", webpage: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", webpage: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", webpage: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        annotationView?.pinTintColor = .blue
        
        if annotationView === nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
         
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        let placeURL = capital.webpage
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "More Info", style: .default) {  _ in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Webview") as? WebViewViewController {
                vc.websiteToLoad = placeURL
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        present(ac, animated: true)
    }
    
    
    
    @objc func mapType() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil , preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { _ in
            self.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) {_ in
            self.mapView.mapType = .satellite
            
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) {_ in
            self.mapView.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) {_ in
            self.mapView.mapType = .satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) {_ in
            self.mapView.mapType = .hybridFlyover
        })
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) {_ in
            self.mapView.mapType = .mutedStandard
        })
        
        popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(ac, animated: true)        }
}

