//
//  DirectionsTopView.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 9.09.2024.
//

import SwiftUI

struct DirectionsTopView: View {
    
    
    //PRACTICES
//    @EnvironmentObject var searchViewModel:SearchViewModel
//    @EnvironmentObject var directionsViewModel:DirectionViewModel
    
    
    @EnvironmentObject var vm:MapViewModel
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
                withAnimation(.easeInOut) {
                   vm.endingOffSetY = 0
                   vm.showDestinationDetailsView = false
                    vm.isDirectionsShow = false
                    vm.showPolyline = false
                    vm.destinationSelected = false
                    iosVm.getDirections = false
                    print("get direction:\(iosVm.getDirections )")
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


