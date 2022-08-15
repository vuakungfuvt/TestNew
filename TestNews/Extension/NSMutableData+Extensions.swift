//
//  NSMutableData+Extensions.swift
//  TestNews
//
//  Created by pttung5 on 02/04/2022.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
