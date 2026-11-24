import SwiftUI

struct CartView: View {
    
    @Environment(CartViewModel.self) var cartViewModel
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(OrderViewModel.self) var orderViewModel
    private let columns = [ GridItem(.flexible()) ]
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isCreatingOrder = false
    @State private var orderAlertMessage = ""
    @State private var orderShowingAlert = false
    @Binding var selectedTab: Int
    
    
    var body: some View {
        NavigationView {
            VStack{
                Text("My Cart").font(.title).bold().frame(maxWidth: .infinity,alignment: .leading).task {
                    cartViewModel.token = authViewModel.token
                    cartViewModel.userId = authViewModel.userId
                    orderViewModel.token = authViewModel.token
                    orderViewModel.userId = authViewModel.userId
                    do{
                        try await cartViewModel.fetchCartItems()
                        print(cartViewModel.cartItems)
                    } catch {
                        print(error)
                    }
                }
                ScrollView(.vertical){
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(cartViewModel.cartItems, id: \.id){ item in
                            NavigationLink(destination: ProductView(product: item.product)) {
                                ZStack{
                                    Rectangle().foregroundStyle(.gray.opacity(0.05)).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).frame(maxWidth: .infinity).frame(height: 180)
                                    HStack{
                                        AsyncImage(url: URL(string: item.product.image_url)) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                
                                            case .failure(_):
                                                Image(systemName: "photo")
                                                    .font(.largeTitle)
                                                    .foregroundStyle(.gray)
                                                
                                            default:
                                                ProgressView()
                                            }
                                        }
                                        .frame(height: 130)
                                        .padding(8)
                                        VStack{
                                            Text(item.product.name).frame(maxWidth: .infinity, alignment: .leading).font(.title2).multilineTextAlignment(.leading)
                                            HStack{
                                                Image(systemName: "dollarsign").foregroundStyle(Color(red: 0.533, green: 0.227, blue: 0.188))
                                                Text(String(format: "%.2f",item.product.price)).foregroundStyle(Color(red: 0.533, green: 0.227, blue: 0.188)).bold()
                                            }.font(.title3).frame(maxWidth: .infinity, alignment: .leading)
                                            ZStack{
                                                Rectangle().foregroundColor(Color.gray.opacity(0.1))
                                                    .clipShape(Capsule()).frame(width: 100,height: 60)
                                                HStack{
                                                    Button("-"){
                                                        if(item.quantity>1){
                                                            Task{
                                                                let Quantity = item.quantity - 1
                                                                do{
                                                                    try await cartViewModel.updateCartItemQuantity(itemId: item.id, quantity: Quantity)
                                                                    try await cartViewModel.fetchCart()
                                                                }catch{
                                                                    print(error)
                                                                }
                                                            }
                                                        }
                                                    }.font(.title3)
                                                    Spacer()
                                                    Text("\(item.quantity)").font(.title3)
                                                    Spacer()
                                                    Button("+"){
                                                        if(item.quantity<item.product.stock){
                                                            Task{
                                                                let Quantity = item.quantity + 1
                                                                do{
                                                                    try await cartViewModel.updateCartItemQuantity(itemId: item.id, quantity: Quantity)
                                                                    try await cartViewModel.fetchCart()
                                                                }catch{
                                                                    print(error)
                                                                }
                                                            }
                                                        }
                                                    }.font(.title3)
                                                }.frame(width: 70)
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        Spacer()
                                        Button("", systemImage: "trash"){
                                            Task{
                                                do{
                                                    try await cartViewModel.deleteCartItem(itemId: item.id)
                                                    try await cartViewModel.fetchCart()
                                                    alertMessage = cartViewModel.deleteCartItemMessage
                                                    showingAlert = true
                                                }catch{
                                                    print(error)
                                                    alertMessage = "\(error)"
                                                    showingAlert = true
                                                }
                                            }
                                        }.foregroundStyle(.red).font(.title2).alert(Text(LocalizedStringKey(alertMessage)), isPresented: $showingAlert){
                                            Button("OK", role: .cancel) {
                                            }
                                        }
                                    }.padding()
                                }
                            }.foregroundStyle(.primary)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding()
                Spacer()
                VStack{
                    HStack{
                        Text("Total").font(.title).bold()
                        Spacer()
                        Image(systemName: "dollarsign").font(.title)
                        Text(String(format: "%.2f",cartViewModel.cart?.total ?? 0)).font(.title).bold()
                    }
                    Button{
                        Task{
                            isCreatingOrder = true
                            defer { isCreatingOrder = false }
                            do{
                                if cartViewModel.cartItems.isEmpty{
                                    orderAlertMessage = "Your cart is empty."
                                }else{
                                    try await orderViewModel.createOrder()
                                    if orderViewModel.isOrderCreated {
                                        orderAlertMessage = orderViewModel.createOrderResponse
                                        try await cartViewModel.fetchCart()
                                        try await cartViewModel.fetchCartItems()
                                        try await orderViewModel.fetchOrders()
                                    }
                                }
                            }catch{
                                print(error)
                                orderAlertMessage = "Failed to create order. Please try again."
                            }
                            orderShowingAlert = true
                        }
                    }label: {
                        if isCreatingOrder {
                            ProgressView()
                                .tint(.white)
                            Text("Order Creating ...")
                        } else {
                            Label("Place Order", systemImage: "basket")
                        }
                    }
                    .disabled(isCreatingOrder || cartViewModel.cartItems.isEmpty).frame(maxWidth: .infinity).padding().background( Color(red: 0.608, green: 0.373, blue: 0.314)).foregroundStyle(.white).clipShape(Capsule()).font(.title2).alert(Text(LocalizedStringKey( orderAlertMessage)), isPresented: $orderShowingAlert){
                        Button("OK", role: .cancel) {
                            if orderViewModel.isOrderCreated {
                                selectedTab = 2
                                orderViewModel.isOrderCreated = false
                            }
                        }
                    }
                }.padding()
            }.padding()
        }
    }
}

