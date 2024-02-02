import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var hasNotch: Bool {
        getKeyWindow()?.safeAreaInsets.bottom ?? 0 > 0
    }
}
