//
//  DetailedNewsTest.swift
//  TestNewsTests
//
//  Created by pttung5 on 15/08/2022.
//

import XCTest
@testable import TestNews

class DetailedNewsTest: XCTestCase {
    
    let article = Article(source: Source(id: "1", name: "s1"), author: "tung", title: "Sr iOS", articleDescription: "here is the description", url: "https://www.dailymail.co.uk/news/article-11111445/Sprinter-Ricardo-Dos-Santos-pulled-SEVEN-armed-police-officers-driving-London.html", urlToImage: "https://i.dailymail.co.uk/1s/2022/08/15/00/61382399-0-image-a-34_1660520062135.jpg", publishedAt: "2022-08-15T00:59:54Z", content: "An athlete who was allegedly racially profiled during a stop and search has said he was pulled over for a second time by seven armed police officers while driving home in London.\r\nSprinter Ricardo Do… [+4001 chars]")
    
    private var viewModel: DetailNewsViewModel!

    override func setUp() {
        viewModel = DetailNewsViewModel(article: article)
    }
    
    func testGetArticleTitle() {
        XCTAssertEqual(viewModel.getArticleTitle(), article.title)
    }
    
    func testGetArticleDescription() {
        XCTAssertEqual(viewModel.getArticleDescription(), article.articleDescription)
    }
    
    func testGetArticleUrlImage() {
        XCTAssertEqual(viewModel.getArticleUrlImage(), article.urlToImage)
    }
    
    func testGetArticleTime() {
        let dateUpdated = viewModel.article.publishedAt?.toDate() ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: dateUpdated)
        let yourDate = formatter.date(from: myString)
        
        formatter.dateFormat = "MMM yyyy, HH:mm"
        
        let myStringDate = formatter.string(from: yourDate!)
        XCTAssertEqual(viewModel.getArticleTime(), myStringDate)
    }

}
