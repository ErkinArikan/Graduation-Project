import Foundation

class RotaManager: ObservableObject {
    static let shared = RotaManager()
    
    @Published var isLoading: Bool = false
    
    private let apiKey: String
    private let baseURL: URL
    
    private init() {
        // API Key
        self.apiKey = "680d06d716f741ca9e9990e162537d42"
        // Swagger'dan aldığınız URL'yi kullanın
        self.baseURL = URL(string: "https://servicesdev.basarsoft.com.tr/api/Basar/BasarRouting?apiKey=e59c720692894f0ea9015679f4aa3dbc")!
    }
    
    //MARK: - CAR BODY
    func createCarRoute(origin: String, destination: String, completion: @escaping (Result<RotaResponse, Error>) -> Void) {
        
        isLoading = true
        
        let parameters: [String: Any] = [
            "origin": origin,
            "destination": destination,
            "wayPoints": "",
            "requestOptions": [
                "liveTraffic": false,
                "alternativeRoute": true,
                "alternativeCount": 1,
                "snapMaxDistance": 500,
                "costType": 1,
                "isCar": true,
                "isTruck": false,
                "isPedestrian": false,
                "avoidToolRoad": false,
                "avoidHighway": false,
                "useFerry": false,
                "avoidPrivateRoad": false,
                "avoidRestrictedRoad": false,
                "useBoat": false,
                "isBus": false,
                "getManifest": false
            ]
        ]
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                self.isLoading = false // İstek tamamlandığında yükleme bitiyor
            }
            
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                completion(.failure(error))
                return
            }
            
            // Ham veriyi yazdır
            if let dataString = String(data: data, encoding: .utf8) {
                print("Ham Yanıt: \(dataString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(RotaResponse.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - PEDESTERIAN BODY
    
    func createPedestrianRoute(origin: String, destination: String, completion: @escaping (Result<RotaResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "origin": origin,
            "destination": destination,
            "wayPoints": "",
            "requestOptions": [
                "liveTraffic": false,
                "alternativeRoute": false,
                "alternativeCount": 0,
                "snapMaxDistance": 500,
                "costType": 1,
                "isCar": false, // Araç yerine yaya
                "isTruck": false,
                "isPedestrian": true, // Yaya olarak ayarla
                "avoidToolRoad": false,
                "avoidHighway": false,
                "useFerry": false,
                "avoidPrivateRoad": false,
                "avoidRestrictedRoad": false,
                "useBoat": false,
                "isBus": false,
                "getManifest": false
            ]
        ]
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                completion(.failure(error))
                return
            }
            
            // Ham veriyi yazdır
            if let dataString = String(data: data, encoding: .utf8) {
                print("Ham Yanıt: \(dataString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(RotaResponse.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

 


}





