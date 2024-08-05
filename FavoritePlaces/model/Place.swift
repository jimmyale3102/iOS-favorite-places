//
//  Place.swift
//  FavoritePlaces
//
//  Created by Jimmy on 27/7/2024.
//

import Foundation
import MapKit

struct Place: Identifiable, Codable {
    var id = UUID()
    var name: String
    var coordinates: CLLocationCoordinate2D
    var isFavorite: Bool
    
    enum CodingKeys: CodingKey {
        case id, name, isFavorite, latitude, longitude
    }
    
    init(id: UUID = UUID(), name: String, coordinates: CLLocationCoordinate2D, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.isFavorite = isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        
        id = try container.decode(UUID.self, forKey: .id)
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        name = try container.decode(String.self, forKey: .name)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinates.latitude, forKey: .latitude)
        try container.encode(coordinates.longitude, forKey: .longitude)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}
