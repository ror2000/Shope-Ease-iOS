import Foundation
import SwiftUI

@Observable
class OrderViewModel {
    var token: String = ""
    var userId: Int = 0
    private let apiService = APIService()
    var createOrderResponse: String = ""
    var isOrderCreated = false
    var orders: [Order] = []
    var isLoading = false
    var orderItems: [Int: [OrderItem]] = [:]
    var orderItemCounts: [Int: Int] = [:]
    
    func createOrder() async throws {
        isOrderCreated = false
        createOrderResponse = try await apiService.createOrder(token: token, userId: userId)
        isOrderCreated = true
    }
    
    func fetchOrders() async throws {
        self.isLoading = true
        defer { isLoading = false }
        self.orders = try await apiService.fetchUserOrders(token: token, userId: userId)
    }
    
    func fetchOrderItems(orderId: Int) async throws {
        self.isLoading = true
        defer { isLoading = false }
        self.orderItems[orderId] = try await apiService.fetchOrderItems(token: token, orderId: orderId)
    }
    
    func itemCount(for orderId: Int) async throws -> Int {
        var itemQuantity = 0
        try await fetchOrderItems(orderId: orderId)
        guard let items = orderItems[orderId] else {
            return 0
        }
        itemQuantity = items.reduce(0) { total, item in
            total + item.quantity
        }
        return itemQuantity
    }
    
    func fetchOrderItemCount(orderId: Int) async throws {
        let count = try await itemCount(for: orderId)
        orderItemCounts[orderId] = count
    }
}
