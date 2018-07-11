//
//  ViewController.swift
//  Pizza Restaurants
//
//  Created by Admin on 11/07/2018.
//  Copyright © 2018 Gary Luk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MBProgressHUD
import SCLAlertView

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var pizzaplaceArray = [PizzaPlace]()
    
    var sel_pizzaplaceName = String()
    var sel_address1 = String()
    var sel_address2 = String()
    var sel_address3 = String()
    var sel_lat_val = Double()
    var sel_lon_val = Double()
    var sel_subname = String()
    var sel_venueid = String()
    var sel_distance = Int()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "ME"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
        
        locationManager.stopUpdatingLocation()
        //Call API to get data with current location
        self.getRecommendations(currentLocation: locValue)
    }

    // MARK: - Get Pizza restaurants From FOURSQUARE API
    func getRecommendations(currentLocation : CLLocationCoordinate2D ) {
        //Init Array
        self.pizzaplaceArray = []
        
        // Show MBProgress Loading View
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = MBProgressHUDMode.indeterminate
        
        // Init Parameters
        let parameters = [
            "v": Constants.version,
            "client_id": Constants.clientID,
            "client_secret": Constants.clientSecret,
            "locale": Constants.locale,
            "ll": "\(currentLocation.latitude),\(currentLocation.longitude)",
            "limit": Constants.limit,
            "intent": Constants.intent,
            "query" : Constants.query
        ]
        
        Alamofire.request(Constants.searchVenuesEndPoint, method: .get, parameters: parameters).responseJSON { (responseData) -> Void in
            //Hide MBProgress Loading View
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if swiftyJsonVar["meta"]["code"].intValue == 200 {
                    //Success
                    print(swiftyJsonVar["response"]["venues"].count)
                    for i in 0..<swiftyJsonVar["response"]["venues"].count {
                        var referralId = ""
                        if swiftyJsonVar["response"]["venues"][i]["referralId"] != JSON.null {
                            referralId = swiftyJsonVar["response"]["venues"][i]["referralId"].stringValue
                        }
                        
                        var name = ""
                        if swiftyJsonVar["response"]["venues"][i]["name"] != JSON.null {
                            name = swiftyJsonVar["response"]["venues"][i]["name"].stringValue
                        }
                        
                        var address = ""
                        if swiftyJsonVar["response"]["venues"][i]["location"]["address"] != JSON.null {
                            address = swiftyJsonVar["response"]["venues"][i]["location"]["address"].stringValue
                        }
                        
                        var crossStreet = ""
                        if swiftyJsonVar["response"]["venues"][i]["location"]["crossStreet"] != JSON.null {
                            crossStreet = swiftyJsonVar["response"]["venues"][i]["location"]["crossStreet"].stringValue
                        }
                        
                        var city = ""
                        if swiftyJsonVar["response"]["venues"][i]["location"]["city"] != JSON.null {
                            city = swiftyJsonVar["response"]["venues"][i]["location"]["city"].stringValue
                        }
                        
                        var state = ""
                        if swiftyJsonVar["response"]["venues"][i]["location"]["state"] != JSON.null {
                            state = swiftyJsonVar["response"]["venues"][i]["location"]["state"].stringValue
                        }
                        
                        var postalCode = ""
                        if swiftyJsonVar["response"]["venues"][i]["location"]["postalCode"] != JSON.null {
                            postalCode = swiftyJsonVar["response"]["venues"][i]["location"]["postalCode"].stringValue
                        }
                        
                        var country = ""
                        if swiftyJsonVar["response"]["venues"][i]["location"]["country"] != JSON.null {
                            country = swiftyJsonVar["response"]["venues"][i]["location"]["country"].stringValue
                        }
                        
                        var distance = 0
                        if swiftyJsonVar["response"]["venues"][i]["location"]["distance"] != JSON.null {
                            distance = swiftyJsonVar["response"]["venues"][i]["location"]["distance"].intValue
                        }
                        
                        var lat = 0.0
                        if swiftyJsonVar["response"]["venues"][i]["location"]["lat"] != JSON.null {
                            lat = swiftyJsonVar["response"]["venues"][i]["location"]["lat"].doubleValue
                        }
                        
                        var lng = 0.0
                        if swiftyJsonVar["response"]["venues"][i]["location"]["lng"] != JSON.null {
                            lng = swiftyJsonVar["response"]["venues"][i]["location"]["lng"].doubleValue
                        }
                        
                        var pluralName = ""
                        if swiftyJsonVar["response"]["venues"][i]["categories"][0]["pluralName"] != JSON.null {
                            pluralName = swiftyJsonVar["response"]["venues"][i]["categories"][0]["pluralName"].stringValue
                        }
                        
                        var categoriesIcon = ""
                        if swiftyJsonVar["response"]["venues"][i]["categories"][0]["icon"]["prefix"] != JSON.null {
                            categoriesIcon = swiftyJsonVar["response"]["venues"][i]["categories"][0]["icon"]["prefix"].stringValue + swiftyJsonVar["response"]["venues"][i]["categories"][0]["icon"]["suffix"].stringValue
                        }
                        
                        var providerName = ""
                        if swiftyJsonVar["response"]["venues"][i]["delivery"]["provider"]["name"] != JSON.null {
                            providerName = swiftyJsonVar["response"]["venues"][i]["delivery"]["provider"]["name"].stringValue
                        }
                        
                        var deliveryID = ""
                        if swiftyJsonVar["response"]["venues"][i]["delivery"]["id"] != JSON.null {
                            deliveryID = swiftyJsonVar["response"]["venues"][i]["delivery"]["id"].stringValue
                        }
                        
                        var providerIcon = ""
                        if swiftyJsonVar["response"]["venues"][i]["delivery"]["provider"] != JSON.null {
                            providerIcon = swiftyJsonVar["response"]["venues"][i]["delivery"]["provider"]["icon"]["prefix"].stringValue + swiftyJsonVar["response"]["venues"][i]["delivery"]["provider"]["icon"]["name"].stringValue
                        }
                        
                        let pizzaplace = PizzaPlace.init(referralId: referralId, name: name, address: address, crossStreet: crossStreet, city: city, state: state, postalCode: postalCode, country: country, distance: distance, lat: lat, lng: lng, pluralName: pluralName, categoriesIcon: categoriesIcon, providerName: providerName, deliveryID: deliveryID, providerIcon: providerIcon)
                        
                        self.pizzaplaceArray.append(pizzaplace)
                    }
                    self.tableView.reloadData()
                } else {
                    //Error
                }
            }else {
                self.showError(erromsg: "Please check your Network Connection.")
            }
        }
    }
    
    // MARK: - Show Error
    func showError(erromsg : String){
        SCLAlertView().showError("Error", subTitle:erromsg, closeButtonTitle:"OK")
    }
    
    // MARK: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pizzaplaceArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 143
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaPlaceTableViewCell", for: indexPath) as! PizzaPlaceTableViewCell
        cell.placeNameLabel.text = "\(indexPath.row + 1). " + self.pizzaplaceArray[indexPath.row].name
        cell.address1Label.text = self.pizzaplaceArray[indexPath.row].address + " (" + self.pizzaplaceArray[indexPath.row].crossStreet + ")"
        cell.address2Label.text = self.pizzaplaceArray[indexPath.row].city + ", " + self.pizzaplaceArray[indexPath.row].state + " " + self.pizzaplaceArray[indexPath.row].postalCode
        cell.address3Label.text = self.pizzaplaceArray[indexPath.row].country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sel_lat_val = self.pizzaplaceArray[indexPath.row].lat
        sel_lon_val = self.pizzaplaceArray[indexPath.row].lng
        sel_subname = self.pizzaplaceArray[indexPath.row].pluralName
        sel_address1 = self.pizzaplaceArray[indexPath.row].address + " (" + self.pizzaplaceArray[indexPath.row].crossStreet + ")"
        sel_address2 = self.pizzaplaceArray[indexPath.row].city + ", " + self.pizzaplaceArray[indexPath.row].state + " " + self.pizzaplaceArray[indexPath.row].postalCode
        sel_address3 = self.pizzaplaceArray[indexPath.row].country
        sel_pizzaplaceName = self.pizzaplaceArray[indexPath.row].name
        sel_venueid = self.pizzaplaceArray[indexPath.row].referralId
        sel_distance = self.pizzaplaceArray[indexPath.row].distance
        self.performSegue(withIdentifier: "goDetailSegue", sender: nil)
    }
    
    // MARk: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailSegue" {
            let vc = segue.destination as! PizzaPlaceDetailViewController
            vc.lat_val = sel_lat_val
            vc.lon_val = sel_lon_val
            vc.subname = sel_subname
            vc.address1 = sel_address1
            vc.address2 = sel_address2
            vc.address3 = sel_address3
            vc.pizzaplaceName = sel_pizzaplaceName
            vc.venueid = sel_venueid
            vc.distance = sel_distance
        }
    }
}

