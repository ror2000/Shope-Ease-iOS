import SwiftUI

struct OrdersView: View {
    
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(OrderViewModel.self) var orderViewModel
    @Environment(LanguageManager.self) var languageManager
    
    var body: some View {
        NavigationView {
            VStack{
                Text("My Orders").font(.title).bold().frame(maxWidth: .infinity,alignment: .leading)
                ScrollView(.vertical){
                    ForEach(orderViewModel.orders, id: \.id){ order in
                        NavigationLink(destination: OrderDetailsView(orderId: order.id)) {
                            ZStack{
                                Rectangle().foregroundStyle(.gray.opacity(0.05)).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.gray, lineWidth: 1)).frame(maxWidth: .infinity).frame(height: 130)
                                HStack{
                                    VStack{
                                        Text("#\(order.id)").frame(maxWidth: .infinity, alignment: .leading).font(.title2).bold()
                                        Text(order.formattedDate(language: languageManager.selectedLanguage == "ar" ? "ar_SA" : "en_US")).frame(maxWidth: .infinity, alignment: .leading).font(.title3).foregroundStyle(.gray)
                                        Text("\(orderViewModel.orderItemCounts[order.id] ?? 0) items").frame(maxWidth: .infinity, alignment: .leading).font(.title3).foregroundStyle(.gray)
                                    }
                                    Spacer()
                                    VStack{
                                        ZStack{
                                            Rectangle().foregroundColor(.green.opacity(0.1))
                                                .cornerRadius(16).frame(width: 130,height: 38)
                                            Text(order.status).foregroundStyle(Color(red: 0.2, green: 0.4, blue: 0.263)).font(.title2)
                                        }.frame(maxWidth: .infinity,alignment: .trailing)
                                        HStack{
                                            Image(systemName: "dollarsign")
                                            Text(String(format: "%.2f", order.total))
                                        }.font(.title3).frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    Image(systemName: languageManager.selectedLanguage == "ar"
                                          ? "chevron.left" : "chevron.right").font(.title2).padding()
                                }.padding()
                            }.task {
                                do {
                                    try await orderViewModel.fetchOrderItemCount(orderId: order.id)
                                } catch {
                                    print(error)
                                }
                            }
                        }.foregroundStyle(.primary)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity).padding().task {
                orderViewModel.token = authViewModel.token
                orderViewModel.userId = authViewModel.userId
                do{
                    try await orderViewModel.fetchOrders()
                    print(orderViewModel.orders)
                } catch {
                    print(error)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OrdersView()
}
