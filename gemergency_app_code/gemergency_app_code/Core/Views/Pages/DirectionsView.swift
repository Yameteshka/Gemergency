import SwiftUI
import MapKit
import Combine

public struct DirectionsView: View {
    
    @AppStorage("isShowingMapScaler") private var isShowingMapScaler: Bool = false
    @AppStorage("currentUserAnnotationTint") private var currentUserAnnotationTint: String = UserAnnotationColors.yellow.rawValue
    
    @EnvironmentObject private var llamaState: LlamaState
    @EnvironmentObject private var directionsViewModel: DirectionsViewModel
    @EnvironmentObject private var locationController: LocationController
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isDetailsSectionOpen: Bool = false
    
    private var coordinates: CLLocationCoordinate2D {
        if let userLocation = locationController.userLocation {
            return userLocation.coordinate
        }
        
        return CLLocationCoordinate2D(
            latitude: 40.689202,
            longitude: -74.044543
        )
    }
    
    public var body: some View {
        Map(position: $cameraPosition) {
            Marker("You", systemImage: "figure.wave", coordinate: coordinates)
                .tint(UserAnnotationColors.getColor(currentUserAnnotationTint))
            
            if let destination = directionsViewModel.destination {
                Marker(destination.name ?? "Destination", coordinate: destination.placemark.coordinate)
                    .tint(UserAnnotationColors.getColor(currentUserAnnotationTint))
            }
            
            if let route = directionsViewModel.route {
                MapPolyline(route.polyline)
                    .stroke(UserAnnotationColors.getColor(currentUserAnnotationTint), lineWidth: 5)
            }
        }
        .mapControlVisibility(.hidden)
        .onTapGesture {
            withAnimation(.smooth) {
                directionsViewModel.isDirectionsMenuExpanded = false
                directionsViewModel.isSettingsMenuExpanded = false
            }
        }
        .overlay {
            if !UIApplication.shared.isCurrentDeviceiPad {
                if !locationController.isAuthorized {
                    NoPermissionGrantedSubview()
                }
            }
        }
        .overlay(alignment: .top) {
            if !UIApplication.shared.isCurrentDeviceiPad {
                MapHeaderSubview(
                    title: directionsViewModel.destination?.name ?? "You",
                    isSheetOpen: $isDetailsSectionOpen,
                    isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded,
                    isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded
                )
            }
        }
        .overlay(alignment: .topLeading) {
            if UIApplication.shared.isCurrentDeviceiPad {
                MapHeaderSubview(
                    title: directionsViewModel.destination?.name ?? "You",
                    isSheetOpen: $isDetailsSectionOpen,
                    isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded,
                    isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded
                )
                .frame(width: UIScreen.main.bounds.width / 2)
                .padding(.leading, 70)
            }
        }
        .overlay(alignment: .trailing) {
            if UIApplication.shared.isCurrentDeviceiPad {
                ChatView()
                    .environmentObject(llamaState)
                    .frame(width: UIScreen.main.bounds.width / 2 - 140)
                    .clipShape(.rect(cornerRadius: 40))
                    .padding(.trailing, 25)
                    .padding(.vertical, 6)
            }
        }
        .overlay(alignment: .bottom) {
            if locationController.isAuthorized {
                if !UIApplication.shared.isCurrentDeviceiPad {
                    HStack(spacing: 10) {
                        Spacer()
                        
                        CustomGetWayButtonSubview(
                            isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded,
                            isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded
                        )
                        
                        CustomMapControlsButtonSubview(
                            isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded,
                            isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded
                        )
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                } else {
                    HStack(spacing: 10) {
                        CustomMapControlsButtonSubview(
                            isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded,
                            isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded
                        )
                        
                        CustomGetWayButtonSubview(
                            isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded,
                            isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded
                        )
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                }
            }
        }
        .overlay(alignment: .bottomLeading) {
            if UIApplication.shared.isCurrentDeviceiPad {
                if directionsViewModel.isSettingsMenuExpanded {
                    MenuStyleSubview {
                        SettingsMenuControlsSubview()
                            .frame(width: 220, height: 200)
                    }
                    .padding(.leading, 25)
                    .padding(.bottom, 100)
                    .transition(.blurReplace)
                }
                
                if directionsViewModel.isDirectionsMenuExpanded {
                    MenuStyleSubview {
                        DirectionsMenuControlsSubview()
                            .frame(width: 220, height: 160)
                    }
                    .padding(.leading, 25 + 60 + 10)
                    .padding(.bottom, 100)
                    .transition(.blurReplace)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if !UIApplication.shared.isCurrentDeviceiPad {
                if directionsViewModel.isDirectionsMenuExpanded {
                    MenuStyleSubview {
                        DirectionsMenuControlsSubview()
                            .frame(width: 220, height: 190)
                    }
                    .padding(.trailing, 25 + 60 + 10)
                    .padding(.bottom, 100)
                    .transition(.blurReplace)
                }
                
                if directionsViewModel.isSettingsMenuExpanded {
                    MenuStyleSubview {
                        SettingsMenuControlsSubview()
                            .frame(width: 220, height: 160)
                    }
                    .padding(.trailing, 25)
                    .padding(.bottom, 100)
                    .transition(.blurReplace)
                }
            }
        }
        .overlay {
            if UIApplication.shared.isCurrentDeviceiPad {
                if !locationController.isAuthorized {
                    NoPermissionGrantedSubview()
                }
                
                if directionsViewModel.wrongPathCreationError {
                    PathCreationRuntimeErrorSubview(wrongPathCreationError: $directionsViewModel.wrongPathCreationError)
                }
            }
        }
        .sheet(isPresented: $isDetailsSectionOpen) {
            MapItemInfoSubview(
                ofDestination: directionsViewModel.destination,
                with: coordinates,
                and: directionsViewModel.pathType
            )
            .presentationDetents([.height(250)])
        }
        .onReceive(llamaState.routeRequest) { type in
            Task {
                await directionsViewModel.getDirection(
                    to: type,
                    from: coordinates,
                    locale: locationController.currentLocale?.identifier ?? Locale.current.identifier
                )
            }
        }
    }
}

fileprivate extension DirectionsView {
    
    @ViewBuilder private func DirectionsMenuControlsSubview() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                ForEach(PathType.allCases, id: \.self) { pathType in
                    Image(systemName: pathType.symbol)
                        .font(.title3)
                        .foregroundStyle(directionsViewModel.pathType == pathType ? Color.blue : Color.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            HapticsController.shared.handleInteractionFeedback(of: .light)
                            
                            withAnimation(.smooth) {
                                directionsViewModel.pathType = pathType
                            }
                        }
                }
            }
            
            Rectangle()
                .fill(.black.opacity(0.1))
                .frame(height: 1)
            
            MenuControlSubview(title: "Hospitals", systemImage: "cross.case.fill") {
                Task {
                    await directionsViewModel.getDirection(to: .hospital, from: coordinates, locale: locationController.currentLocale?.identifier ?? Locale.current.identifier)
                }
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isDirectionsMenuExpanded = false
                }
            }
            
            MenuControlSubview(title: "Police stations", systemImage: "shield.lefthalf.filled") {
                Task {
                    await directionsViewModel.getDirection(to: .police, from: coordinates, locale: locationController.currentLocale?.identifier ?? Locale.current.identifier)
                }
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isDirectionsMenuExpanded = false
                }
            }
            
            MenuControlSubview(title: "Fire stations", systemImage: "flame.fill") {
                Task {
                    await directionsViewModel.getDirection(to: .fireStation, from: coordinates, locale: locationController.currentLocale?.identifier ?? Locale.current.identifier)
                }
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isDirectionsMenuExpanded = false
                }
            }
        }
        .padding(20)
    }
    
    @ViewBuilder private func SettingsMenuControlsSubview() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                ForEach(UserAnnotationColors.allCases, id: \.self) { item in
                    Circle()
                        .fill(item.color)
                        .frame(width: 18, height: 18)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            HapticsController.shared.handleInteractionFeedback(of: .light)
                            currentUserAnnotationTint = item.rawValue
                        }
                }
            }
            
            Rectangle()
                .fill(.black.opacity(0.1))
                .frame(height: 1)
            
            MenuControlSubview(title: "Find you", systemImage: "figure.walk") {
                withAnimation(.smooth) {
                    cameraPosition = .region(.init(
                        center: coordinates,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    ))
                }
                
                withAnimation(.smooth) {
                    directionsViewModel.isSettingsMenuExpanded = false
                }
            }
            
            MenuControlSubview(title: "Clear paths", systemImage: "trash.fill") {
                directionsViewModel.clear()
                
                withAnimation(.smooth) {
                    directionsViewModel.isSettingsMenuExpanded = false
                }
            }
        }
        .padding(20)
    }
}
