//
//  PizzaPlaceDetailViewController.swift
//  Pizza Restaurants
//
//  Created by Admin on 11/07/2018.
//  Copyright © 2018 Gary Luk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import MBProgressHUD
import MapKit

class PizzaPlaceDetailViewController: UIViewController, MKMapViewDelegate {
    
    public var pizzaplaceName = String()
    public var address1 = String()
    public var address2 = String()
    public var address3 = String()
    public var lat_val = Double()
    public var lon_val = Double()
    public var subname = String()
    public var venueid = String()
    public var distance = Int()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subnameLabel: UILabel!
    @IBOutlet var addr1: UILabel!
    @IBOutlet var addr2: UILabel!
    @IBOutlet var addr3: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //init ui
        self.initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Init UI
    func initUI () {
        self.titleLabel.text = pizzaplaceName
        self.subnameLabel.text = subname
        self.addr1.text = address1
        self.addr2.text = address2
        self.addr3.text = address3
        self.distanceLabel.text = String(format: "%d m", distance)
        
        // Mapview init
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let placeLocation = CLLocationCoordinate2D(latitude: lat_val, longitude: lon_val)
        mapView.setCenter(placeLocation, animated: true)
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: placeLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeLocation
        annotation.title = pizzaplaceName
        annotation.subtitle = subname
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Button Action
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
