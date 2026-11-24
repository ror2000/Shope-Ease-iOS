import Foundation

@Observable
class LoginViewModel {
    var email: String = ""
    var password: String = ""
    private let apiService = APIService()
    var loginResponse: LoginResponse?
    var isLoggedIn = false
    
    func login() async throws {
        let loginRequest = LoginRequest(email: self.email, password: self.password)
        self.loginResponse = try await apiService.login(loginRequest: loginRequest)
    }
}
