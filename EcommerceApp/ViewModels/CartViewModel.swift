import Foundation

@Observable
class CartViewModel {
    var cart: Cart?
    var quantity: Int = 0
    var product: Product?
    var cartItems: [CartItem] = []
    var cartItem: CartItem?
    private let apiService = APIService()
    var token: String = ""
    var addProductToCartResponse: String = ""
    var userId: Int = 0
    var isProductStored = false
    var isCartFetched = false
    var isCartItemFetched = false
    var isCartChanged = false
    var isCartItemDeleted = false
    var deleteCartItemMessage: String = ""
    
    func fetchCart() async throws {
        self.cart = try await apiService.fetchCart(token: token, userId: userId)
        self.isCartFetched = true
    }
    
    func fetchCartItems() async throws {
        if (cart == nil){
            try await fetchCart()
        }
        if let value = cart {
            self.cartItems = try await apiService.fetchCartItems(token: token, cartId: value.id)
            self.isCartItemFetched = true
        }
    }
    
    func addProductToCart() async throws {
        isProductStored = false
        guard quantity >= 1 else {
            throw MyError.runtimeError("Error: Quantity < 1")
        }
        if (cart == nil){
            try await fetchCart()
        }
        guard let cartValue = cart, let productValue = product else {
            throw MyError.runtimeError("Error: There is no Cart or Product")
        }
        self.addProductToCartResponse = try await apiService.addProductToCart(token: token, cartId: cartValue.id, productId: productValue.id)
        try await fetchCartItems()
        guard let index = cartItems.firstIndex(where: { $0.product.id == productValue.id }
        ) else {
            throw MyError.runtimeError("Error: There is no Cart Item == Product")
        }
        let item = cartItems[index]
        let updatedItem = try await apiService.updateCartItemQuantity(token: token, itemId: item.id, quantity: quantity)
        cartItems[index] = updatedItem
        cartItem = updatedItem
        try await fetchCart()
        isProductStored = true
    }
    
    func updateCartItemQuantity(itemId: Int, quantity: Int) async throws {
        isCartChanged = false
        guard let index = cartItems.firstIndex(where: {$0.id == itemId}) else {
            throw MyError.runtimeError("Error: There is no Cart Item with id = \(itemId)")
        }
        let updatedItem = try await apiService.updateCartItemQuantity(token: token, itemId: itemId, quantity: quantity)
        cartItems[index] = updatedItem
        cartItem = updatedItem
        isCartChanged = true
    }
    
    func deleteCartItem(itemId: Int) async throws {
        isCartItemDeleted = false
        guard let index = cartItems.firstIndex(where: {$0.id == itemId}) else {
            throw MyError.runtimeError("Error: There is no Cart Item with id = \(itemId)")
        }
        self.deleteCartItemMessage = try await apiService.deleteCartItem(token: token, itemId: itemId)
        cartItems.remove(at: index)
        isCartItemDeleted = true
    }
}


