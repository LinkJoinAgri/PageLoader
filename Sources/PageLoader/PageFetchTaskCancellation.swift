//
//  PageFetchTaskCancellation.swift
//
//
//  Created by scchn on 2023/9/15.
//

import Foundation

public class PageFetchTaskCancellation {
    private let handler: () -> Void
    
    public init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func cancel() {
        handler()
    }
}
