struct Product: Codable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var stock: Int
    var image_url: String
    var category: Category
}
