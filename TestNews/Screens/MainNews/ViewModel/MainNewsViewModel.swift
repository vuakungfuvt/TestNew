//
//  MainNewsViewModel.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import UIKit

let articlesKey = "ArticlesKey"
let searchedKey = "SearchedKey"

class MainNewsViewModel: NSObject {
    
    var dataAdapter: DataAdapter!
    var cellViewModels: [ItemArticleCellViewModel] = [ItemArticleCellViewModel]()
    var reloadTableView: (() -> Void)?
    var articles = [Article]()
    var userDefaults: UserDefaults!
    
    init(adapter: DataAdapter, userDefaults: UserDefaults) {
        self.dataAdapter = adapter
        self.userDefaults = userDefaults
    }
    
    func loadLocalArticles() {
        guard let articles = self.getArticles() else {
            return
        }
        self.loadCellViewModels(articles: articles)
    }
    
    func searchArticle(name: String, success: @escaping ([Article]) -> Void, failure: @escaping (Error) -> Void) {
        dataAdapter.searchArticles(name: name) { articles in
            self.articles = articles
            self.saveToLocal(articles: articles)
            self.loadCellViewModels(articles: articles)
            success(articles)
        } failure: { error in
            failure(error)
        }

    }
    
    func loadCellViewModels(articles: [Article]) {
        self.cellViewModels.removeAll()
        var array = [ItemArticleCellViewModel]()
        articles.forEach { article in
            let dateUpdated = article.publishedAt?.toDate() ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let myString = formatter.string(from: dateUpdated)
            let yourDate = formatter.date(from: myString)
            
            formatter.dateFormat = "MMM yyyy, HH:mm"
            
            let myStringDate = formatter.string(from: yourDate!)
            let itemVM = ItemArticleCellViewModel(imageArticle: article.urlToImage, title: article.title, description: article.articleDescription, lastUpdated: "Updated \(myStringDate)")
            array.append(itemVM)
        }
        self.cellViewModels = array
        self.reloadTableView?()
    }
    
    func getArticle(indexPath: IndexPath) -> Article {
        return articles[indexPath.row]
    }
    
    func saveToLocal(articles: [Article]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(articles) {
            userDefaults.set(encoded, forKey: articlesKey)
        }
    }
    
    func getArticles() -> [Article]? {
        if let articlesData = userDefaults.object(forKey: articlesKey) as? Data {
            let decoder = JSONDecoder()
            guard let loadedArticles = try? decoder.decode([Article].self, from: articlesData) else {
                return nil
            }
            return loadedArticles
        }
        return nil
    }
    
    func saveToLocal(savedText: String) {
        userDefaults.set(savedText, forKey: searchedKey)
    }
    
    func getSearchedKey() -> String? {
        return userDefaults.string(forKey: searchedKey)
    }
}
