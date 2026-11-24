import SwiftUI

struct LoginView: View {
    
    @Environment(AuthViewModel.self) var authViewModel
    @State private var showPassword: Bool = false
    @State private var viewModel = LoginViewModel()
    @State private var errorMassage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Spacer()
                Text("Welcome Back").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
                Text("Login to your account").frame(maxWidth: .infinity, alignment: .leading).foregroundStyle(.gray)
                Spacer()
                
                HStack{
                    Image(systemName: "envelope").resizable().frame(width: 25, height: 20).foregroundStyle(.gray)
                    TextField("Email", text: $viewModel.email).textInputAutocapitalization(.never).keyboardType(.emailAddress)
                }.padding().overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.gray, lineWidth: 2))
                HStack{
                    Image(systemName: "lock").resizable().frame(width: 20, height: 25).foregroundStyle(.gray)
                    if(showPassword == true){
                        TextField("Password", text: $viewModel.password)
                    }else{
                        SecureField("Password", text: $viewModel.password)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        if(showPassword == false){
                            Image(systemName: "eye").resizable().frame(width: 25, height: 20).foregroundStyle(.gray)
                        }else{
                            Image(systemName: "eye.slash").resizable().frame(width: 25, height: 25).foregroundStyle(.gray)
                        }
                    }
                }.padding().overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.gray, lineWidth: 2))
                Text("Forget Password?").frame(maxWidth: .infinity, alignment: .trailing).foregroundStyle(Color(red: 0.608, green: 0.373, blue: 0.314))
                
                Text(LocalizedStringKey(errorMassage)).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Sign In"){
                    if(viewModel.email == "" || viewModel.password == ""){
                        errorMassage = "Email and password are required"
                    }else{
                        errorMassage = ""
                        Task {
                            do {
                                try await viewModel.login()
                                if let value = viewModel.loginResponse {
                                    authViewModel.token = value.token
                                    authViewModel.userId = value.userId
                                    viewModel.isLoggedIn = true
                                }
                            } catch {
                                print(error)
                                errorMassage = "Login failed. Please check your email and password."
                            }
                        }
                    }
                }.frame(maxWidth: .infinity).padding().background( Color(red: 0.608, green: 0.373, blue: 0.314)).foregroundStyle(.white).clipShape(Capsule())
                
                HStack{
                    VStack { Divider().background(.gray) }.padding()
                    Text("or")
                    VStack { Divider().background(.gray) }.padding()
                }
                HStack{
                    Text("Don't have an account?")
                    NavigationLink(destination: RegisterView()) {
                        Text("Create Account").foregroundStyle(Color(red: 0.608, green: 0.373, blue: 0.314))
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity).padding().navigationDestination(isPresented: $viewModel.isLoggedIn) {
                MainTabView()
            }
        }.tint(Color(red: 0.608, green: 0.373, blue: 0.314)).navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
