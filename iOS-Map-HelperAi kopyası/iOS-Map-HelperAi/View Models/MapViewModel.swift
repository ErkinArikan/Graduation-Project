//
//  MapViewModel.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import Foundation
import MapKit
import SwiftUI

struct EquatableCoordinateRegion: Equatable {
    let region: MKCoordinateRegion

    static func == (lhs: EquatableCoordinateRegion, rhs: EquatableCoordinateRegion) -> Bool {
        return lhs.region.center.latitude == rhs.region.center.latitude &&
               lhs.region.center.longitude == rhs.region.center.longitude &&
               lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
               lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

class MapViewModel: ObservableObject {
   
    @Published  var selectedDetent: PresentationDetent = .height(200)
    
    @StateObject var rotaManager = RotaManager.shared
    
    @Published var selectedRecentSearchPoiadi:String = ""
  
    //DESTINATION Ile alakalı variablelar
   
    @Published var originLat: Double = 0.0
    @Published var originLon: Double = 0.0
    
    @Published var destinationLat: Double = 0.0
    @Published var destinationLon: Double = 0.0
    
    // Published properties
    @Published var origin: String = ""
    @Published var destination: String = ""
    
    //Seçilen konumdan gelen lat longlar
    @Published var choosedLong: Double?
    @Published var choosedLat: Double?
    
    
    @Published var addFavoritesViewShow:Bool = false
    //Geçen süre
    @Published var durationTime: Int = 0
    @Published var actualDistance: Double = 0
   
    @Published var choosedPlaceName: String = ""
    @Published var isSearchViewShow: Bool = false
    @Published var destinationSelected: Bool = false
    @Published var showDestinationDetailsView: Bool = false
    @Published var showPolyline: Bool = false
    @Published var searchText: String = ""
    @Published var showSearchButton: Bool = false
    @Published var onWritingView: Bool = false
    @Published var isFavoritesShowing: Bool = true // her zaman true başlasın ki o gösterilsin ilk
    @Published var startingOffSetY: CGFloat = UIScreen.main.bounds.height * 0.55
    @Published var currentDragOffSetY: CGFloat = 0
    @Published var endingOffSetY: CGFloat = 0
    @Published var showDropdown:Bool = false
    @Published var searchTapCount:Int = 0
    
    @Published var choosedPlaceilce:String = ""
    @Published var choosedPlaceIl:String = ""
    
    @Published var isDirectionsShow:Bool = false
    
    //Bu sınıf, bir LocationManagerDummy nesnesine sahiptir. locationManager ile cihazın konum bilgilerini yönetir ve harita üzerinde güncelleme yapar.
    private var locationManager: LocationManagerDummy
    @Published var showToast:Bool = false
    
    @Published var cameraRegion: EquatableCoordinateRegion = EquatableCoordinateRegion(
        region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @Published var polylineCoordinates: [CLLocationCoordinate2D] = []

    
    

    // Initializer
    init(locationManager: LocationManagerDummy) {
        self.locationManager = locationManager
        self.cameraRegion = EquatableCoordinateRegion(region: locationManager.region)
        setupBindings()
    }
   
    // Set up bindings between locationManager and cameraRegion
    //setupBindings() fonksiyonu, locationManager ile cameraRegion arasında bir bağlantı (binding) kurar. Bu sayede konum güncellendiğinde harita da otomatik olarak güncellenir.
    private func setupBindings() {
        locationManager.$region
            .map { EquatableCoordinateRegion(region: $0) }
            .assign(to: &$cameraRegion)
    }

    
    
    
    
    
   
    

    

}
