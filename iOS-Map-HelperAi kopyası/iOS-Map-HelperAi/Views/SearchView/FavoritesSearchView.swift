//
//  FavoritesSearchView.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 23.09.2024.
//

import SwiftUI

struct FavoritesSearchView: View {
    
    @EnvironmentObject var locationManager:LocationManagerDummy
    @EnvironmentObject var vm:MapViewModel
//    @Query(sort:\FavoriteLocationDB.poiadi) private var items:[FavoriteLocationDB]
    var body: some View {
        VStack(alignment:.leading){
            Text("Favoriler")
                .font(.system(size: 13))
                .foregroundStyle(Color(.systemGray))
                .padding(.horizontal,20)
            
            
            ScrollView(.horizontal) {
                HStack{
                    Button(action: {
                        withAnimation {
//                            if items.count > 0 {
//
//                                vm.choosedLat = items.first?.lat
//
//                                //Son arananlarda seçili yerin lon'u
//                                vm.choosedLong = items.first?.lon
//                                // //Son arananlarda seçili yerin adı
//                                vm.choosedPlaceName = items.first?.poiadi ?? ""
//                                // //Son arananlarda seçili yerin ili
//                                vm.choosedPlaceIl = items.first?.il ?? ""
//                                // //Son arananlarda seçili yerin ilçesi
//                                vm.choosedPlaceilce = items.first?.ilce ?? ""
//                                //ending off set 0 olursa sheet istediğim konumdan başlar
//                                vm.endingOffSetY = 0.0
//                                // bu değere aktarmamın sebebi rota oluşturulurken seçili adresin gözükmesi için sadece string
//
//
//                                vm.destination = "\(items.first?.lat ?? 0.0) \(items.first?.lon ?? 0.0))"
//
//
//
//                                let newRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: items.first!.lat, longitude:
//                                                                                                    items.first!.lon),
//                                                                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//
//                                withAnimation(.spring(duration:0.3)) {
//                                    //son aranan seçildikten sonra search view kapansın
//                                    vm.isSearchViewShow = false
//                                    // route view açılsın
//                                    vm.showDestinationDetailsView = true
//                                    //camera animasoyonlu gelsin
//                                    vm.cameraRegion = EquatableCoordinateRegion(region: newRegion)
//
//                                    vm.addFavoritesViewShow = false
//                                }
//                            }else{
//                                vm.addFavoritesViewShow = true
//                                vm.endingOffSetY = -400
//                                vm.isSearchViewShow = false
//                            }
                           
                        }
                    }, label: {
                        
                        Image(systemName: "house.fill")
                        Text("Ev")
                        
                        
                        
                    })
                    .foregroundStyle(.black)
                    .padding()
                    .padding(.horizontal, 5)
                    // Köşeleri yuvarla
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Çerçeve ile uyumlu bir kenar yapısı
                            .stroke(Color.black, lineWidth: 1) // Gri kenarlık ve genişliği 2 piksel
                    )
                    
                    
                    Button(action: {
                        
                        
                        
                    }, label: {
                        
                        Image(systemName: "plus")
                        Text("Ekle")
                        
                        
                        
                    })
                    .foregroundStyle(.black)
                    .padding()
                    .padding(.horizontal, 5)
                    // Köşeleri yuvarla
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Çerçeve ile uyumlu bir kenar yapısı
                            .stroke(Color.black, lineWidth: 1) // Gri kenarlık ve genişliği 2 piksel
                    )
                    
                } //:HStack
                .padding(.horizontal)
                .padding(5)
                
            }//:Scroll View
            //                    .padding()
        }
    }
}
#Preview {
    FavoritesSearchView()
}
