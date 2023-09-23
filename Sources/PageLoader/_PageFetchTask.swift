//
//  _PageFetchTask.swift
//
//
//  Created by scchn on 2023/9/15.
//

import Foundation

class _PageFetchTask {
    let id = UUID()
    var cancellationHandler: (() -> Void)?
    
    func cancel() {
        cancellationHandler?()
    }
}
