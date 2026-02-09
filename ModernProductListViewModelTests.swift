import XCTest
import Foundation
@testable import AuthStoreMini

final class ModernProductListViewModelTests: XCTestCase {
    
    struct MockSuccessAPIClient: APIClientProtocol {
        func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
            let products = [Product(id: 1, title: "Mocked Product 1"), Product(id: 2, title: "Mocked Product 2")]
            let response = ModernProductListViewModel.ProductResponse(products: products)
            // Safe forced cast for this mock
            return response as! T
        }
    }
    
    struct MockFailAPIClient: APIClientProtocol {
        struct DummyError: Error {}
        func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
            throw DummyError()
        }
    }
    
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
