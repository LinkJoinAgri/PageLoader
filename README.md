# PageLoader

```swift
struct OrderPageDataProvider: PageDataProvider {
    typealias Item = Order
    
    let status: OrderStatus
    let pageSize: Int
    
    func fetchPage(_ page: Int, completionHandler: @escaping (Result<PageInfo<Order>, Error>) -> Void) -> PageFetchTaskCancellation? {
        let disposable = OrderAPI.orders(status: status, page: page, pageSize: pageSize)
            .subscribe(onSuccess: { order in
                let checker = PageChecker(pageSize: pageSize, numberOfTotalItems: order.numberOfTotalItems)
                let isLastPage = checker.isLastPage(page)
                let result = PageInfo(items: order.items, isLastPage: isLastPage)
                
                completionHandler(.success(result))
            }, onFailure: { error in
                completionHandler(.failure(error))
            })
        
        return .init(handler: disposable.dispose)
    }
}

let dataProvider = OrderPageDataProvider(status: .shipped, pageSize: 20)
let pageLoader = PageLoader(dataProvider: dataProvider)

pageLoader.pageLoaded = { page, result in
    do {
        let pageInfo = try result.get()
        
        // pageInfo.isLastPage
        // pageInfo.items
    } catch {
        // ...
    }
}

pageLoader.loadNextPage()
pageLoader.cancel()
pageLoader.reset()
```
