import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(anyAppleOS 27.1, *) {
                iPhoneDuoBasicsView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
