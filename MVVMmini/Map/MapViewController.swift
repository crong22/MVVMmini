//
//  MapViewController.swift
//  MVVMmini
//
//  Created by 여누 on 7/13/24.
//

import UIKit
import MapKit
import SnapKit

class MapViewController : UIViewController {
    let mainView = UIView()
    let mapView = MKMapView()
    var map = CLLocationCoordinate2D()
    var raindata : Int?
    let viewmodel = MainViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .black
        
        let mainvc = MainViewController()
        let annotation = MKPointAnnotation()
        
        
        view.addSubview(mapView)
        
        mapView.backgroundColor = .black
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        mainvc.setRegionAndAnnotation(center: map)
        let lat = viewmodel.OuputWheatherData.value?.city.coord.lat
        let lon = viewmodel.OuputWheatherData.value?.city.coord.lon
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat ?? 37.5833 , longitude: lon ?? 127.0)
        
        guard let rainData = raindata else {
            mapView.removeAnnotations(self.mapView.annotations)
            annotation.title = "0"
            mapView.addAnnotation(annotation)
            return
        }
        mapView.removeAnnotations(self.mapView.annotations)
        annotation.title = "\(rainData)"
        mapView.addAnnotation(annotation)
        
    }

}
