import SwiftUI

struct ProfileView: View {
    
    @Environment(LanguageManager.self) var languageManager
    @State private var showingLanguageOptions = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Profile").font(.title).bold().frame(maxWidth: .infinity,alignment: .leading)
                Image(systemName: "person.crop.circle.fill").resizable().frame(width: 100,height: 100).foregroundStyle(.gray)
                Text("Ahmed").font(.title).bold()
                Text("ahmed@test.com").font(.title3).foregroundStyle(.gray)
                Button {
                    showingEditProfile = true
                    
                }label:{
                    HStack{
                        Image(systemName: "person")
                        Text("Edit Profile")
                        Spacer()
                        Image(systemName: languageManager.selectedLanguage == "en" ? "chevron.right" : "chevron.left")
                    }.foregroundStyle(.gray).padding()
                }.frame(maxWidth: .infinity).frame(height: 60).foregroundStyle(.gray.opacity(0.01)).font(.title2).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).sheet(isPresented: $showingEditProfile) {
                    VStack {
                        Text("EditProfileView")
                            .font(.title)
                            .padding(50)
                            .padding(50)
                        Button("Dismiss",action: {
                            showingEditProfile.toggle()
                        }
                        )
                    }
                }
                
                Button {
                    showingLanguageOptions = true
                    
                }label:{
                    HStack{
                        Image(systemName: "translate")
                        Text("Language")
                        Spacer()
                        Text(languageManager.selectedLanguage == "en" ? "English" : "العربية")
                        Image(systemName: languageManager.selectedLanguage == "en" ? "chevron.right" : "chevron.left")
                    }.foregroundStyle(.gray).padding()
                }.frame(maxWidth: .infinity).frame(height: 60).foregroundStyle(.gray.opacity(0.01)).font(.title2).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).tint(.blue)
                Spacer()
                Button("Logout", systemImage: "rectangle.portrait.and.arrow.right"){
                    
                }.frame(maxWidth: .infinity).padding().background( .red.opacity(0.8)).foregroundStyle(.white).clipShape(Capsule()).font(.title2)
            }.frame(maxWidth: .infinity,maxHeight: .infinity).padding() .confirmationDialog(
                "Choose your language:", isPresented: $showingLanguageOptions,
                titleVisibility: .visible
            ) {
                Button("English") {
                    languageManager.changeLanguage(to: "en")
                }
                Button("العربية") {
                    languageManager.changeLanguage(to: "ar")
                }
                Button("Cancel", role: .cancel) {
                }
            }
            
        }
    }
}

#Preview {
    ProfileView()
}
