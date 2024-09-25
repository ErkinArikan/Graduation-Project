//
//  iOS_Map_HelperAiApp.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import SwiftUI
import SwiftData

@main
struct iOS_Map_HelperAiApp: App {
    @StateObject var mapViewModel:MapViewModel = MapViewModel(locationManager: LocationManagerDummy())
    @StateObject var locationManagerDummy:LocationManagerDummy = LocationManagerDummy()
    @StateObject var iosVm:MapiOSViewModel = MapiOSViewModel()
    @StateObject var searchViewModel:SearchViewModel = SearchViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            DistrubutionMapDummy()
                .environmentObject(mapViewModel)
                .environmentObject(locationManagerDummy)
                .environmentObject(iosVm)
                .environmentObject(searchViewModel)
        }
        .modelContainer(for: [LastSearchedPlaces.self])

        
    }
}
