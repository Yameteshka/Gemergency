import SwiftUI
import MapKit

public struct MapItemInfoSubview: View {
    
    let destination: MKMapItem?
    let userCoordinates: CLLocationCoordinate2D
    let pathType: PathType
    
    init(ofDestination destination: MKMapItem?, with userCoordinates: CLLocationCoordinate2D, and pathType: PathType) {
        self.destination = destination
        self.userCoordinates = userCoordinates
        self.pathType = pathType
    }
    
    @State private var timeInterval: TimeInterval?
    
    public var body: some View {
        Group {
            if let destination = destination {
                VStack(alignment: .leading, spacing: 12) {
                    Text(destination.name ?? "No emergency name")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(Color.primary)
                        .textSelection(.enabled)
                    
                    Text("Address: \(destination.placemark.title ?? "No address")")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.secondary)
                        .textSelection(.enabled)
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Expected time")
                                .foregroundStyle(Color.primary)
                                .font(.system(size: 12, weight: .medium))
                            
                            let formattedTimeInterval = formatTimeInterval()
                            let value = formattedTimeInterval.1
                            
                            if formattedTimeInterval.0 == "Hours" {
                                Text("^[\(value) hour](inflect: true)")
                                    .foregroundStyle(Color.primary)
                                    .font(.system(size: 28, weight: .black))
                            } else {
                                Text("^[\(value) minute](inflect: true)")
                                    .foregroundStyle(Color.primary)
                                    .font(.system(size: 28, weight: .black))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background {
                            Image(formatTimeInterval().0 == "Hours" ? "deadline_hours" : "deadline_minutes")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.845)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Radius")
                                .foregroundStyle(Color.primary)
                                .font(.system(size: 12, weight: .medium))
                            
                            Text(String(format: "%.2f km", computeDistance()))
                                .foregroundStyle(Color.primary)
                                .font(.system(size: 28, weight: .black))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray.opacity(0.25), lineWidth: 1.5)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background.opacity(0.987))
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                            }
                            .compositingGroup()
                        }
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 38)
                .padding(.bottom, 15)
            } else {
                ContentUnavailableView(
                    "No Emergency Service",
                    systemImage: "xmark.shield",
                    description: Text("It seems like you have no need to get to any emergency service. If you need that one, you have to choose from the menu")
                )
            }
        }
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 80, height: 5)
                .foregroundStyle(Color.secondary.opacity(0.5))
                .padding(12)
        }
        .task(id: destination?.placemark) {
            guard let destination = destination else {
                return
            }
            
            do {
                timeInterval = try await computeApproximateTime(
                    to: destination,
                    from: userCoordinates
                )
            } catch {
                print("error")
            }
        }
    }
    
    private func computeDistance() -> Double {
        guard
            let destination = destination,
            let endLocation = destination.placemark.location
        else {
            return 0
        }
        
        let startLocation = CLLocation(
            latitude: userCoordinates.latitude,
            longitude: userCoordinates.longitude
        )
        
        let distance = startLocation.distance(from: endLocation) / 1000.0
        return distance
    }
    
    private func formatTimeInterval() -> (String, Int) {
        if let timeInterval = timeInterval {
            let time = (Int(timeInterval) / 3600, (Int(timeInterval) % 3600) / 60, Int(timeInterval) % 60)
            
            if time.0 != 0 && time.1 == 0 || time.0 != 0 && time.1 != 0 {
                return ("Hours", time.1 >= 30 ? time.0 + 1 : time.0)
            }
            
            if time.0 == 0 && time.1 != 0 {
                return ("Minutes", time.2 >= 30 ? time.1 + 1 : time.1)
            }
        }
        
        return ("Minutes", 0)
    }
    
    private func computeApproximateTime(
        to destination: MKMapItem,
        from coordinates: CLLocationCoordinate2D,
        ofType type: MKDirectionsTransportType = .walking
    ) async throws -> TimeInterval {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        request.destination = destination
        request.transportType = pathType == .walking ? .walking : pathType == .automobile ? .automobile : .transit
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        let response = try await directions.calculate()
        
        guard let route = response.routes.first else {
            return TimeInterval()
        }
        
        return route.expectedTravelTime
    }
}
