import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                if self.isActive {
                    LoginView()
                } else {
                    Image("back2")
                    
                    VStack{
                        Image("shopping-bag").resizable().frame(width: 130, height: 130)
                        Text("Shope Ease")
                            .padding().bold().font(.title).foregroundColor(Color(red: 0.608, green: 0.373, blue: 0.314))
                    }
                }
            }.ignoresSafeArea().onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
