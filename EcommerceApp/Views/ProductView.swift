import SwiftUI

struct ProductView: View {
    
    @Environment(CartViewModel.self) var cartViewModel
    @Environment(AuthViewModel.self) var authViewModel
    @State private var Quantity: Int = 1
    let product: Product
    @State private var showingAlert = false
    @State private var isAddingToCart = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                ZStack{
                    Rectangle().foregroundColor(Color.gray.opacity(0.1))
                        .cornerRadius(16).frame(maxWidth: .infinity)
                        .frame(height: 300)
                    AsyncImage(url: URL(string: product.image_url)) { phase in
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
                    .frame(height: 200)
                    .padding(8)
                }
                Spacer()
                Text(product.name).font(.title2).bold().frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Image(systemName: "dollarsign").foregroundStyle(Color(red: 0.533, green: 0.227, blue: 0.188))
                    Text(String(format: "%.2f", product.price)).foregroundStyle(Color(red: 0.533, green: 0.227, blue: 0.188))
                }.font(.title3).bold().frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Image(systemName: "star.fill").foregroundStyle(Color.yellow)
                    Text("4.5 (120 reviews)")
                }.frame(maxWidth: .infinity, alignment: .leading).foregroundStyle(.gray)
                Spacer()
                Text(product.description).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal,5)
                    .padding(.vertical,5)
                Spacer()
                HStack{
                    Text("Category")
                    ZStack{
                        Rectangle().foregroundColor(Color(red: 0.03, green: 0.110, blue: 0.244).opacity(0.1))
                            .cornerRadius(16).frame(width: 130,height: 38)
                        Text(product.category.name) .foregroundStyle(Color(red: 0.03, green: 0.110, blue: 0.244))
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 35){
                    Text("Stock")
                    ZStack{
                        Rectangle().foregroundColor(.green.opacity(0.1))
                            .cornerRadius(16).frame(width: 130,height: 38)
                        Text("In Stock (\(product.stock))").foregroundStyle(Color(red: 0.2, green: 0.4, blue: 0.263))
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack{
                ZStack{
                    Rectangle().foregroundColor(Color.gray.opacity(0.1))
                        .clipShape(Capsule()).frame(width: 130,height: 60)
                    HStack{
                        Button("-"){
                            if(Quantity>1){
                                Quantity-=1
                            }
                        }
                        Spacer()
                        Text("\(Quantity)")
                        Spacer()
                        Button("+"){
                            if(Quantity < product.stock){
                                Quantity+=1
                            }
                        }
                    }.font(.title2).bold().foregroundStyle(.primary).frame(width: 100)
                }
                Button {
                    Task{
                        isAddingToCart = true
                        defer { isAddingToCart = false }
                        cartViewModel.token = authViewModel.token
                        cartViewModel.userId = authViewModel.userId
                        cartViewModel.product = product
                        cartViewModel.quantity = Quantity
                        do{
                            try await cartViewModel.addProductToCart()
                            alertMessage = "Product added to Cart successfully!"
                        }catch{
                            print(error)
                            alertMessage = "Failed to add product. Please try again."
                        }
                        showingAlert = true
                    }
                }label: {
                    if isAddingToCart {
                        ProgressView()
                            .tint(.white)
                        Text("Adding...")
                    } else {
                        Label("Add to Cart", systemImage: "cart")
                    }
                }
                .disabled(isAddingToCart).frame(maxWidth: .infinity).padding().background( Color(red: 0.608, green: 0.373, blue: 0.314)).foregroundStyle(.white).clipShape(Capsule()).font(.title2).alert(Text(LocalizedStringKey(alertMessage)), isPresented: $showingAlert){
                    Button("OK", role: .cancel) {
                    }
                }
            }.frame(maxWidth: .infinity).padding()
        }.frame(maxWidth: .infinity).padding().localizedBackButton()
    }
}


