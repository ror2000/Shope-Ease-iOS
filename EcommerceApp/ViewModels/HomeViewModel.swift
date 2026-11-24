import Foundation

@Observable
class HomeViewModel {
    var id: Int = 0
    var product: [Product] = []
    private let apiService = APIService()
    var token: String = ""
    var isProductFetched = false
    
    func fetchProducts() async throws {
        self.product = try await apiService.fetchProducts(token: token)
        self.isProductFetched = true
    }
}
