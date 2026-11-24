import SwiftUI

struct HomeView: View {
    
    @Environment(AuthViewModel.self) var authViewModel
    @State private var viewModel = HomeViewModel()
    @State private var Search: String = ""
    private let columns = [ GridItem(.flexible()), GridItem(.flexible()) ]
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Text("Shope Ease").font(.title).bold()
                    Spacer()
                    Image(systemName: "bell").resizable().frame(width: 30, height: 30).foregroundStyle(.gray)
                }.padding().task {
                    viewModel.token = authViewModel.token
                    do{
                        try await viewModel.fetchProducts()
                        print(viewModel.product)
                    } catch {
                        print(error)
                    }
                }
                
                HStack{
                    Image(systemName: "magnifyingglass").resizable().frame(width: 20, height: 20).foregroundStyle(.gray)
                    TextField("Search Product", text: $Search)
                }.padding().overlay(RoundedRectangle(cornerRadius: 50, style: .continuous).stroke(Color.gray, lineWidth: 0.5))
                
                ScrollView(.vertical, showsIndicators: false){
                    HStack{
                        Text("Categories").font(.title2).bold()
                        Spacer()
                        Text("See All").foregroundStyle(Color(red: 0.608, green: 0.373, blue: 0.314))
                    }.padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ZStack{
                                Rectangle().foregroundColor(Color(red: 0.608, green: 0.373, blue: 0.314))
                                    .cornerRadius(16).frame(width: 100,height: 100)
                                VStack{
                                    Image(systemName: "square.grid.2x2").resizable().frame(width: 30, height: 30).foregroundStyle(.white)
                                    Text("All").foregroundStyle(.white).bold()
                                }
                            }
                            ZStack{
                                Rectangle().foregroundColor(Color.gray.opacity(0.1))
                                    .cornerRadius(16).frame(width: 100,height: 100)
                                VStack{
                                    Image(systemName: "laptopcomputer").resizable().frame(width: 30, height: 30).foregroundStyle(.gray).symbolRenderingMode(.monochrome)
                                    Text("Electronics").foregroundStyle(.gray).bold()
                                }
                            }
                            ZStack{
                                Rectangle().foregroundColor(Color.gray.opacity(0.1))
                                    .cornerRadius(16).frame(width: 100,height: 100)
                                VStack{
                                    Image(systemName: "tshirt").resizable().frame(width: 30, height: 30).foregroundStyle(.gray)
                                    Text("Clothing").foregroundStyle(.gray).bold()
                                }
                            }
                        }
                    }.padding()
                    HStack{
                        Text("Featured Products").font(.title2).bold()
                        Spacer()
                        Text("See All").foregroundStyle(Color(red: 0.608, green: 0.373, blue: 0.314)).bold()
                    }.padding()
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.product, id: \.id){ product in
                            NavigationLink(destination: ProductView(product: product)) {
                                ZStack{
                                    Rectangle().foregroundColor(Color.gray.opacity(0.1))
                                        .cornerRadius(16).frame(maxWidth: .infinity, minHeight: 200)
                                    VStack(spacing: 1){
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
                                        .frame(height: 130)
                                        .padding(8)
                                        Text("\(product.name)").font(.title3).bold().frame(maxWidth: .infinity ,alignment: .leading).multilineTextAlignment(.leading)
                                        HStack{
                                            Image(systemName: "dollarsign").foregroundStyle(Color(red: 0.533, green: 0.227, blue: 0.188)).font(.callout)
                                            Text(String(format: "%.2f", product.price)).foregroundStyle(Color(red: 0.6, green: 0.306, blue: 0.302)).bold()
                                        }.frame(maxWidth: .infinity ,alignment: .leading)
                                        HStack{
                                            Image(systemName: "star.fill").resizable().frame(width: 15, height: 15).foregroundStyle(.yellow)
                                            Text("4.5（120)").foregroundStyle(.gray).bold()
                                        }.frame(maxWidth: .infinity ,alignment: .leading)
                                    }.frame(maxWidth: .infinity).padding()
                                }
                            }
                        }.foregroundStyle(.primary)
                    }.padding(.horizontal, 8)
                }
            }.frame(maxWidth: .infinity).padding()
        }
    }
}

#Preview {
    HomeView()
}
