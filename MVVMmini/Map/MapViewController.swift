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
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .black
        
        let mainvc = MainViewController()
        
        
        
        mapView.backgroundColor = .white
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(50)
        }

    }
}
