//
//  ContentView.swift
//  FavoritePlaces
//
//  Created by Jimmy on 27/7/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 4.6615747, longitude: -74.1439569),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position)
                    .onTapGesture {
                        
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
