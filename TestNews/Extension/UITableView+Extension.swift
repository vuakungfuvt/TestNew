//
//  UITableView+Extension.swift
//  TestNews
//
//  Created by pttung5 on 02/04/2022.
//

import UIKit
import ESPullToRefresh

extension UITableView {
    
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
    
    func set(delegateAndDataSource: UITableViewDataSource & UITableViewDelegate) {
        delegate = delegateAndDataSource
        dataSource = delegateAndDataSource
    }
    
    func registerNibCellFor<T: UITableViewCell>(type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerClassCellFor<T: UITableViewCell>(type: T.Type) {
        let nibName = type.name
        register(type, forCellReuseIdentifier: nibName)
    }
    
    // MARK: - Get component functions
    func reusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath? = nil) -> T? {
        let nibName = type.name
        if let indexPath = indexPath {
            return self.dequeueReusableCell(withIdentifier: nibName, for: indexPath) as? T
        }
        return self.dequeueReusableCell(withIdentifier: nibName) as? T
    }
    
    func cell<T: UITableViewCell>(type: T.Type, section: Int, row: Int) -> T? {
        guard let indexPath = validIndexPath(section: section, row: row) else { return nil }
        return self.cellForRow(at: indexPath) as? T
    }
    
    func tableHeader<T: UIView>(type: T.Type) -> T? {
        return tableHeaderView as? T
    }
    
    func tableFooter<T: UIView>(type: T.Type) -> T? {
        return tableFooterView as? T
    }
    
    // MARK: - UI functions
    func scrollToTop(animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            guard row > 0 else { return }
            self.scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
        }
    }
    
    func reloadCellAt(section: Int = 0, row: Int) {
        if let indexPath = validIndexPath(section: section, row: row) {
            reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func reloadSectionAt(index: Int) {
        reloadSections(IndexSet(integer: index), with: .fade)
    }
    
    func change(bottomInset value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    // MARK: - Supporting functions
    func validIndexPath(section: Int, row: Int) -> IndexPath? {
        guard section >= 0 && row >= 0 else { return nil }
        let rowCount = numberOfRows(inSection: section)
        guard rowCount > 0 && row < rowCount else { return nil }
        return IndexPath(row: row, section: section)
    }
    
    var hasItem: Bool {
        let itemCount =  (0..<numberOfSections)
            .map { numberOfRows(inSection: $0) }
            .reduce(0, +)
        
        return itemCount > 0
    }
}

extension UITableView {
    func pauseLoadMore() {
        self.es.stopLoadingMore()
    }
    
    func stopLoadMore() {
        self.es.noticeNoMoreData()
    }
    
    func pauseRefressh() {
        self.es.resetNoMoreData()
        self.es.stopPullToRefresh()
    }
    
    func stopRefressh() {
        self.es.removeRefreshHeader()
    }
    
    
    func addPullRefresh(completion: @escaping (() -> Void)) {
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        self.refreshIdentifier = "Loading"
        header.pullToRefreshDescription = ""
        header.releaseToRefreshDescription = ""
        header.loadingDescription = "Đang tải"
        self.es.addPullToRefresh(animator: header) {
            completion()
        }
    }
    
    func addLoadmore(completion: @escaping (() -> Void)) {
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        footer.noMoreDataDescription = ""
        self.es.addInfiniteScrolling(animator: footer) {
            completion()
        }
    }
}
