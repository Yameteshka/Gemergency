import SwiftUI
import CoreLocation
import MapKit

@MainActor
final class LocationController : NSObject, ObservableObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    @ObservationIgnored let geocoder = CLGeocoder()

    var userLocation: CLLocation? {
        didSet {
            if let location = userLocation {
                reverseGeocode(location: location)
            }
        }
    }
    @Published var city: String?
    @Published var country: String?
    @Published var countryCode: String?
    @Published var currentLocale: Locale?
    @Published var isAuthorized: Bool = false
    private let countryToLanguageMap: [String: String] = ["RU": "ru", "US": "en", "GB": "en", "DE": "de","FR": "fr", "JP": "ja", "ES": "es", "PT": "pt", "ZH": "zh", "HI": "hi", "AR": "ar"]

    override init() {
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    private func reverseGeocode(location: CLLocation) {
        guard city == nil, country == nil else { return }

        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                
                print("Ошибка геокодирования: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("Не удалось найти метку местоположения.")
                return
            }
            
            self.city = placemark.locality
            self.country = placemark.country
            self.countryCode = placemark.isoCountryCode
            
            if let code = self.countryCode, let lang = self.countryToLanguageMap[code] {
                self.currentLocale = Locale(identifier: lang)
            } else {
                self.currentLocale = .current
            }
        }
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userLocation == nil {
             userLocation = locations.first
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.startUpdatingLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            isAuthorized = false
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Ошибка CLLocationManager: \(error)")
    }
}
