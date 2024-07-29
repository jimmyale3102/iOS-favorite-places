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
    @State var coordinatesSelected: CLLocationCoordinate2D? = nil
    @State var places: [Place] = []
    @State var locationName: String = ""
    @State var isFavorite: Bool = false
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(places) { place in
                        Annotation(
                            place.name,
                            coordinate: place.coordinates,
                            content: {
                                let strokeColor = if place.isFavorite { Color.yellow } else { Color.blue }
                                Circle()
                                    .stroke(strokeColor, lineWidth: 3)
                                    .fill(.white)
                                    .frame(width: 35, height: 35)
                            }
                        )
                    }
                }
                .onTapGesture { coordinates in
                    if let coordinates = proxy.convert(coordinates, from: .local) {
                        coordinatesSelected = coordinates
                    }
                }
                .overlay {
                    VStack {
                        Button("Show list") {
                            showSheet = true
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.white)
                        .cornerRadius(16)
                        .padding(16)
                        Spacer()
                    }
                }
            }
            if coordinatesSelected != nil {
                let dialogView = VStack {
                    Text("Add location").font(.title2).bold()
                    Spacer()
                    TextField("Name", text: $locationName)
                        .lineLimit(1)
                        .padding(.horizontal, 8)
                    Toggle("Favorite", isOn: $isFavorite)
                        .padding(.horizontal, 8)
                    Spacer()
                    Button("Save") {
                        savePlace(name: locationName, isFav: isFavorite, coordinates: coordinatesSelected!)
                        clearDialogData()
                    }
                }
                withAnimation {
                    CustomDialog(
                        closeDialog: {
                            coordinatesSelected = nil
                        },
                        onDismissOutside: true,
                        content: dialogView
                    )
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            Text("Heyyy")
        }
    }
    
    func savePlace(name: String, isFav: Bool, coordinates: CLLocationCoordinate2D) {
        let newPlace = Place(name: name, coordinates: coordinates, isFavorite: isFav)
        places.append(newPlace)
    }
    
    func clearDialogData() {
        locationName = ""
        isFavorite = false
        coordinatesSelected = nil
    }
}

#Preview {
    ContentView()
}
