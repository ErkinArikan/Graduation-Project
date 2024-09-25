import Foundation
import Combine


// Aratarak bulduğumuz işlemler burda

class AddressManager: ObservableObject {
    @Published var suggestions: [AddressSuggestionModel] = []

   
    
    func fetchAddressSuggestions(query: String,locationLat: Double, locationLon:Double) {
        // URL'yi query parametresiyle oluştur
        let urlString = "https://bms.basarsoft.com.tr/Service/api/v1/AutoSuggestion/Search?accId=8z2n3ovxdUam7aA4_dBiHg&appCode=Tg-QQavfDkGmDdmOZ5NmlA&words=\(query)&limit=8&lat=\(locationLat)&lon=\(locationLon)&type=1&uk=false"
        
        
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let rawArray = try JSONSerialization.jsonObject(with: data, options: []) as! [[Any]]
                let suggestions = try rawArray.map { rawLocation -> AddressSuggestionModel in
                    return try decoder.decode(AddressSuggestionModel.self, from: JSONSerialization.data(withJSONObject: rawLocation))
                }
                
                DispatchQueue.main.async {
                    self.suggestions = suggestions
                }
            } catch {
                print("JSON decoding failed: \(error)")
            }
        }.resume()
    }
}
