struct OrderItem: Codable {
    var id: Int
    var productId: Int
    var productName: String
    var image_url: String
    var quantity: Int
    var price: Double
}
