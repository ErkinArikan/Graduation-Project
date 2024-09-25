//
//  SearchViewModel.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import Foundation
import MapKit
import SwiftUI
import SwiftData

class SearchViewModel: ObservableObject { // Removed @StateObject and used a regular property
    
    
    @Published var searchText: String = ""
    @Published var route: MKRoute? = nil
    @Published var searchResults: [SearchResult] = []
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion())
    @Published var showDetails: Bool = false

    // Location service instance (özel hizmet sınıfı)
     var locationService = LocationService(completer: .init())
    
    // Completeiondan aldığımız değeri gerçek search içine atıcaz. 
    // Search Completion fonksiyonu
    /// Amaç completiondan dönen title yani aratıp seçtiğimiz adressin titleını gerçek search fonksiyonuna sokuyoruz ve gerçek searchden dönen değerin  ilkini seçmemiz en doğru cevapı veriyor o yüzden
    func didTapOnCompletion(_ completion: SearchCompletions) {
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title)").first {
                DispatchQueue.main.async {
                    
                    
                    self.searchResults = [singleLocation]
                    
                  
                    
                    
                    // Kamera pozisyonunu güncelle
                    if let lat = self.searchResults.first?.mapItem.placemark.coordinate.latitude,
                       let lon = self.searchResults.first?.mapItem.placemark.coordinate.longitude {
                        let newRegion = MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                        withAnimation(.spring()) {
                            self.cameraPosition = .region(newRegion)
                        }
                    }
                }
            }
        }
    }

}


