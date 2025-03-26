import XCTest
import Combine
@testable import Pokedex_App

class PokemonAPIManagerTests: XCTestCase {
    
    var apiManager: PokemonAPIManager!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        apiManager = PokemonAPIManager(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchPokemonDetailsFailure() {
        let mockError = URLError(.notConnectedToInternet)
        mockNetworkService.mockPublisher = Fail(error: mockError)
            .eraseToAnyPublisher()
        
        let expectation = self.expectation(description: "Fetch Pokemon Details Failure")
        
        apiManager.fetchPokemonDetails(url: "https://pokeapi.co/api/v2/pokemon/1")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got a response")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchPokemonList() {
        let mockData = """
        {
            "results": [
                { "name": "Pikachu", "url": "https://pokeapi.co/api/v2/pokemon/1" },
                { "name": "Bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/2" }
            ]
        }
        """.data(using: .utf8)!
        
        mockNetworkService.mockPublisher = Just(mockData)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
        
        let expectation = self.expectation(description: "Fetch Pokemon List")
        
        apiManager.fetchPokemonList(limit: 2)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { pokemonList in
                XCTAssertEqual(pokemonList.count, 2)
                XCTAssertEqual(pokemonList[0].name, "Pikachu")
                XCTAssertEqual(pokemonList[1].name, "Bulbasaur")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchPokemonDetailsSuccess() {
        let mockData = """
        {
            "name": "Pikachu",
            "id": 1,
            "types": [
                {
                    "slot": 1,
                    "type": {
                        "name": "electric",
                        "url": "https://pokeapi.co/api/v2/type/13/"
                    }
                }
            ],
            "height": 4,
            "weight": 60,
            "stats": [
                {
                    "base_stat": 35,
                    "stat": {
                        "name": "hp",
                        "url": "https://pokeapi.co/api/v2/stat/1/"
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        mockNetworkService.mockPublisher = Just(mockData)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
        
        let expectation = self.expectation(description: "Fetch Pokemon Details")
        
        apiManager.fetchPokemonDetails(url: "https://pokeapi.co/api/v2/pokemon/1")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { pokemonDetail in
                XCTAssertEqual(pokemonDetail.name, "Pikachu")
                XCTAssertEqual(pokemonDetail.id, 1)
                XCTAssertEqual(pokemonDetail.types.count, 1)
                XCTAssertEqual(pokemonDetail.types[0].type.name, "electric")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
