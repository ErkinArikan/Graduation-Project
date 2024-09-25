//
//  MapiOSViewModel.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import Foundation
import SwiftUI
import MapKit

/// Deneme alanı
struct RouteInfo: Identifiable {
    let id = UUID()
    let route: MKRoute
    let travelTimeMinutes: Double
    let distanceKm: Double
    let readableTime: String
}




class MapiOSViewModel:  ObservableObject {
    
    @Published var exSearchResul:[SearchResult] = []
    
    @Published  var routes: [MKRoute] = []
    @Published  var arrivalDateString: String = ""
    @Published  var searchResults = [SearchResult]()
    @Published  var selectedLocation: SearchResult?
    @Published  var isSheetPresented: Bool = false
    
    @Published var cameraPosition: MapCameraPosition
    

     var locationManager  = LocationManagerDummy()
    @Published var lookAroundScene:MKLookAroundScene?
    @Published var showDetails: Bool = false
    @Published var getDirections = false
    
    @Published var travelTime: TimeInterval = 0
    @Published var travelTimeMinutes: Double = 0
    
    @Published var routeDisplaying = false
    @Published var route: MKRoute?
    @Published var routeDestination: MKMapItem?
    @Published var distance: Double = 0
    @Published var readableTime: String = ""
    @Published var selectedDetent: PresentationDetent = .height(200)
    
    
    
    
    ///Deneme alanı
    @Published var routeInfos: [RouteInfo] = []
    
    
    init(cameraPosition: MapCameraPosition = MapCameraPosition.automatic) {
          self.cameraPosition = cameraPosition
      }
    
    
    func fetchRoute() {
        if let selectedLocation = selectedLocation {
            
            let request = MKDirections.Request()
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.currentLocation ?? CLLocationCoordinate2D(latitude: 39.88276624445194, longitude: 32.68572294962696)))
            request.destination = selectedLocation.mapItem
            request.transportType = .automobile
            request.requestsAlternateRoutes = true
            request.tollPreference = .avoid
            request.departureDate = Date()
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                let routes = result?.routes ?? []
               
                DispatchQueue.main.async {
                if !routes.isEmpty {
                    // Use the first route as the main route
                    self.route = routes.first
                    self.routeDestination = selectedLocation.mapItem
                    self.routeDisplaying = true
                    self.travelTime = self.route!.expectedTravelTime
                    self.distance = self.route!.distance / 1000
                    self.travelTimeMinutes = self.travelTime / 60

                    let arrivalDate = Date().addingTimeInterval(self.travelTime)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    self.arrivalDateString = dateFormatter.string(from: arrivalDate)

                    let hours = Int(self.travelTimeMinutes) / 60
                    let minutes = Int(self.travelTimeMinutes) % 60
                    if hours > 0 {
                        self.readableTime = "\(hours) saat \(minutes) dakika"
                    } else {
                        self.readableTime = "\(minutes) dakika"
                    }

                    
                    self.routeInfos = routes.map { route in
                        let travelTimeMinutes = route.expectedTravelTime / 60
                        let distanceKm = route.distance / 1000
                        let hours = Int(travelTimeMinutes) / 60
                        let minutes = Int(travelTimeMinutes) % 60
                        let readableTime: String
                        if hours > 0 {
                            readableTime = "\(hours) saat \(minutes) dakika"
                        } else {
                            readableTime = "\(minutes) dakika"
                        }
                        
                        return RouteInfo(route: route, travelTimeMinutes: travelTimeMinutes, distanceKm: distanceKm, readableTime: readableTime)
                    }
                    
                    // Ana thread üzerinde cameraPosition'ı güncelle
                    DispatchQueue.main.async {
                          withAnimation(.snappy) {
                              if let rect = self.route?.polyline.boundingMapRect {
                                  // Burada latitudeDelta ve longitudeDelta değerlerini artırarak uzaklaştırma sağlıyoruz
                                  let zoomFactor: Double = 1.5 // Uzaklaştırma faktörü
                                  let adjustedRect = MKMapRect(
                                      x: rect.origin.x - (rect.size.width * (zoomFactor - 1) / 2),
                                      y: rect.origin.y - (rect.size.height * (zoomFactor - 1) / 2),
                                      width: rect.size.width * zoomFactor,
                                      height: rect.size.height * zoomFactor
                                  )
                                  self.cameraPosition = .rect(adjustedRect)
                              }
                          }
                      }
                }

                // Save all the routes
                self.routes = routes
            }
            }

        }
    }
    
    
//    func fetchRote2() {
//        if let selectedLocation = selectedLocation {
//            
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.currentLocation ?? CLLocationCoordinate2D(latitude: 39.88276624445194, longitude: 32.68572294962696)))
//            request.destination = selectedLocation.mapItem
//            request.transportType = .automobile
//            request.requestsAlternateRoutes = true
//            request.tollPreference = .avoid
//            request.departureDate = Date()
//            
//            Task {
//                let result = try? await MKDirections(request: request).calculate()
//                let routes = result?.routes ?? []
//               
//                DispatchQueue.main.async {
//                    if !routes.isEmpty {
//                        // İlk rotayı kullanarak ana ekran bilgilerini güncelle
//                        self.route = routes.first
//                        self.routeDestination = selectedLocation.mapItem
//                        self.routeDisplaying = true
//                        self.travelTime = self.route!.expectedTravelTime
//                        self.distance = self.route!.distance / 1000
//                        self.travelTimeMinutes = self.travelTime / 60
//
//                        let arrivalDate = Date().addingTimeInterval(self.travelTime)
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateStyle = .medium
//                        dateFormatter.timeStyle = .short
//                        self.arrivalDateString = dateFormatter.string(from: arrivalDate)
//
//                        let hours = Int(self.travelTimeMinutes) / 60
//                        let minutes = Int(self.travelTimeMinutes) % 60
//                        if hours > 0 {
//                            self.readableTime = "\(hours) saat \(minutes) dakika"
//                        } else {
//                            self.readableTime = "\(minutes) dakika"
//                        }
//
//                        // Alternatif rotaların bilgilerini hesapla ve sakla
//                        self.routeInfos = routes.map { route in
//                            let travelTimeMinutes = route.expectedTravelTime / 60
//                            let distanceKm = route.distance / 1000
//                            let hours = Int(travelTimeMinutes) / 60
//                            let minutes = Int(travelTimeMinutes) % 60
//                            let readableTime: String
//                            if hours > 0 {
//                                readableTime = "\(hours) saat \(minutes) dakika"
//                            } else {
//                                readableTime = "\(minutes) dakika"
//                            }
//                            
//                            return RouteInfo(route: route, travelTimeMinutes: travelTimeMinutes, distanceKm: distanceKm, readableTime: readableTime)
//                        }
//
//                        // Kamera pozisyonunu güncelle
//                        DispatchQueue.main.async {
//                              withAnimation(.snappy) {
//                                  if let rect = self.route?.polyline.boundingMapRect {
//                                      let zoomFactor: Double = 1.5
//                                      let adjustedRect = MKMapRect(
//                                          x: rect.origin.x - (rect.size.width * (zoomFactor - 1) / 2),
//                                          y: rect.origin.y - (rect.size.height * (zoomFactor - 1) / 2),
//                                          width: rect.size.width * zoomFactor,
//                                          height: rect.size.height * zoomFactor
//                                      )
//                                      self.cameraPosition = .rect(adjustedRect)
//                                  }
//                              }
//                          }
//                    }
//
//                    // Tüm rotaları kaydet
//                    self.routes = routes
//                }
//            }
//        }
//    }

    
    
    
    func searchForLocalPlaces(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = locationManager.region

        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            
            // Map the response's mapItems to SearchResult objects
            if let mapItems = response?.mapItems {
                self.exSearchResul = mapItems.map { SearchResult(mapItem: $0) }
            } else {
                self.exSearchResul = []
            }
        }
    }
    func updateLocationDetails(_ location: SearchResult?) {
        guard let location = location else { return }
        print("Seçilen adres: \(location.mapItem.name ?? "Bilinmiyor")")
        print("Koordinatlar: \(location.mapItem.placemark.coordinate)")
    }
    
    }
    
    


