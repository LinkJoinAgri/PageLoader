//
//  PageChecker.swift
//
//
//  Created by scchn on 2023/9/16.
//

import Foundation

public struct PageChecker {
    private let pageSize: Int
    private let numberOfTotalItems: Int
    
    public init(pageSize: Int, numberOfTotalItems: Int) {
        self.pageSize = pageSize
        self.numberOfTotalItems = numberOfTotalItems
    }
    
    public func isLastPage(_ page: Int) -> Bool {
        page * pageSize >= numberOfTotalItems
    }
}
