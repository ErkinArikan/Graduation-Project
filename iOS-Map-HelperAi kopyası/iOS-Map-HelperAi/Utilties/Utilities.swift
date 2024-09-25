//
//  Utilities.swift
//  iOS-Map-HelperAi
//
//  Created by Erkin Arikan on 20.09.2024.
//

import Foundation

//
//  Extensions.swift
//  IOS-Map-Basarsoft
//
//  Created by Erkin Arikan on 18.07.2024.
//

import Foundation
import MapKit
import SwiftUI


let hapticImpact = UIImpactFeedbackGenerator(style: .medium)




extension String{
    func addLocalizableString(str:String) -> String{
        let path = Bundle.main.path(forResource: str, ofType: "lproj")
        let bundle = Bundle(path: path!)
      return  NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Color {
    static func hex(_ hex: String) -> Color {
        var cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if cleanedHex.hasPrefix("#") {
            cleanedHex.remove(at: cleanedHex.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}


//MARK: - VIEW MODIFIER
struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .frame(height: 50)
            .padding(.horizontal)
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .foregroundColor(textColor)
            .overlay(content: {
                RoundedRectangle(cornerRadius:12, style: .continuous)
                    .stroke(.linearGradient(colors: [Color.black.opacity(0.3),Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
            })
            .font(.custom("Open Sans", size: 16))
            

            .shadow(color: Color(UIColor.systemGray4).opacity(0.2), radius: 20,x:0,y:20)
    }
}

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case  favorites,search, chat
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
       
//            return "gamecontroller.fill"
        case .favorites:
            return "point.bottomleft.forward.to.point.topright.scurvepath.fill"
        case .search:
            return "magnifyingglass"
//        case .game:
        case .chat:
            return "bubble.middle.bottom.fill"
        }
    }
    
    var title: String {
        switch self {
        case .search:
            return "Search"
//        case .game:
//            return "Games"
        case .favorites:
            return "Favorites"
        case .chat:
            return "Movies"
        }
    }
    
    var color: Color {
        switch self {
        case .search:
            return .indigo
        case .favorites:
            return .orange
        case .chat:
            return .teal
        }
    }
}

let backgroundColor = Color.init(white: 0.92)





//MARK: - DENEME UTILITIES

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}


struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    // New property to hold the URL if it exists
    var url: URL?
}

import MapKit
@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }


    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
           completions = completer.results.map { completion in
               // Get the private _mapItem property
               let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

               return .init(
                   title: completion.title,
                   subTitle: completion.subtitle,
                   url: mapItem?.url
               )
           }
       }
    
    
    
    // Direkt aratmalara bastıktan sonra gelenler. Gerçek aratma yapıyor
    
    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .pointOfInterest
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)

        let response = try await search.start()

        return response.mapItems.map { mapItem in
            SearchResult(mapItem: mapItem)
        }
    }
}





struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

