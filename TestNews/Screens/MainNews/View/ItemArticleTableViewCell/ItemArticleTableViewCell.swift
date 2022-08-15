//
//  ItemArticleTableViewCell.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import UIKit

class ItemArticleTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imvArticles: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLastUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(viewModel: ItemArticleCellViewModel) {
        imvArticles.loadImage(url: URL(string: viewModel.imageArticle ?? ""))
        lblTitle.text = viewModel.title
        lblDescription.text = viewModel.description
        lblLastUpdated.text = viewModel.lastUpdated
    }
}
