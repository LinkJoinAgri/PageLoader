//
//  PageInfo.swift
//
//
//  Created by scchn on 2023/9/15.
//

import Foundation

public struct PageInfo<Item> {
    public var items: [Item]
    public var isLastPage: Bool
    
    public init(items: [Item], isLastPage: Bool) {
        self.items = items
        self.isLastPage = isLastPage
    }
}
