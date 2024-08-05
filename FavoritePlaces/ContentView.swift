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
    let PLACES_KEY = "places"
    
    let sheetHeight  = stride(from: 0.2, through: 0.2, by: 1).map{ PresentationDetent.fraction($0) }
    
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
        }.onAppear(perform: {
            getPlaces()
        })
        .sheet(isPresented: $showSheet) {
            if places.isEmpty {
                ZStack {
                    VStack {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .resizable()
                            .frame(width: 38, height: 38)
                        Text("There are not places saved yet")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.darkBrownApp)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                        Text("Press anywhere on the map to start saving places")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                    }
                    .frame(height: 150, alignment: .center)
                }
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name).font(.caption).bold()
                                .frame(maxWidth: 120)
                                .padding(.horizontal, 8)
                        }
                        .frame(width: 150, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                                .shadow(color: Color.black.opacity(0.5), radius: 12, x: 0, y: 4)
                                .padding(8)
                        )
                        .overlay(alignment: .topTrailing) {
                            if place.isFavorite {
                                Image(systemName: "star.fill").foregroundColor(.yellow).padding(12)
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Button(action: { deletePlace(place: place) } ) {
                                Image(systemName: "trash.circle").foregroundColor(.secondary).padding(16)
                            }
                        }
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            navigateToLocation(coordinates: place.coordinates)
                            showSheet = false
                        }
                    }
                }
            }
            .presentationDetents(Set(sheetHeight))
        }
    }
    
    func deletePlace(place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            places.remove(at: index)
            savePlaces()
        }
    }
    
    func savePlace(name: String, isFav: Bool, coordinates: CLLocationCoordinate2D) {
        let newPlace = Place(name: name, coordinates: coordinates, isFavorite: isFav)
        places.append(newPlace)
        savePlaces()
    }
    
    func clearDialogData() {
        locationName = ""
        isFavorite = false
        coordinatesSelected = nil
    }
    
    func navigateToLocation(coordinates: CLLocationCoordinate2D) {
        withAnimation {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        }
    }
}

extension ContentView {
    
    func savePlaces() {
        if let encodeData = try? JSONEncoder().encode(places) {
            UserDefaults.standard.set(encodeData, forKey: PLACES_KEY)
        }
    }
    
    func getPlaces() {
        if let savedPlaces = UserDefaults.standard.data(forKey: PLACES_KEY),
           let decodedPlaces = try? JSONDecoder().decode([Place].self, from: savedPlaces) {
            places = decodedPlaces
        }
    }
}

#Preview {
    ContentView()
}
