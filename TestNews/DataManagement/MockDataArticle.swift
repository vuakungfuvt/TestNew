//
//  MockDataArticle.swift
//  TestNews
//
//  Created by pttung5 on 15/08/2022.
//

import Foundation

class MockDataArticleSuccess: DataAdapter {
    func searchArticles(name: String, success: @escaping ([Article]) -> Void, failure: (Error) -> Void) {
        let article1 = Article(source: Source(id: "1", name: "s1"), author: "tung", title: "Sr iOS", articleDescription: "here is the description", url: "https://www.dailymail.co.uk/news/article-11111445/Sprinter-Ricardo-Dos-Santos-pulled-SEVEN-armed-police-officers-driving-London.html", urlToImage: "https://i.dailymail.co.uk/1s/2022/08/15/00/61382399-0-image-a-34_1660520062135.jpg", publishedAt: "2022-08-15T00:59:54Z", content: "An athlete who was allegedly racially profiled during a stop and search has said he was pulled over for a second time by seven armed police officers while driving home in London.\r\nSprinter Ricardo Do… [+4001 chars]")
        let article2 = Article(source: Source(id: "2", name: "s2"), author: "monkey", title: "Elon Musk Announces Tesla Has Produced Over 3 Million Vehicles", articleDescription: "Tesla has seen a sharp rise in production after a supply shortage.", url: "https://www.ibtimes.com/elon-musk-announces-tesla-has-produced-over-3-million-vehicles-3601689", urlToImage: "https://d.ibtimes.com/en/full/3560109/tesla-was-hit-closure-its-factory-shanghai-china-several-weeks-due-lockdown-measures-imposed.jpg", publishedAt: "2022-08-15T00:47:08Z", content: "Tesla CEO Elon Musk announced on Sunday that the EV maker has made over three million cars and congratulated the Shanghai factory for its production.")
        success([article1, article2])
    }
    
}

class MockDataArticleFailure: DataAdapter {
    func searchArticles(name: String, success: @escaping ([Article]) -> Void, failure: (Error) -> Void) {
        failure(NSError(domain: "Not found", code: 404))
    }
}
