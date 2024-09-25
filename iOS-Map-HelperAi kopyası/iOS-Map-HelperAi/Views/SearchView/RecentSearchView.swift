//
//  RecentSearchView.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 23.09.2024.
//

import SwiftUI
import SwiftData
import MapKit

struct RecentSearhView: View {
    @EnvironmentObject var vm: MapViewModel
    @Environment(\.modelContext) var context
    
    
    // DB'yi kullanabilmek için gerekli
    @Query(sort: \LastSearchedPlaces.timestamp) private var items: [LastSearchedPlaces]
    
    @EnvironmentObject var searchViewModel:SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Son Arananlar")
                .font(.system(size: 13))
                .foregroundStyle(Color(.systemGray))
                .padding(.horizontal, 20)
            Divider()
            
            List {
                ForEach(items.reversed()) { item in
                    VStack(alignment: .leading) {
                        Button(action: {
                            handleItemSelection(item: item)
                        }, label: {
                            HStack {
                                Image(systemName: "location.magnifyingglass")
                                Text(item.poiadi)
                                    .lineLimit(1) // Metni tek satırda sınırla
                                    .truncationMode(.tail) // Metni sağdan kes ve '...' ekle
                                Spacer()
                                Spacer()
                                Button {
                                    withAnimation {
                                        context.delete(item)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                } //:Button
                            }
                        })
                        .foregroundStyle(.black)
                        
                        .padding(.top, 5)
                    } //:VStack
                    .frame(maxWidth: .infinity, alignment: .leading)
                } //:Foreach
            } //:List
            .scrollDismissesKeyboard(.immediately)
            .listStyle(.plain)
        } //: VStack
        .padding(.top)
        .ignoresSafeArea(.keyboard)
        
        
        
    }
    // Fonksiyon: Seçilen öğe ile yapılan işlemleri yönetir
        func handleItemSelection(item: LastSearchedPlaces) {
            // Son arananlarda seçili yerin lat ve lon bilgileri
            let recentSearchCompletion = SearchCompletions(title: item.poiadi, subTitle: item.il)
            print("item il:\(item.poiadi)")
            print("item ilçe: \(item.ilce)")
            vm.endingOffSetY = 0.0
            searchViewModel.searchText = ""
            searchViewModel.didTapOnCompletion(recentSearchCompletion)
            

            // Kamerayı seçili lokasyona odaklama
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            withAnimation(.spring(duration: 0.3)) {
                // Search view kapansın
                vm.isSearchViewShow = false
                // Route view açılsın
                vm.showDestinationDetailsView = true
                // Kamera animasyonlu gelsin
                vm.cameraRegion = EquatableCoordinateRegion(region: newRegion)
            }
        }
    
    
}

#Preview {
    RecentSearhView()
        .environmentObject(MapViewModel(locationManager: LocationManagerDummy()))
        .environmentObject(SearchViewModel())
        .environmentObject(MapiOSViewModel())
}
