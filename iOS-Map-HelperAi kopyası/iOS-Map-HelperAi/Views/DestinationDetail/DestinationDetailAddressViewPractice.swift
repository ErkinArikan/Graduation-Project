//
//  DestinationDetailAddressViewPractice.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 23.09.2024.
//

import SwiftUI
import MapKit

struct DestinationDetailAddressViewPractice: View {
//    @EnvironmentObject var searchViewModel:SearchViewModel
//    @EnvironmentObject var directionsViewModel:DirectionViewModel
    
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @Binding var mapSelection:MKMapItem?
    
    @Environment(\.modelContext) var context
    var body: some View {
        VStack(alignment:.leading) {
            Text(mapSelection?.placemark.name ?? "")
                .font(.system(size:22))
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.top)
            
            Text("\(mapSelection?.placemark.title ?? ""), \(mapSelection?.placemark.subtitle ?? "")")
                .font(.system(size: 15))
                .foregroundStyle(Color.gray)
                .padding(.horizontal)
        }

    }
    

}


//#Preview {
//    DestinationDetailAddressViewPractice()
//}
