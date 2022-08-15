//
//  DetailNewsViewModel.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import UIKit

class DetailNewsViewModel: NSObject {
    var article: Article!
    
    init(article: Article) {
        self.article = article
    }
    
    func getArticleTitle() -> String? {
        return article.title
    }
    
    func getArticleDescription() -> String? {
        return article.articleDescription
    }
    
    func getArticleUrlImage() -> String? {
        return article.urlToImage
    }
    
    func getArticleTime() -> String? {
        let dateUpdated = article.publishedAt?.toDate() ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: dateUpdated)
        let yourDate = formatter.date(from: myString)
        
        formatter.dateFormat = "MMM yyyy, HH:mm"
        
        let myStringDate = formatter.string(from: yourDate!)
        return myStringDate
    }
}
