//
//  DataAdapter.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import Foundation

protocol DataAdapter {
    func searchArticles(name: String, success: @escaping ([Article]) -> Void, failure: (Error) -> Void) 
}
