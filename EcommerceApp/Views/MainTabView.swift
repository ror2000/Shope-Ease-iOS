
import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            CartView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(1)

            OrdersView()
                .tabItem {
                    Label("Orders", systemImage: "shippingbox")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .tint(Color(red: 0.608, green: 0.373, blue: 0.314)).navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabView()
}
