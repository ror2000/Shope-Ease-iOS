import Foundation
import SwiftUI

@Observable
class LanguageManager {
    
    var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"

    func changeLanguage(to language: String) {
        selectedLanguage = language
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
    }
}
