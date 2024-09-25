//
//  DistrubutionMap.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 5.09.2024.
//

import SwiftUI

struct DistrubutionMapDummy: View {
//    @EnvironmentObject var searchViewModel:SearchViewModel
//    @EnvironmentObject var directionsViewModel:DirectionViewModel
//
    
    @EnvironmentObject var vm:MapViewModel
    @EnvironmentObject var locationManager:LocationManagerDummy

    @Environment(\.modelContext) var context
    var body: some View {
        
        ZStack{
            
            MainMapView()
                
            VStack{
                Spacer()
                if !vm.isSearchViewShow  && !vm.showDestinationDetailsView && !vm.isDirectionsShow && !vm.addFavoritesViewShow{
                    // TabBarView1 görünür durumda
                    TabBarView1(isShow: $vm.isSearchViewShow)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: vm.isSearchViewShow)
                        
                } else {
                    // TabBarView1 kayboluyor
                    TabBarView1(isShow: $vm.isSearchViewShow)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: vm.isSearchViewShow)
                        .hidden()
                       
                }
               
            }
           
        }
    }
}

#Preview {
    DistrubutionMapDummy()
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(LocationManagerDummy())
        .environmentObject(MapiOSViewModel())
        .environmentObject(SearchViewModel())
       
        
}
