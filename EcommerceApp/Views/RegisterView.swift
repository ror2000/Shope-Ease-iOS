import SwiftUI

struct RegisterView: View {
    @State private var errorMessage: String = ""
    @State private var showPassword: Bool = false
    @State private var confirmPassword: String = ""
    @State private var showConfirmPassword: Bool = false
    @State private var viewModel = RegisterViewModel()
    @State private var showingAlert = false
    @State private var isOk = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Spacer()
                Text("Create Account").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
                Text("Join Shope Ease today!").frame(maxWidth: .infinity, alignment: .leading).foregroundStyle(.gray)
                Spacer()
                
                HStack{
                    Image(systemName: "person").resizable().frame(width: 25, height: 25).foregroundStyle(.gray)
                    TextField("Name", text: $viewModel.name)
                }.padding().overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.gray, lineWidth: 2))
                HStack{
                    Image(systemName: "envelope").resizable().frame(width: 25, height: 20).foregroundStyle(.gray)
                    TextField("Email", text: $viewModel.email)
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
                HStack{
                    Image(systemName: "lock").resizable().frame(width: 20, height: 25).foregroundStyle(.gray)
                    if(showConfirmPassword == true){
                        TextField("Confirm Password", text: $confirmPassword)
                    }else{
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    Button {
                        showConfirmPassword.toggle()
                    } label: {
                        if(showConfirmPassword == false){
                            Image(systemName: "eye").resizable().frame(width: 25, height: 20).foregroundStyle(.gray)
                        }else{
                            Image(systemName: "eye.slash").resizable().frame(width: 25, height: 25).foregroundStyle(.gray)
                        }
                    }
                }.padding().overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.gray, lineWidth: 2))
                Text(LocalizedStringKey(errorMessage)).foregroundStyle(.red)
                Button("Create Account"){
                    errorMessage = ""
                    if(viewModel.password == confirmPassword){
                        Task {
                            do {
                                try await viewModel.register()
                                print(viewModel.token)
                                showingAlert = true
                            } catch {
                                print(error)
                                errorMessage = "\(error)"
                            }
                        }
                    }else{
                        errorMessage = "The Passwords didn't match"
                    }
                }.frame(maxWidth: .infinity).padding().background( Color(red: 0.608, green: 0.373, blue: 0.314)).foregroundStyle(.white).clipShape(Capsule()).alert(Text(LocalizedStringKey("Account created successfully!")), isPresented: $showingAlert){
                    Button("OK", role: .cancel) {
                        isOk = true
                    }
                }
                HStack{
                    Text("Already have an account?")
                    NavigationLink(destination: LoginView()) {
                        Text("Login").foregroundStyle(Color(red: 0.608, green: 0.373, blue: 0.314))
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity).padding().tint(Color(red: 0.608, green: 0.373, blue: 0.314)).navigationDestination(isPresented: $isOk) {
                LoginView()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterView()
}
