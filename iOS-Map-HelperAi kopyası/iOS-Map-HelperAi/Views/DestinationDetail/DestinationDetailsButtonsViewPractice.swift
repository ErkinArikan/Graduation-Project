//
//  DestinationDetailsButtonsViewPractice.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 23.09.2024.
//

import SwiftUI
import MapKit

struct DestinationDetailsButtonsViewPractice: View {
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @StateObject var rotaManager = RotaManager.shared
    @Binding var getDirections:Bool
    @Binding var show:Bool
    @Binding var mapSelection:MKMapItem?
//    @Binding var showToast:Bool
//    @Binding var toast: Toast?
    var body: some View {
        HStack(spacing:15){
            
        //MARK: - DIRECTIONS BUTTON
            Button(action: {
                //buraya bastığımızda Directions sayfası aktif olmalı.
                withAnimation(.spring(duration: 0.3)){
                    vm.isDirectionsShow.toggle()
                    vm.showDestinationDetailsView = false
                    vm.isSearchViewShow = false
                    getDirections = true
                    show = false
                }
             
                
            }, label: {
                Group{
                    if rotaManager.isLoading {
                        ProgressView("Rota yükleniyor")
                            .tint(.white)
                            .foregroundColor(.white)
                    }
                    else{
                        Text("Directions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    
                }.frame(width:110,height: 30)
                    .padding()
                    .padding(.horizontal,30)
                    .background(Color.black)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .disabled(rotaManager.isLoading)
            })
            
            
            
            //MARK: - SHARE BUTTON
            ZStack{
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                    .shadow(radius: 2)
                
                
                ShareLink("",item: URL(string: "https://maps.apple.com/?ll=\(mapSelection?.placemark.coordinate.latitude ?? 0.0),\(mapSelection?.placemark.coordinate.longitude ?? 0.0)")!)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.leading,7)
                
                
            }
            
            //MARK: - STAR BUTTON
            ZStack{
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                    .shadow(radius: 2)
                
                
                
                Button(action: {
                    vm.showToast.toggle()
                    
//                    let starredItemDB = StarredPlacesDB(poiadi: vm.choosedPlaceName, lat: vm.choosedLat ?? 0.0, lon: vm.choosedLong ?? 0.0, ilce: vm.choosedPlaceilce, il: vm.choosedPlaceIl)
                    withAnimation {
//                        toast = Toast(style: .success, message: "Address Starred", width: 160)
//                        context.insert(starredItemDB)
//                        showToast.toggle()
                    }
                    
                }, label: {
                    Image(systemName: "star")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                })
               
            }
            
            
        }
       
        .padding(.horizontal)
        .padding(.top,25)
    }
}


//#Preview {
//    DestinationDetailsButtonsViewPractice()
//}
