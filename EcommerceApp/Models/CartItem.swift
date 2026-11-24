struct CartItem: Codable {
    var id: Int
    var quantity: Int
    var price: Double
    var product: Product
    var cart: Cart
}
