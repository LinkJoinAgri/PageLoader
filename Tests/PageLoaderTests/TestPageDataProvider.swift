//
//  TestPageDataProvider.swift
//  
//
//  Created by scchn on 2023/9/17.
//

import Foundation

@testable import PageLoader

extension TestPageDataProvider {
    static let allPageItems = [
        ["1-1"],
        ["2-1", "2-2"],
        ["3-1", "3-2", "3-3"],
    ]
}

class TestPageDataProvider: PageDataProvider {
    typealias Item = String
    
    private(set) var isCancelled = false
    
    func fetchPage(_ page: Int, completionHandler: @escaping (Result<PageInfo<String>, Error>) -> Void) -> PageFetchTaskCancellation? {
        isCancelled = false
        
        let timer = Timer(timeInterval: 0.1, repeats: false) { _ in
            let isLastPage = page == Self.allPageItems.count
            let pageInfo = PageInfo(items: Self.allPageItems[page - 1], isLastPage: isLastPage)
            
            completionHandler(.success(pageInfo))
        }
        
        RunLoop.main.add(timer, forMode: .common)
        
        return .init { [weak self] in
            timer.invalidate()
            self?.isCancelled = true
        }
    }
}
