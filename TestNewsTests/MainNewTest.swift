//
//  MainNewTest.swift
//  TestNewsTests
//
//  Created by pttung5 on 15/08/2022.
//

import XCTest
@testable import TestNews

class MainNewTest: XCTestCase {
    
    var viewModel: MainNewsViewModel!
    
    override func setUp() {
        viewModel = MainNewsViewModel(adapter: MockDataArticleSuccess(), userDefaults: UserDefaults(suiteName: "Test Main")!)
    }
    
    func testSearchArticle() {
        viewModel.dataAdapter = MockDataArticleSuccess()
        let expectationSuccess = expectation(description: "Test Search API Success")
        viewModel.searchArticle(name: "name") { articles in
            XCTAssertTrue(articles.count > 0)
            XCTAssertEqual(articles[0].source.id, "1")
            XCTAssertEqual(articles[1].source.id, "2")
            expectationSuccess.fulfill()
        } failure: { error in
            
        }
        wait(for: [expectationSuccess], timeout: 1)

        
        viewModel.dataAdapter = MockDataArticleFailure()
        let expectationFailure = expectation(description: "Test Search API Failure")
        viewModel.searchArticle(name: "123") { _ in
            
        } failure: { error in
            XCTAssertNotNil(error)
            expectationFailure.fulfill()
        }
        
        wait(for: [expectationFailure], timeout: 1)

    }
    
    func testLoadCellViewModels() {
        let article1 = Article(source: Source(id: "1", name: "s1"), author: "tung", title: "Sr iOS", articleDescription: "here is the description", url: "https://www.dailymail.co.uk/news/article-11111445/Sprinter-Ricardo-Dos-Santos-pulled-SEVEN-armed-police-officers-driving-London.html", urlToImage: "https://i.dailymail.co.uk/1s/2022/08/15/00/61382399-0-image-a-34_1660520062135.jpg", publishedAt: "2022-08-15T00:59:54Z", content: "An athlete who was allegedly racially profiled during a stop and search has said he was pulled over for a second time by seven armed police officers while driving home in London.\r\nSprinter Ricardo Do… [+4001 chars]")
        let article2 = Article(source: Source(id: "2", name: "s2"), author: "monkey", title: "Elon Musk Announces Tesla Has Produced Over 3 Million Vehicles", articleDescription: "Tesla has seen a sharp rise in production after a supply shortage.", url: "https://www.ibtimes.com/elon-musk-announces-tesla-has-produced-over-3-million-vehicles-3601689", urlToImage: "https://d.ibtimes.com/en/full/3560109/tesla-was-hit-closure-its-factory-shanghai-china-several-weeks-due-lockdown-measures-imposed.jpg", publishedAt: "2022-08-15T00:47:08Z", content: "Tesla CEO Elon Musk announced on Sunday that the EV maker has made over three million cars and congratulated the Shanghai factory for its production.")
        let articles = [article1, article2]
        viewModel.loadCellViewModels(articles: articles)
        for index in 0..<articles.count {
            let article = articles[index]
            let dateUpdated = article.publishedAt?.toDate() ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let myString = formatter.string(from: dateUpdated)
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "MMM yyyy, HH:mm"
            
            let myStringDate = formatter.string(from: yourDate!)
            let cellViewModel = viewModel.cellViewModels[index]
            XCTAssertEqual(cellViewModel.imageArticle, article.urlToImage)
            XCTAssertEqual(cellViewModel.title, article.title)
            XCTAssertEqual(cellViewModel.description, article.articleDescription)
            XCTAssertEqual(cellViewModel.lastUpdated, "Updated \(myStringDate)")
        }
    }
    
    func testSaveLocalArticles() {
        let article1 = Article(source: Source(id: "1", name: "s1"), author: "tung", title: "Sr iOS", articleDescription: "here is the description", url: "https://www.dailymail.co.uk/news/article-11111445/Sprinter-Ricardo-Dos-Santos-pulled-SEVEN-armed-police-officers-driving-London.html", urlToImage: "https://i.dailymail.co.uk/1s/2022/08/15/00/61382399-0-image-a-34_1660520062135.jpg", publishedAt: "2022-08-15T00:59:54Z", content: "An athlete who was allegedly racially profiled during a stop and search has said he was pulled over for a second time by seven armed police officers while driving home in London.\r\nSprinter Ricardo Do… [+4001 chars]")
        let article2 = Article(source: Source(id: "2", name: "s2"), author: "monkey", title: "Elon Musk Announces Tesla Has Produced Over 3 Million Vehicles", articleDescription: "Tesla has seen a sharp rise in production after a supply shortage.", url: "https://www.ibtimes.com/elon-musk-announces-tesla-has-produced-over-3-million-vehicles-3601689", urlToImage: "https://d.ibtimes.com/en/full/3560109/tesla-was-hit-closure-its-factory-shanghai-china-several-weeks-due-lockdown-measures-imposed.jpg", publishedAt: "2022-08-15T00:47:08Z", content: "Tesla CEO Elon Musk announced on Sunday that the EV maker has made over three million cars and congratulated the Shanghai factory for its production.")
        let articles = [article1, article2]
        viewModel.saveToLocal(articles: articles)
        XCTAssertEqual(viewModel.getArticles()?.count, 2)
    }

    func testSaveLocalSearchedText() {
        viewModel.saveToLocal(savedText: "search text")
        XCTAssertEqual(viewModel.getSearchedKey(), "search text")
    }
}
