//
//  RouteViewDirectionDummy.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 9.09.2024.
//

import SwiftUI
import SwiftData
import MapKit

struct DirectionsViewDummy: View {
    
    //PRACTICES
//    @EnvironmentObject var searchViewModel:SearchViewModel
//    @EnvironmentObject var directionsViewModel:DirectionViewModel
    
    
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @Binding var mapSelectionPlace:MKMapItem?
    @EnvironmentObject var iosVm:MapiOSViewModel
   
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment:.leading){
                
                DestinationDetailTopView()
                
                DirectionAddressView(mapSelectionPlace: $mapSelectionPlace)
                
                Divider()
                
                DirectionsButtonsView()
                
                

                
                Spacer()
            }
        }
        .onAppear(perform: {
            print("route sayısı : \(iosVm.routeInfos.count)")
        })
        .frame(maxWidth: .infinity,maxHeight:.infinity)
        .cornerRadius(30)
        .animation(.easeInOut, value: vm.showDestinationDetailsView)  // Kapatma animasyonu için
    }
}

#Preview {
    DirectionsViewDummy(mapSelectionPlace: .constant(nil))
        .environmentObject(AddressManager())
        .environmentObject(LocationManagerDummy())
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(MapiOSViewModel())
    
    //Practices
//        .environmentObject(SearchViewModel())
//        .environmentObject(DirectionViewModel())
}

//MARK: - ADDRESS

struct DirectionAddressView: View {
    @EnvironmentObject var vm:MapViewModel
    @Binding var mapSelectionPlace:MKMapItem?
    var body: some View {
        HStack(alignment:.top){
            
            VStack(alignment:.center){
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.top,5)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width:2,height: 11)
                
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width:2,height: 11)
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.bottom,7)
                
                
            }
            
            
            VStack(alignment:.leading,spacing: 11) {
                
                // First Text with Background
                ZStack(alignment:.leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 280, height: 35)
                    
                    Text("My Location")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                }
                
                // Second Text with Background
                ZStack(alignment:.leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 280, height: 35)
                    
                 
//                    Text("ODTÜ Teknokent Gümüş Bloklar Çankaya ankara Çayyolu")
                    Text(mapSelectionPlace?.name ?? "Address yok")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.trailing,60)
                }
                
                // Third Text with Background
                ZStack(alignment:.leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 280, height: 35)
                    
                    Text("Add Stop")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                }
            }
            
            Spacer()
        }
        .padding(.leading)
        .padding(.top)
    }
}



//MARK: - BUTTONS (Car & PEDESTERIAN)
struct DirectionsButtonsView: View {
    @EnvironmentObject var iosVm:MapiOSViewModel

    
    @State private var selectedTransport: TransportType = .car // Varsayılan olarak araba seçili
        
        enum TransportType {
            case car
            case walk
        }
    
    
    var body: some View {
        HStack{
            Spacer()
            
            VStack {
                Button(action: {
                    selectedTransport = .car
                }) {
                    VStack {
                        Image(systemName: "car.fill")
                            .foregroundColor(selectedTransport == .car ? .black : .gray) // Seçili olunca mavi, değilse gri
                        
                        if selectedTransport == .car {
                            Rectangle()
                                .fill(Color.black)
                                .frame(height:1)
                                .padding(.bottom)
                                .padding(.top,6)// Altını maviyle doldur
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 1) // Boş bırak
                                .padding(.bottom)
                                .padding(.top,6)
                        }
                        
                        
                        ForEach(iosVm.routeInfos){ routeInfo in
                            Button {
                                
                            } label: {
                                VStack(alignment:.leading){
                                    Text("\(routeInfo.readableTime)" )
                                    Text(" \(routeInfo.distanceKm, specifier: "%.2f")km")
                                }
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(15)
                            }
                            .disabled(selectedTransport == .walk)
                        }
                        
                        
                        
                    }
                    
                }
               
                    
                   
                
                
                
            }
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            VStack{
                
                Button(action: {
                    selectedTransport = .walk
                }) {
                    VStack {
                        Image(systemName: "figure.walk")
                            .foregroundColor(selectedTransport == .walk ? .black : .gray) // Seçili olunca mavi, değilse gri
                        if selectedTransport == .walk {
                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 1)
                                .padding(.bottom)
                                .padding(.top,6)// Altını maviyle doldur
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 1) // Boş bırak
                                .padding(.bottom)
                                .padding(.top,6)
                        }
                        
                        Button {
                            
                        } label: {
                            VStack(alignment:.leading){
                                Text("\(iosVm.readableTime)" )
                                Text("\(String(format: "%.2f", iosVm.distance)) km")
                            }
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(15)
                        }
                        .disabled(selectedTransport == .car)
                    }
                }
               
                
                
                
               
            }
           
            
            Spacer()
        }
        
        .padding()
    }
}
