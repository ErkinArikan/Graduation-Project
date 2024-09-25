//
//  RouteViewDummy.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 8.09.2024.
//

import SwiftUI
import AlertToast
import MapKit
struct DestinationDetailsView: View {
    #warning("Starred eklenmesini sonsuza kadar olmasın onu engelle ")
    #warning("toast message gözükmedi bi ona bak yarın ")
    

    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @EnvironmentObject var iosVm:MapiOSViewModel
    
    
    @Binding var mapSelection:MKMapItem?
    @Binding var show:Bool
    
    @Binding var getDirections:Bool
    @Binding var tahminiSüre:Double
    @Binding var expectecDistance:Double

    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment:.leading,spacing: 3) {
               
                DestinationDetailTopView()
                
                Button(action: {
                    vm.showToast.toggle()
                }, label: {
                    Text(" toast ")
                })

                DestinationDetailAddressViewPractice(mapSelection: $mapSelection)
                
                
                DestinationDetailsButtonsViewPractice(getDirections: $getDirections, show: $show, mapSelection: $mapSelection)
                
                VStack{
                    Text(" Tel:\(mapSelection?.phoneNumber ?? "000 000 000")")
//                    Text("\(String(describing: mapSelection?.url ?? URL("sdasd")) )")
                }
                DestinationDetailFooterViewPractice( mapSelection: $mapSelection)
                
                
                Spacer()
                
                
            }
        }
        
       
        .frame(maxWidth: .infinity,maxHeight:.infinity)
        .cornerRadius(30)
        .animation(.easeInOut, value: vm.showDestinationDetailsView)  // Kapatma animasyonu için
    }
    
       
    
}



#Preview {
    DestinationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(false), tahminiSüre:.constant(0.0) , expectecDistance: .constant(0.0))
        .environmentObject(AddressManager())
        .environmentObject(LocationManagerDummy())
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(MapiOSViewModel())
}

