//
//  PinEtension.swift
//  noura altamimi- virtual tourist
//
//  Created by noura tamimi on 15/06/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//
import Foundation
import MapKit
extension Pin {
    var coordinate:CLLocationCoordinate2D{
        set {
            longitude=newValue.longitude
            latitude=newValue.latitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    func compare(to coordinate:CLLocationCoordinate2D) -> Bool{
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
