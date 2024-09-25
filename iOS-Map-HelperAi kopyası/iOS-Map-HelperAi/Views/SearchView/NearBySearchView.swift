//
//  NearbySearchView.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 23.09.2024.
//

import SwiftUI
import MapKit


#warning("Detay sayfalarını da görelim çıkan popların güzel bir preview ve sürelerini de ekleyip bitiebiliriz sonra bugları temizle.")
#warning("sayfaların hareketlerini detents ile yapabilir miisin bir test et onu başka bir projede sonra gerçeğe uygula ")
#warning("Esas detay sayfasındaki bilgilere çalışma saati url vs ekleyebilirsin o sayfaya her şey gelmiş oluyor")

struct NearBySearchView: View {
    
    @EnvironmentObject var iosVm:MapiOSViewModel
    @EnvironmentObject var vm:MapViewModel
    @EnvironmentObject var searchViewModel:SearchViewModel
    @EnvironmentObject var locationManager:LocationManagerDummy
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Yakındakiler")
                .font(.system(size: 13))
                .foregroundStyle(Color(.systemGray))
                .padding(.horizontal,20)
            Divider()
            List{
                Button {
                    let currentRegion = locationManager.region
                    // Kameranın uzaklaştırılması için span değerlerini artırıyoruz.
                    let zoomedOutRegion = MKCoordinateRegion(center: currentRegion.center,
                                                                 span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 8,
                                                                                        longitudeDelta: currentRegion.span.longitudeDelta * 8))
                    
                    // Kamerayı güncelle
                    DispatchQueue.main.async {
                        iosVm.cameraPosition = MapCameraPosition.region(zoomedOutRegion)
                        print("camer güncellendi")
                    }
                    iosVm.searchForLocalPlaces(for: "Hastane")
                    withAnimation {
                        
                        vm.endingOffSetY = 0.0
                    }
                  
                } label: {
                    HStack{
                        Image(systemName: "cross.circle.fill")
                        Text("Hastane")
                    }
                    
                }
                Button {
                    let currentRegion = locationManager.region
                    // Kameranın uzaklaştırılması için span değerlerini artırıyoruz.
                    let zoomedOutRegion = MKCoordinateRegion(center: currentRegion.center,
                                                                 span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 8,
                                                                                        longitudeDelta: currentRegion.span.longitudeDelta * 8))
                    
                    // Kamerayı güncelle
                    DispatchQueue.main.async {
                        iosVm.cameraPosition = MapCameraPosition.region(zoomedOutRegion)
                    }
                    iosVm.searchForLocalPlaces(for: "Benzinlik")
                    withAnimation {
                        
                        vm.endingOffSetY = 0.0
                    }
                    
                } label: {
                    HStack{
                        Image(systemName: "car.circle.fill")
                        Text("Benzinlik")
                    }
                    
                }
                Button {
                    let currentRegion = locationManager.region
                    // Kameranın uzaklaştırılması için span değerlerini artırıyoruz.
                    let zoomedOutRegion = MKCoordinateRegion(center: currentRegion.center,
                                                                 span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 8,
                                                                                        longitudeDelta: currentRegion.span.longitudeDelta * 8))
                    
                    // Kamerayı güncelle
                    DispatchQueue.main.async {
                        iosVm.cameraPosition = MapCameraPosition.region(zoomedOutRegion)
                    }
                    iosVm.searchForLocalPlaces(for: "Otel")
                    withAnimation {
                        
                        vm.endingOffSetY = 0.0
                    }
                  
                } label: {
                    HStack{
                        Image(systemName: "bed.double.circle.fill")
                        Text("Otel")
                    }
                    
                }
                Button {
                    let currentRegion = locationManager.region
                    // Kameranın uzaklaştırılması için span değerlerini artırıyoruz.
                    let zoomedOutRegion = MKCoordinateRegion(center: currentRegion.center,
                                                                 span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 8,
                                                                                        longitudeDelta: currentRegion.span.longitudeDelta * 8))
                    
                    // Kamerayı güncelle
                    DispatchQueue.main.async {
                        iosVm.cameraPosition = MapCameraPosition.region(zoomedOutRegion)
                    }
                    iosVm.searchForLocalPlaces(for: "Eczane")
                    withAnimation {
                        
                        vm.endingOffSetY = 0.0
                    }
                    
                } label: {
                    HStack{
                        Image(systemName: "pill.circle.fill")
                        Text("Eczane")
                    }
                    
                }
                Button {
                    let currentRegion = locationManager.region
                    // Kameranın uzaklaştırılması için span değerlerini artırıyoruz.
                    let zoomedOutRegion = MKCoordinateRegion(center: currentRegion.center,
                                                                 span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 8,
                                                                                        longitudeDelta: currentRegion.span.longitudeDelta * 8))
                    
                    // Kamerayı güncelle
                    DispatchQueue.main.async {
                        iosVm.cameraPosition = MapCameraPosition.region(zoomedOutRegion)
                    }
                    
                    iosVm.searchForLocalPlaces(for: "ATM")
                    withAnimation {
                        
                        vm.endingOffSetY = 0.0
                    }
                 
                } label: {
                    HStack{
                        Image(systemName: "creditcard.circle.fill")
                        Text("ATM")
                    }
                    
                }
                
                
                
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
        }
        .frame(maxHeight: 250)
        .padding(.top,10)
    }
}


#Preview {
    NearBySearchView()
}
