import Foundation

@Observable
class RegisterViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    private let apiService = APIService()
    var token: String = ""
    var isRegistered = false
    
    func register() async throws {
        let registerRequest = RegisterRequest(name: self.name, email: self.email, password: self.password)
        self.token = try await apiService.register(registerRequest: registerRequest)
        self.isRegistered = true
    }
}
