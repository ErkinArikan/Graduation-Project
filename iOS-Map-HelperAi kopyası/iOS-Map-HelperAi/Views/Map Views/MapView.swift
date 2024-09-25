//
//  MapView.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import SwiftUI
import MapKit
import SwiftData

#warning("yol iptal edildi gibi bir toast mesajı çıkart")
    

#warning("Sanki arabada ve hareket ediyormuşuz gibi konumun hareket edip kameranın da ona sabit kalmasının sağlamaya çalıştım kodları onChange içinde ve locationManager içinde Start adlı kod var onu silersin bir şeyler yanlış ise. Bu durumu test et.")

/// YAPARKEN DİKKAT ETTİĞİM & ÖĞRENDİĞİM ŞEYLER

/// Bu sayfaya preview eklersen açılırken yavaşlıyor. Unutma açılırken yavaşlamasını engellemek için maxHeight kullanman lazım.


struct MapView: View {
    @EnvironmentObject var locationManager: LocationManagerDummy
    @EnvironmentObject var vm: MapViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var iosVm: MapiOSViewModel
    @State private var isPolylineShow: Bool = false
    @Namespace private var favoritesMap
    @Environment(\.modelContext) var context
    @State private var selection: SearchResult?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapDisplayView(isPolylineShow: $isPolylineShow, selection: $selection)
                .environmentObject(vm)
                .environmentObject(searchViewModel)
                .environmentObject(iosVm)

        }
        .ignoresSafeArea()
        .mapScope(favoritesMap)
        .onAppear {
            iosVm.cameraPosition = MapCameraPosition.region(vm.cameraRegion.region)
        }
        .onChange(of: iosVm.cameraPosition) { newValue in
            DispatchQueue.main.async {
                if let region = newValue.region {
                    iosVm.cameraPosition = MapCameraPosition.region(region)
                }
            }
        }
        
        .onChange(of: iosVm.selectedLocation) { newLocation in
            iosVm.isSheetPresented = iosVm.selectedLocation == nil
            iosVm.updateLocationDetails(newLocation)
            saveToRecentSearches(from: newLocation)
        }
        .onChange(of: iosVm.getDirections) { newValue in
            if newValue {
                iosVm.fetchRoute()
            }
        }
        .onChange(of: iosVm.searchResults) {
            if let firstResult = iosVm.searchResults.first, iosVm.searchResults.count == 1 {
                iosVm.selectedLocation = firstResult
            }
        }
        .onChange(of: iosVm.getDirections, { oldValue, newValue in
            isPolylineShow = newValue
        })
    }
    
    func saveToRecentSearches(from result: SearchResult?) {
            let recentSearchItem = LastSearchedPlaces(
                poiadi: result?.mapItem.name ?? "poiadi yok",
                lat: result?.mapItem.placemark.coordinate.latitude ?? 0.0,
                lon: result?.mapItem.placemark.coordinate.longitude ?? 0.0,
                ilce: result?.mapItem.placemark.locality ?? "locality yok",
                il: result?.mapItem.placemark.subtitle ?? "subtitle yok",
                timestamp: Date() // Zamanı ekliyoruz
            )

            do {
                // 1. Yeni aramayı veritabanına ekleyin
                try context.insert(recentSearchItem)
                print("Son arama kaydedildi: \(recentSearchItem.poiadi)")

                // 2. Şu anda veritabanındaki tüm aramaları çekin ve zamana göre sıraya dizin
                let fetchRequest = FetchDescriptor<LastSearchedPlaces>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
                let allSearches = try context.fetch(fetchRequest)

                // 3. Eğer kayıt sayısı 3'ten fazla ise, en eski olanları silin
                if allSearches.count > 3 {
                    let extraItems = allSearches.suffix(from: 3) // İlk 3 kaydı koru, geri kalanını al
                    for item in extraItems {
                        context.delete(item)
                        print("Silinen eski arama: \(item.poiadi)")
                    }
                }

            } catch {
                print("Son aramayı kaydederken hata: \(error.localizedDescription)")
            }
        }
}

// Subview 1: Map Display View
struct MapDisplayView: View {
    @Binding var isPolylineShow: Bool
    @Binding var selection: SearchResult?
    
    
    @EnvironmentObject var vm: MapViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var iosVm: MapiOSViewModel
    @Namespace private var favoritesMap
    @EnvironmentObject var locationManager:LocationManagerDummy

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $iosVm.cameraPosition, selection: $selection, scope: favoritesMap) {
                UserAnnotation()
                
                ForEach(iosVm.exSearchResul, id: \.self) { result in
                    let item = result.mapItem
                    Marker(item: item)
                }
                
                if vm.showDestinationDetailsView {
                    ForEach(iosVm.searchResults, id: \.self) { item in
                        let placemark = item.mapItem.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                }
                
                if isPolylineShow {
                    ForEach(iosVm.routes.indices, id: \.self) { index in
                        let route = iosVm.routes[index]
                        if index == 0 {
                            MapPolyline(route.polyline)
                                .stroke(.blue, lineWidth: 8)
                        } else {
                            MapPolyline(route.polyline)
                                .stroke(.red, lineWidth: 3)
                        }
                    }
                }
                
                
                
            }
            VStack{
                ZStack{
                    //User location button özelleştirilmiş hali
                    MapUserLocationButton(scope: favoritesMap)
                        .tint(.black)
                        .shadow(radius: 3)
                        
                } //:ZStack
            } //:VStacka
            .padding()
            .buttonBorderShape(.circle)
            .offset(y:vm.isSearchViewShow ? -320 : -130)
        
            
            
        }
        /// BURAYI YENİ EKLEDİM.
        .onChange(of: locationManager.currentLocation) { newLocation in
                    if let newLocation = newLocation {
                        iosVm.cameraPosition =
                        MapCameraPosition.region(MKCoordinateRegion(
                            center: newLocation,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }
                }
        .onChange(of: selection, { oldValue, newValue in
            
            withAnimation(.spring) {
                print("onChange tetiklendi")
                vm.isSearchViewShow = false
                vm.showDestinationDetailsView = true
                vm.endingOffSetY = 0.0
                
                let recentSearchCompletion = SearchCompletions(title: selection?.mapItem.name ?? "No name", subTitle: selection?.mapItem.placemark.subtitle ?? "No subtitle")
                searchViewModel.didTapOnCompletion(recentSearchCompletion)
            }
            
           
        })
        .mapScope(favoritesMap)
    }
    
    
  
    
}



// Preview
#Preview {
    MapView()
        .environmentObject(LocationManagerDummy())
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(MapiOSViewModel())
        .environmentObject(SearchViewModel())
}
