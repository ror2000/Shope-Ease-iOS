import Foundation

class APIService{
    
    private func makeRequest(url: URL, method: String = "GET", token: String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        let language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        request.setValue(language, forHTTPHeaderField: "Accept-Language")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func login(loginRequest: LoginRequest) async throws -> LoginResponse {
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/auth/login")
        var request = makeRequest(url: url!, method: "POST")
        let jsonData = try JSONEncoder().encode(loginRequest)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
    
    func register(registerRequest: RegisterRequest) async throws -> String {
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/user")
        var request = makeRequest(url: url!, method: "POST")
        let jsonData = try JSONEncoder().encode(registerRequest)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8)!
    }
    
    func fetchProducts(token: String) async throws -> [Product]{
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/products")
        let request = makeRequest(url: url!, token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Product].self, from: data)
    }
    
    func fetchCart(token: String, userId: Int) async throws -> Cart {
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/cart/\(userId)")
        let request = makeRequest(url: url!, token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Cart.self, from: data)
    }
    
    func fetchCartItems(token: String, cartId: Int) async throws -> [CartItem]{
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/cart/\(cartId)/items")
        let request = makeRequest(url: url!, token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([CartItem].self, from: data)
    }
    
    func addProductToCart(token: String, cartId: Int, productId: Int) async throws -> String {
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/cart/\(cartId)/products/\(productId)")
        let request = makeRequest(url: url!, method: "POST", token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8)!
    }
    
    func updateCartItemQuantity(token: String, itemId: Int, quantity: Int) async throws -> CartItem{
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/cart/items/\(itemId)")
        let json: [String: Any] = ["quantity": quantity]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        var request = makeRequest(url: url!, method: "PUT", token: token)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(CartItem.self, from: data)
    }
    
    func deleteCartItem(token: String, itemId: Int) async throws -> String {
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/cart/items/\(itemId)")
        let request = makeRequest(url: url!, method: "DELETE", token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8)!
    }
    
    func createOrder(token: String, userId: Int) async throws -> String {
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/order")
        let json: [String: Any] = ["id": userId]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        var request = makeRequest(url: url!, method: "POST", token: token)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8)!
    }
    
    func fetchUserOrders(token: String, userId: Int) async throws -> [Order]{
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/order/user/\(userId)")
        let request = makeRequest(url: url!, token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Order].self, from: data)
    }
    
    func fetchOrderItems(token: String, orderId: Int) async throws -> [OrderItem]{
        let url = URL(string:  "https://ecommerce-api-kvxq.onrender.com/order/\(orderId)/items")
        let request = makeRequest(url: url!, token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            print("Status Code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([OrderItem].self, from: data)
    }
}
