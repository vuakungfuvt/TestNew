//
//  DetailNewsViewController.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import UIKit

class DetailNewsViewController: UIViewController, XibViewController {

    // MARK: - Outlets
    @IBOutlet weak var imvArticles: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLastUpdated: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: - Variable
    var article: Article?
    fileprivate var viewModel: DetailNewsViewModel!
    
    // MARK: - UIViewController life Circle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        initData()
    }
    
    func setupView() {
        
    }
    
    func initData() {
        guard let article = article else {
            return
        }
        viewModel = DetailNewsViewModel(article: article)
        imvArticles.loadImage(url: URL(string: viewModel.getArticleUrlImage() ?? ""))
        lblTitle.text = viewModel.getArticleTitle()
        lblDescription.text = viewModel.getArticleDescription()
        lblLastUpdated.text = viewModel.getArticleTime()
    }

    @IBAction func btnBackTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
