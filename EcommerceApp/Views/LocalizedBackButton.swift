import SwiftUI

struct LocalizedBackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    @Environment(LanguageManager.self) private var languageManager
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: languageManager.selectedLanguage == "en"
                                  ? "chevron.left" : "chevron.right")
                            Text("Back")
                        }
                    }
                }
            }
    }
}

extension View {
    func localizedBackButton() -> some View {
        modifier(LocalizedBackButton())
    }
}
