//
//  ImageGalleryAppTests.swift
//  ImageGalleryAppTests
//
//  Created by Mukul on 27/09/24.
//

import XCTest
import Combine
@testable import ImageGalleryApp

final class ImageGalleryAppTests: XCTestCase {

    var viewModel: ImageViewModel!
    var cancellables: Set<AnyCancellable> = []
       
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    override func setUp() {
        super.setUp()
        viewModel = ImageViewModel()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        cancellables.removeAll()
        viewModel = nil
        super.tearDown()
    }

    // Test fetchImages functionality
    func testFetchImagesSuccessfully() {
        // Given
        let expectation = self.expectation(description: "Fetch images from the API")
        let mockImageData: Data = """
        [
            {
                "albumId": 1,
                "id": 1,
                "title": "accusamus beatae ad facilis cum similique qui sunt",
                "url": "https://via.placeholder.com/600/92c952",
                "thumbnailUrl": "https://via.placeholder.com/150/92c952"
              },
              {
                "albumId": 1,
                "id": 2,
                "title": "reprehenderit est deserunt velit ipsam",
                "url": "https://via.placeholder.com/600/771796",
                "thumbnailUrl": "https://via.placeholder.com/150/771796"
              }
        ]
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockImageData)
        }

        // When
        viewModel.fetchImages()

        // Then
        viewModel.$images
            .sink { images in
                if !images.isEmpty {
                    XCTAssertEqual(images.count, 2)
                    XCTAssertEqual(images.first?.title, "accusamus beatae ad facilis cum similique qui sunt")
                    XCTAssertEqual(images.first?.url, "https://via.placeholder.com/600/92c952")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // Test cache behavior
    func testImageCache() {
        // Given
        let url = "https://via.placeholder.com/600/92c952"
        let mockImage = UIImage(systemName: "star")!
        viewModel.cache.setObject(mockImage, forKey: url as NSString)
        
        // When
        let expectation = self.expectation(description: "Fetch image from cache")
        viewModel.loadImage(from: url) { cachedImage in
            // Then
            XCTAssertNotNil(cachedImage)
            XCTAssertEqual(cachedImage, mockImage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }    

}
