//
//  MainNewsViewController.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import UIKit
import IQKeyboardManagerSwift

class MainNewsViewController: UIViewController, XibViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    
    // MARK: - Variable
    private var viewModel: MainNewsViewModel!
    fileprivate var searchedString: String = ""
    
    // MARK: - UIViewController life Circle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = MainNewsViewModel(adapter: GetArticlesAPI(), userDefaults: UserDefaults.standard)
        setupView()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13, *)
            {
                let statusBar = UIView(frame: (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame)!)
                statusBar.backgroundColor = UIColor(rgb: 0x25A498)
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
            }
    }
    
    func setupView() {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        tableView.registerNibCellFor(type: ItemArticleTableViewCell.self)
        tableView.set(delegateAndDataSource: self)
        self.navigationController?.isNavigationBarHidden = true
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x25A498)
        
        tfSearch.addTarget(self, action: #selector(didChangeSearchTextField(textField:)), for: .editingChanged)
        tableView.addPullRefresh { [weak self] in
            guard let self = self else {
                return
            }
            
            self.searchArticle()
        }
    }
    
    func initData() {
        viewModel.loadLocalArticles()
        searchedString = viewModel.getSearchedKey() ?? "tesla"
        tfSearch.text = searchedString
        searchArticle()
    }

    @IBAction func btnCancelTouchUpInside(_ sender: Any) {
        tfSearch.text = ""
        tfSearch.resignFirstResponder()
    }
    
    @objc func didChangeSearchTextField(textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        searchedString = text
        viewModel.saveToLocal(savedText: text)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchArticle), object: nil)
        perform(#selector(searchArticle), with: nil, afterDelay: 1)
    }
    
    @objc func searchArticle() {
        self.showLoading()
        viewModel.searchArticle(name: searchedString) { [weak self] _ in
            self?.hideLoading()
            DispatchQueue.main.async {
                self?.tableView.pauseRefressh()
            }
        } failure: { [weak self] error in
            self?.hideLoading()
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource

extension MainNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.reusableCell(type: ItemArticleTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        let itemViewModel = viewModel.cellViewModels[indexPath.row]
        itemCell.setData(viewModel: itemViewModel)
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetailNewsViewController.push(from: self, animated: true) { vc in
            vc.article = self.viewModel.getArticle(indexPath: indexPath)
            
        } completion: {
            
        }

    }
}
