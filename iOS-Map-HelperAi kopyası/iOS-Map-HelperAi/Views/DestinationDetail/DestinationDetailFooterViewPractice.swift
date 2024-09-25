//
//  DestinationDetailFooterViewPractice.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 23.09.2024.
//

import SwiftUI
import MapKit

struct DestinationDetailFooterViewPractice: View {
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @Binding var mapSelection:MKMapItem?
//    @EnvironmentObject var searchViewModel:SearchViewModel
//    @EnvironmentObject var directionsViewModel:DirectionViewModel
    
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Image(systemName: "star")
                Text("Save to favorites")
            }
            
            HStack{
                Image(systemName: "location")
                Text("\(mapSelection?.placemark.coordinate.latitude ?? 0.0)  \(mapSelection?.placemark.coordinate.longitude ?? 0.0)")
            }
            
            
            
        }
        .padding(.horizontal)
        .padding(.top,50)
    }
}

#Preview {
    DestinationDetailFooterViewPractice( mapSelection: .constant(nil))
}
