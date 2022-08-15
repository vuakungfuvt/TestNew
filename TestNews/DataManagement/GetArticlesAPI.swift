//
//  GetArticlesAPI.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import Foundation

class GetArticlesAPI: DataAdapter {
    
    init() {
        
    }
    
    func searchArticles(name: String, success: @escaping ([Article]) -> Void, failure: (Error) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=\(name)&from=\(Date().toString(withFormat: "yyyy-MM-dd"))&sortBy=publishedAt&apiKey=77e71618cbc945c5adb2fc6e2d727e71"
        let resourceURL = URL(string: urlString)!
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            
            guard error == nil else {
                print (error!.localizedDescription)
                print ("stuck in data task")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try decoder.decode(ArticleEntity.self, from: data!)
                success(jsonData.articles)
            }
            catch {
                print ("an error in catch")
                print (error)
            }
            
            
        
        }
        dataTask.resume()
    }
}
