import MapKit
import CoreLocation


//observable object sayesinde değişiklikler gözlemlenebiliyor.
final class LocationManagerDummy: NSObject, ObservableObject {
    
    //Cihazın konumunu almak için kullanılıyor
    private let locationManager = CLLocationManager()
    
    //apple head quarter'a ayarlanmış
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    @Published var isLoading = true // Track loading state
    
    private var isRefiningAccuracy = false // Track if we need to refine accuracy
    
    @Published var currentLocation: CLLocationCoordinate2D? // Store current location

    //lokasyon başlatılırken
    override init() {
        super.init()
        self.locationManager.delegate = self
        //doğruluk oranı
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Start with reduced accuracy
        
        //Uygulamanın başında konum izni durumunu kontrol ediyor. Eğer konum izni varsa, hemen konum isteği başlatılıyor; yoksa kullanıcıdan izin istiyor.
        self.setup()
    }
    
    private func setup() {
       // Konum izni durumuna göre ne yapacağını belirtiyor
        switch locationManager.authorizationStatus {
          
        case .authorizedWhenInUse:
            // İzin varsa, konum isteniyor.
            locationManager.requestLocation()
            
            ///Değişti burası
            startLocationUpdates()
        case .notDetermined:
           // İzin verilmediyse, izin istemek için bir istek gönderiliyor.
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    // Function to refine accuracy after the initial location update
    //Doğruluk Güncelleme Fonksiyonu
    //İlk düşük doğrulukta konum alındıktan sonra daha yüksek doğrulukla konum alımı için tekrar güncelleme isteği başlatılıyor.
    private func refineAccuracy() {
        isRefiningAccuracy = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Switch to high accuracy
        locationManager.requestLocation() // Request location again with better accuracy
    }
    
    // Show the last known location immediately
    //Eğer cihazda en son bilinen bir konum varsa, bu konumu hemen gösteriyor ve koordinatları güncelliyor.
    func showLastKnownLocation() {
        if let lastLocation = locationManager.location {
            region = MKCoordinateRegion(
                center: lastLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            currentLocation = lastLocation.coordinate // Store the last known location
        }
    }
    
    
    
    ///Değişikli
    func startLocationUpdates() {
            locationManager.startUpdatingLocation() // Sürekli konum güncellemelerini başlat
        
        }
    
}


extension LocationManagerDummy: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse else { return }
        // Show the last known location right away
        showLastKnownLocation()
        // Start requesting a more accurate location
        locationManager.requestLocation()
        
        
        ///Değişti
        startLocationUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            currentLocation = location.coordinate // Store the current location
            
            if isRefiningAccuracy {
                // Stop refining once we have an accurate location
                locationManager.stopUpdatingLocation()
                isLoading = false
            } else {
                // Refine accuracy after the initial update
                refineAccuracy()
            }
        }
    }
}
