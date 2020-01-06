//
//  ViewController.swift
//  locationMap
//
//  Created by Ufuk Köşker on 14.10.2019.
//  Copyright © 2019 Ufuk Köşker. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureLocationManager()
        centerMapOnUserLocation()
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        // Cihazımızın enlem ve boylam olarak konumunu aldık. ('Print(region)' fonksiyonu içerisinde yazdırabilirsiniz.)
        mapView.setRegion(region, animated: true)
    }
    
    func configureMapView() {
        mapView.showsUserLocation = true // Bool değerini 'true' yaparak cihazın konumunu haritada gösterdik.
        mapView.userTrackingMode = .follow // Cihazın konumunun harita üzerinde takibi için gerekli olan kod.

    }

    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }


    @IBAction func centerOnUserLocationTapped(_ sender: UIButton) {
        centerMapOnUserLocation()
        configureMapView()
    }
    
    func alertFunc(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
extension ViewController: CLLocationManagerDelegate {
    // Uygulamamızın konum servis izinleri hakkındaki bilgileri kullanıcıya gösterebileceğimiz bir fonksiyon yazdık.

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            alertFunc(title: "Uyarı!!!", message: "Kullanıcı, uygulamanın konum servislerini kullanıp kullanamayacağını seçmedi.")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertFunc(title: "Uyarı!!!", message: "Uygulamanın konum servislerini kullanma yetkisi yok.")
        case .denied:
            alertFunc(title: "Uyarı!!!", message: "Kullanıcı, uygulama için konum servislerinin kullanımını reddetti veya Ayarlar'da genel olarak devre dışı bırakıldı.")
        case .authorizedAlways:
            alertFunc(title: "Uyarı!!!", message: "Kullanıcı, istediği zaman konum hizmetlerini başlatması için uygulamaya izin verdi.")
        case .authorizedWhenInUse:
            alertFunc(title: "Uyarı!!!", message: "Kullanıcı, uygulama kullanımdayken konum servislerini başlatmasına izin verdi.")
        @unknown default:
            fatalError()
        }
        
        centerMapOnUserLocation()
    }
}
