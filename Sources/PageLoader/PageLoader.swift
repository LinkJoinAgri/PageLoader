//
//  PageLoader.swift
//
//
//  Created by scchn on 2023/9/15.
//

import Foundation

public class PageLoader<Item> {
    private let dataProvider: any PageDataProvider<Item>
    private var currentFetchTask: _PageFetchTask?
    private var endItemIndicesForPages: [Int] = []
    
    public private(set) var isLastPage = false
    public private(set) var items: [Item] = []
    public var isLoading: Bool {
        currentFetchTask != nil
    }
    public var currentPage: Int {
        endItemIndicesForPages.count
    }
    public var pageLoaded: ((Int, Result<PageInfo<Item>, Error>) -> Void)?
    
    deinit {
        cancel()
    }
    
    public init(dataProvider: any PageDataProvider<Item>) {
        self.dataProvider = dataProvider
    }
    
    public func items(for page: Int) -> [Item] {
        assert(page >= 1, "`page` must not be less than 1.")
        
        let pageIndex = page - 1
        let startIndex = page == 1 ? 0 : endItemIndicesForPages[pageIndex - 1]
        let endIndex = endItemIndicesForPages[pageIndex]
        
        return Array(items[startIndex..<endIndex])
    }
    
    @discardableResult
    public func loadNextPage() -> Bool {
        guard !isLastPage else {
            return false
        }
        
        cancel()
        
        let task = _PageFetchTask()
        let taskID = task.id
        
        currentFetchTask = task
        
        let completion: (Result<PageInfo<Item>, Error>) -> Void = { [weak self] result in
            guard let self, taskID == currentFetchTask?.id else {
                return
            }
            
            if case let .success(pageInfo) = result {
                isLastPage = pageInfo.isLastPage
                items.append(contentsOf: pageInfo.items)
                endItemIndicesForPages.append(items.count)
            }
            
            currentFetchTask = nil
            
            pageLoaded?(currentPage, result)
        }
        let cancellation = dataProvider.fetchPage(currentPage + 1) { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        
        task.cancellationHandler = { [weak self] in
            guard let self, taskID == currentFetchTask?.id else {
                return
            }
            
            cancellation?.cancel()
            currentFetchTask = nil
        }
        
        return true
    }
    
    public func cancel() {
        currentFetchTask?.cancel()
    }
    
    public func reset() {
        cancel()
        isLastPage = false
        items.removeAll()
        endItemIndicesForPages.removeAll()
    }
}
