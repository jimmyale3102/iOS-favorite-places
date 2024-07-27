//
//  Place.swift
//  FavoritePlaces
//
//  Created by Jimmy on 27/7/2024.
//

import Foundation
import MapKit

struct Place: Identifiable {
    var id = UUID()
    var name: String
    var coordinates: CLLocationCoordinate2D
}
