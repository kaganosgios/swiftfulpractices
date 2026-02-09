import Foundation
import XCTest

// MARK: - Product Model
struct Product: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - APIClient Protocol
protocol APIClientProtocol {
    func fetchProducts() async throws -> [Product]
}

// MARK: - Real APIClient Implementation
class APIClient: APIClientProtocol {
    func fetchProducts() async throws -> [Product] {
        // Simulated network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // Simulated fetched products
        return [
            Product(id: 1, name: "Product 1"),
            Product(id: 2, name: "Product 2")
        ]
    }
}

// MARK: - ModernProductListViewModel
@MainActor
class ModernProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedProducts = try await apiClient.fetchProducts()
            products = fetchedProducts
        } catch {
            products = []
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - Mock APIClients for Testing

class MockSuccessAPIClient: APIClientProtocol {
    func fetchProducts() async throws -> [Product] {
        return [
            Product(id: 1, name: "Mock Product 1"),
            Product(id: 2, name: "Mock Product 2")
        ]
    }
}

class MockFailAPIClient: APIClientProtocol {
    enum MockError: Error {
        case fetchFailed
    }

    func fetchProducts() async throws -> [Product] {
        throw MockError.fetchFailed
    }
}

// MARK: - Unit Tests

final class ModernProductListViewModelTests: XCTestCase {

    func testFetchProducts_success() async {
        let vm = ModernProductListViewModel(apiClient: MockSuccessAPIClient())
        await vm.fetchProducts()
        XCTAssertEqual(vm.products.count, 2)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func testFetchProducts_failure() async {
        let vm = ModernProductListViewModel(apiClient: MockFailAPIClient())
        await vm.fetchProducts()
        XCTAssertTrue(vm.products.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }
}
