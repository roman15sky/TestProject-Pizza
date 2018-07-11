//
//  PizzaPlace.swift
//  Pizza Restaurants
//
//  Created by Admin on 11/07/2018.
//  Copyright © 2018 Gary Luk. All rights reserved.
//

import Foundation

class PizzaPlace: NSObject {
    
    var referralId : String
    var name : String
    var address : String
    var crossStreet : String
    var city : String
    var state : String
    var postalCode : String
    var country : String
    var distance : Int
    var lat : Double
    var lng : Double
    var pluralName : String
    var categoriesIcon : String
    var providerName : String
    var deliveryID : String
    var providerIcon : String
    
    init(referralId: String, name: String, address: String, crossStreet:String, city: String, state:String, postalCode:String, country:String, distance: Int,  lat:Double, lng:Double,  pluralName : String, categoriesIcon : String, providerName: String, deliveryID: String, providerIcon:String ) {
        self.referralId = referralId
        self.name = name
        self.address = address
        self.crossStreet = crossStreet
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.distance = distance
        self.lat = lat
        self.lng = lng
        self.pluralName = pluralName
        self.categoriesIcon = categoriesIcon
        self.providerName = providerName
        self.deliveryID = deliveryID
        self.providerIcon = providerIcon
    }
    
}
