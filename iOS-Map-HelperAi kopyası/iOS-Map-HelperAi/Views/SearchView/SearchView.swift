//
//  SearchView.swift
//  AI-HelperMap
//
//  Created by Erkin Arikan on 5.09.2024.
//

import SwiftUI
import SwiftData
import MapKit

struct SearchView: View {
    

    @EnvironmentObject var iosVm :MapiOSViewModel
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
    @EnvironmentObject var searchViewModel:SearchViewModel
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment:.leading) {
                SearchViewTop(endingOffSetY: $vm.endingOffSetY, isSearchViewShow: $vm.isSearchViewShow)
                    .padding(.bottom,6)

                SearchViewDenemeDummyPractice(
                    searchResults: $iosVm.searchResults,
                    showDetails: $iosVm.showDetails,
                    cameraPosition: $iosVm.cameraPosition, getDirections: $iosVm.getDirections
                )
                // eğer favoriler true ise
                if vm.isFavoritesShowing && vm.searchTapCount == 0 {
                    
                    VStack(alignment:.leading,spacing: 25) {
                        FavoritesSearchView() //:VStack
                            .padding(.top,8)
//                        .animation(.easeInOut(duration: 0.8), value: vm.isFavoritesShowing)
                        
                        VStack(alignment:.leading){
                            Text("Yıldızlanmış Yerler")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(.systemGray))
                                .padding(.horizontal,20)
                        }
                        
                    }
                    
                }else{
                    
                    // eğer tıkladım ve aratma yapıcam ve yazıcaksam son arananları kapatmak için condition
                    if !vm.showDropdown{
                        VStack{
                            
                            
                            RecentSearhView()

                                .frame(maxHeight: 200)
                                
                            
                            NearBySearchView()
                                .padding(.top,8)
//                                .animation(.easeInOut(duration: 0.8), value: !vm.isFavoritesShowing)
                            Spacer()
                        }
                        
                    }
                    
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(30)
        .animation(.easeInOut, value: vm.isSearchViewShow)  // Kapatma animasyonu için
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    SearchView()
        .environmentObject(LocationManagerDummy())
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(MapiOSViewModel())
        .environmentObject(SearchViewModel())
}
