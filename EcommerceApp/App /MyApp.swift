import SwiftUI

@main struct MyApp: App {
    
    @State var authViewModel: AuthViewModel = AuthViewModel()
    @State var cartViewModel: CartViewModel = CartViewModel()
    @State var orderViewModel: OrderViewModel = OrderViewModel()
    @State private var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            SplashView().environment(authViewModel).environment(cartViewModel).environment(orderViewModel).environment(languageManager).environment(\.layoutDirection, languageManager.selectedLanguage == "ar" ? .rightToLeft : .leftToRight).environment(\.locale, Locale(identifier: languageManager.selectedLanguage))
        }
    }
}
