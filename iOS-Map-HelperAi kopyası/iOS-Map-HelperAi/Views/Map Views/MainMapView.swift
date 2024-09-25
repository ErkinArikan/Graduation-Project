//
//  MainMapView.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import SwiftUI

struct MainMapView: View {
    
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @EnvironmentObject var iosVm:MapiOSViewModel
    var body: some View {
        ZStack{
            MapView()
            
            if vm.isSearchViewShow{
                SearchView()
                    .cornerRadius(20)
                    .offset(y: vm.startingOffSetY)
                    .offset(y: vm.currentDragOffSetY)
                    .offset(y: vm.endingOffSetY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    let newOffset = value.translation.height
                                    // Limit upward movement
                                    if newOffset < 0 {
                                        vm.currentDragOffSetY = max(newOffset, -300)
                                    } else {
                                        vm.currentDragOffSetY = newOffset
                                    }
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    // Fix position when reaching a certain threshold during upward drag
                                    if vm.currentDragOffSetY < -150 {
                                        vm.endingOffSetY = -vm.startingOffSetY + 200
                                    } else {
                                        vm.endingOffSetY = 0
                                    }
                                    vm.currentDragOffSetY = 0
                                }
                            }
                    )
                    .shadow(radius: 7)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5), value: vm.isSearchViewShow)
            }
            
            if vm.showDestinationDetailsView{
                if let selectedLocation = iosVm.selectedLocation{
                    DestinationDetailsView(mapSelection: .constant(selectedLocation.mapItem),
                                           show: $iosVm.showDetails,
                                           getDirections: $iosVm.getDirections,
                                           tahminiSüre: $iosVm.travelTimeMinutes,
                                           expectecDistance: $iosVm.distance)
                    
                    
                    .cornerRadius(20)
                    .offset(y: vm.startingOffSetY)
                    .offset(y: vm.currentDragOffSetY)
                    .offset(y: vm.endingOffSetY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    let newOffset = value.translation.height
                                    // Limit upward movement
                                    if newOffset < 0 {
                                        vm.currentDragOffSetY = max(newOffset, -300)
                                    } else {
                                        vm.currentDragOffSetY = newOffset
                                    }
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    // Fix position when reaching a certain threshold during upward drag
                                    if vm.currentDragOffSetY < -150 {
                                        vm.endingOffSetY = -vm.startingOffSetY + 200
                                    } else {
                                        vm.endingOffSetY = 0
                                    }
                                    vm.currentDragOffSetY = 0
                                }
                            }
                    )
                    .shadow(radius: 7)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5), value: vm.showDestinationDetailsView)
                }
                
                
                
            }
            else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
            
            if vm.isDirectionsShow{
                if let selectedLocation = iosVm.selectedLocation{
                    DirectionsViewDummy(mapSelectionPlace: .constant(selectedLocation.mapItem))
                    .cornerRadius(20)
                    .offset(y: vm.startingOffSetY)
                    .offset(y: vm.currentDragOffSetY)
                    .offset(y: vm.endingOffSetY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    let newOffset = value.translation.height
                                    // Limit upward movement
                                    if newOffset < 0 {
                                        vm.currentDragOffSetY = max(newOffset, -300)
                                    } else {
                                        vm.currentDragOffSetY = newOffset
                                    }
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    // Fix position when reaching a certain threshold during upward drag
                                    if vm.currentDragOffSetY < -150 {
                                        vm.endingOffSetY = -vm.startingOffSetY + 200
                                    } else {
                                        vm.endingOffSetY = 0
                                    }
                                    vm.currentDragOffSetY = 0
                                }
                            }
                    )
                    .shadow(radius: 7)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5), value: vm.isDirectionsShow)
            }
            
            
        }
        }
    }
}

#Preview {
    MainMapView()
        .environmentObject(LocationManagerDummy())
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(MapiOSViewModel())
}
