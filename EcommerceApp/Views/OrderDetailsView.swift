import SwiftUI

struct OrderDetailsView: View {
    
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(OrderViewModel.self) var orderViewModel
    let orderId: Int
    @Environment(\.dismiss) var dismiss
    @Environment(LanguageManager.self) var languageManager
    
    var body: some View {
        VStack{
            if let order = orderViewModel.orders.first(where: {$0.id == orderId} ) {
                Text("Order #\(order.id)").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
                ZStack{
                    Rectangle().foregroundStyle(.gray.opacity(0.05)).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).frame(maxWidth: .infinity).frame(height: 100)
                    HStack(){
                        VStack(alignment: .leading, spacing: 15){
                            Text("Order Date")
                            Text(order.formattedDate(language: languageManager.selectedLanguage == "ar" ? "ar_SA" : "en_US"))
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 15){
                            Text("Status")
                            ZStack{
                                Rectangle().foregroundColor(.green.opacity(0.1))
                                    .cornerRadius(16).frame(width: 100,height: 30)
                                Text("\(order.status)").foregroundStyle(Color(red: 0.2, green: 0.4, blue: 0.263))
                            }
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 15){
                            Text("Total")
                            HStack{
                                Image(systemName: "dollarsign")
                                Text(String(format: "%.2f", order.total))
                            }
                        }
                    }.padding()
                    
                }
                Text("Items").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.vertical){
                    ForEach(orderViewModel.orderItems[orderId] ?? [], id: \.id){ orderItem in
                        ZStack{
                            Rectangle().foregroundStyle(.gray.opacity(0.05)).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).frame(maxWidth: .infinity).frame(height: 130)
                            HStack{
                                AsyncImage(url: URL(string: orderItem.image_url)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 80, maxHeight: 80)
                                        
                                    case .failure(_):
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundStyle(.gray)
                                        
                                    default:
                                        ProgressView()
                                    }
                                }
                                .frame(height: 80)
                                .padding(3)
                                VStack{
                                    Text("\(orderItem.productName)").frame(maxWidth: .infinity, alignment: .leading).font(.title2)
                                    HStack{
                                        Image(systemName: "dollarsign")
                                        Text(String(format: "%.2f", orderItem.price))
                                        Image(systemName: "multiply")
                                        Text("\(orderItem.quantity)")
                                    }.foregroundStyle(.gray)
                                }.frame(alignment: .leading)
                                HStack{
                                    Image(systemName: "dollarsign")
                                    Text(String(format: "%.2f",orderItem.price * Double(orderItem.quantity)))
                                }.frame(alignment: .trailing)
                            }.padding()
                        }
                    }
                }
                Spacer()
                ZStack{
                    Rectangle().foregroundStyle(.gray.opacity(0.05)).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).frame(maxWidth: .infinity).frame(height: 70)
                    HStack{
                        Text("Total").font(.title2).bold()
                        Spacer()
                        HStack{
                            Image(systemName: "dollarsign")
                            Text(String(format: "%.2f", order.total))
                        }.font(.title2).bold()
                    }.padding()
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding().task {
            orderViewModel.token = authViewModel.token
            orderViewModel.userId = authViewModel.userId
            do{
                try await orderViewModel.fetchOrderItems(orderId: orderId)
                print(orderViewModel.orderItems)
            } catch {
                print(error)
            }
        }.localizedBackButton()
    }
}

#Preview {
    OrderDetailsView(orderId: 2)
}


