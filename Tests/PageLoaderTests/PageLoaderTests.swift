import XCTest

@testable import PageLoader

final class PageLoaderTests: XCTestCase {
    func test_page_checker() throws {
        let checker1 = PageChecker(pageSize: 100, numberOfTotalItems: 150)
        XCTAssertFalse(checker1.isLastPage(1))
        XCTAssertTrue(checker1.isLastPage(2))
        
        let checker2 = PageChecker(pageSize: 100, numberOfTotalItems: 200)
        XCTAssertFalse(checker2.isLastPage(1))
        XCTAssertTrue(checker2.isLastPage(2))
    }
    
    func test_page_loader() {
        let dataProvider = TestPageDataProvider()
        let pageLoader = PageLoader(dataProvider: dataProvider)
        let semaphore = DispatchSemaphore(value: 0)
        let expectation = XCTestExpectation()
        
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = TestPageDataProvider.allPageItems.count
        
        pageLoader.pageLoaded = { page, result in
            let pageInfo = try? result.get()
            
            XCTAssertEqual(pageInfo?.isLastPage, page == TestPageDataProvider.allPageItems.count)
            XCTAssertEqual(pageInfo?.items, TestPageDataProvider.allPageItems[page - 1])
            XCTAssertEqual(pageLoader.items(for: page), pageInfo?.items)
            
            semaphore.signal()
            expectation.fulfill()
        }
        
        pageLoader.loadNextPage()
        XCTAssertFalse(dataProvider.isCancelled)
        
        pageLoader.cancel()
        XCTAssertTrue(dataProvider.isCancelled)
        
        DispatchQueue.global().async {
            while pageLoader.loadNextPage() {
                XCTAssertTrue(pageLoader.isLoading)
                semaphore.wait()
                XCTAssertFalse(pageLoader.isLoading)
            }
        }
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(pageLoader.items, TestPageDataProvider.allPageItems.flatMap({ $0 }))
        XCTAssertTrue(pageLoader.isLastPage)
        
        pageLoader.reset()
        XCTAssertFalse(pageLoader.isLastPage)
        XCTAssertTrue(pageLoader.items.isEmpty)
    }
}
