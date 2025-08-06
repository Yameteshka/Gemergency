import SwiftUI

extension UIApplication {
    
    var hasDynamicIsland: Bool {
        return currentDeviceName == "iPhone 14 Pro" || currentDeviceName == "iPhone 15 Pro" || currentDeviceName == "iPhone 16 Pro"
        || currentDeviceName == "iPhone 14 Pro Max" || currentDeviceName == "iPhone 15 Pro Max" || currentDeviceName == "iPhone 16 Pro Max"
        || currentDeviceName == "iPhone 15" || currentDeviceName == "iPhone 15 Plus" || currentDeviceName == "iPhone 16" || currentDeviceName == "iPhone 16 Plus"
    }
    
    var currentDeviceName: String {
        return UIDevice.current.name
    }
    
    var isCurrentDeviceiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
