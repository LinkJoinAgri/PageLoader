//
//  PageDataProvider.swift
//
//
//  Created by scchn on 2023/9/15.
//

import Foundation

public protocol PageDataProvider<Item> {
    associatedtype Item
    
    func fetchPage(_ page: Int, completionHandler: @escaping (Result<PageInfo<Item>, Error>) -> Void) -> PageFetchTaskCancellation?
}
