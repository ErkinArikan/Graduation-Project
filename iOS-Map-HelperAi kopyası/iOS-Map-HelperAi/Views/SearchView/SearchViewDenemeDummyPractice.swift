import SwiftUI
import MapKit
import SwiftData

struct SearchViewDenemeDummyPractice: View {
    @EnvironmentObject var locationManager: LocationManagerDummy
    @EnvironmentObject var vm: MapViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @FocusState private var isTextFieldFocused: Bool
    @EnvironmentObject var iosVm:MapiOSViewModel
    
    @Binding var searchResults: [SearchResult]
    @Binding var showDetails: Bool
    @Binding var cameraPosition: MapCameraPosition
    @Binding var getDirections:Bool
    @State var isLocalPlacesSearch:Bool = false
    @Environment(\.modelContext) var context
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search Address", text: $searchViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .onChange(of: searchViewModel.searchText) { newValue in
                        vm.showDropdown = !newValue.isEmpty
                        searchViewModel.locationService.update(queryFragment: newValue)
                    }
                    .submitLabel(.search)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) {
                            vm.endingOffSetY = -400
                            isTextFieldFocused = true
                            vm.isFavoritesShowing = false
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") { hideKeyboard() }
                            Button("Search") {   print("Search submitted with text: \(searchViewModel.searchText)")
                                iosVm.searchForLocalPlaces(for: searchViewModel.searchText )}
                        }
                    }
                
                Button {
                    withAnimation(.easeInOut) {
                        vm.endingOffSetY = 0
                        vm.isSearchViewShow = false
                        searchViewModel.searchText = ""
                        searchResults.removeAll()
                        getDirections = false
                        iosVm.exSearchResul.removeAll(keepingCapacity: false)
                    }
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .padding(.leading)
                }
            }
            
            if !searchViewModel.searchText.isEmpty {
                myListView
            }
        }
        .onChange(of: vm.endingOffSetY) { newValue in
            // Eğer endingOffSetY sıfırsa klavyeyi kapat
            
            
            
            if newValue == 0 {
                hideKeyboard()
                vm.searchTapCount = 0
               vm.isFavoritesShowing = true
                print("tap count:\(vm.searchTapCount)")
                print("favorites : \(vm.isFavoritesShowing)")
            }
        }
        .padding(.horizontal)
        .onChange(of: searchViewModel.searchResults) { newResults in
            searchResults = newResults
        }
        .onChange(of: searchViewModel.showDetails) { newValue in
            showDetails = newValue
        }
        .onChange(of: searchViewModel.cameraPosition) { newPosition in
            cameraPosition = newPosition
        }
        .onChange(of: searchViewModel.searchText.isEmpty) { newValue in
            if newValue{
                iosVm.exSearchResul.removeAll(keepingCapacity: false)
            }
        }
        
    }
    
    @ViewBuilder
       private var myListView: some View {
           List {
               ForEach(searchViewModel.locationService.completions) { completion in
                   Button(action: {
                       
                       searchViewModel.didTapOnCompletion(completion)
                       vm.isSearchViewShow = false
                       vm.showDestinationDetailsView = true
                       vm.endingOffSetY = 0.0
                       searchViewModel.searchText = ""
                       
                       
                   }) {
                       VStack(alignment: .leading, spacing: 4) {
                           Text(completion.title).font(.headline).fontDesign(.rounded)
                           Text(completion.subTitle)
                           if let url = completion.url {
                               Link(url.absoluteString, destination: url)
                                   .lineLimit(1)
                           }
                       }
                   }
                   .listRowBackground(Color.clear)
               }
           }
           .listStyle(.plain)
           .scrollDismissesKeyboard(.immediately)
           .scrollIndicators(.hidden)
           
       }
       


}
func hideKeyboard() {
     // Klavyeyi kapatmak için
     UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
 }
