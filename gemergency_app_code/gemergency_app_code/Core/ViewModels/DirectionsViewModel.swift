import SwiftUI
import MapKit
import Combine

@MainActor
final class DirectionsViewModel : ObservableObject {
    
    @Published var route: MKRoute?
    @Published var destination: MKMapItem?
    @Published var isSettingsMenuExpanded: Bool = false
    @Published var isDirectionsMenuExpanded: Bool = false
    @Published var wrongPathCreationError: Bool = false
    @Published var pathType: PathType = .walking
    @Published var latitudeMeters: Double = 1_0000
    @Published var longitudinalMeters: Double = 10_000
    
    public func getDirection(to direction: DestinationPlaces, from coordinates: CLLocationCoordinate2D, locale: String) async {
        var query: String = ""
        switch direction {
        case .hospital:
            if locale == "ru" {
                query = "больница"
            } else if locale == "en" {
                query = "hospital"
            } else if locale == "de" {
                query = "Krankenhaus"
            } else if locale == "fr" {
                query = "hôpital"
            } else if locale == "ja" {
                query = "病院"
            } else if locale == "es" {
                query = "hospital"
            } else if locale == "pt" {
                query = "hospital"
            } else if locale == "zh" {
                query = "医院"
            } else if locale == "hi" {
                query = "अस्पताल"
            } else if locale == "ar" {
                query = "مستشفى"
            }
        case .police:
            if locale == "ru" {
                query = "полицейский участок"
            } else if locale == "en" {
                query = "police station"
            } else if locale == "de" {
                query = "Polizeistation"
            } else if locale == "fr" {
                query = "commissariat de police"
            } else if locale == "ja" {
                query = "警察署"
            } else if locale == "es" {
                query = "comisaría de policía"
            } else if locale == "pt" {
                query = "delegacia de polícia"
            } else if locale == "zh" {
                query = "警察局"
            } else if locale == "hi" {
                query = "पुलिस थाना"
            } else if locale == "ar" {
                query = "مركز الشرطة"
            }
        case .fireStation:
            if locale == "ru" {
                query = "пожарная часть"
            } else if locale == "en" {
                query = "fire station"
            } else if locale == "de" {
                query = "Feuerwache"
            } else if locale == "fr" {
                query = "caserne de pompiers"
            } else if locale == "ja" {
                query = "消防署"
            } else if locale == "es" {
                query = "estación de bomberos"
            } else if locale == "pt" {
                query = "corpo de bombeiros"
            } else if locale == "zh" {
                query = "消防局"
            } else if locale == "hi" {
                query = "अग्निशमन केंद्र"
            } else if locale == "ar" {
                query = "محطة الإطفاء"
            }
        }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.region = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: latitudeMeters,
            longitudinalMeters: longitudinalMeters
        )
        
        do {
            let search = MKLocalSearch(request: searchRequest)
            let response = try await search.start()
            
            guard let closestPoint = response.mapItems.first else {
                withAnimation(.smooth) {
                    self.wrongPathCreationError = true
                }
                
                print("[Error]: No destinations found!")
                return
            }
            
            self.destination = closestPoint
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            directionRequest.destination = closestPoint
            directionRequest.transportType = pathType.transportType
            
            let directions = MKDirections(request: directionRequest)
            let routeResponse = try await directions.calculate()
            
            if let route = routeResponse.routes.first {
                self.route = route
            } else {
                withAnimation(.smooth) {
                    self.wrongPathCreationError = true
                }
                
                print("[Error]: Couldn't create a route!")
            }
        } catch {
            withAnimation(.smooth) {
                self.wrongPathCreationError = true
            }
            
            print("[Fatal error]: Couldn't get direction or route! \(error.localizedDescription)")
        }
    }
    
    public func clear() {
        self.route = nil
        self.destination = nil
        self.wrongPathCreationError = false
    }
}
