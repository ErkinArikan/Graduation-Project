//
//  SearchViewTop.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 5.09.2024.
//

import SwiftUI
import MapKit
struct DestinationDetailTopView: View {
//    @EnvironmentObject var searchViewModel:SearchViewModel
//    @EnvironmentObject var directionsViewModel:DirectionViewModel
    
    @EnvironmentObject var vm:MapViewModel
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var iosVm:MapiOSViewModel
    
    var body: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 60, height: 4)
                .padding(.top, 4)
                .padding(.leading, 45)
                .foregroundStyle(Color(.systemGray2))
            Spacer()
            Button {
                withAnimation(.spring) {
                    
                    DispatchQueue.main.async {
                        vm.endingOffSetY = 0
                        vm.showDestinationDetailsView = false
                        vm.isDirectionsShow = false
                        vm.showPolyline = false
                        vm.destinationSelected = false
                        iosVm.getDirections = false
                        
                        iosVm.cameraPosition = MapCameraPosition.region(locationManager.region)
                        iosVm.exSearchResul.removeAll(keepingCapacity: false)
                        
                    }
                    print("camera Region updated: \(vm.cameraRegion)")
                   
                    
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
            }
            .frame(width: 20, height: 20)
            .padding(.top, 4)
            .padding(.trailing, 20)
           
        }
        .padding(.top)
        
    }
}

