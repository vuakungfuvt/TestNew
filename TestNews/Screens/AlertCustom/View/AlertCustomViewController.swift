//
//  AlertCustomViewController.swift
//  TestNews
//
//  Created by pttung5 on 02/04/2022.
//

import UIKit

class AlertCustomViewController: UIViewController, XibViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var widthContentViewConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var viewModel = AlertCustomViewModel(content: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        initData()
    }
    
    func setupViewModel(viewModel: AlertCustomViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateConstraint(constraint: self.widthContentViewConstraint, newValueConstrant: screenSize.width - 60, time: 0.5, completion: {
            
        })
    }
    
    func setupView() {
        widthContentViewConstraint.constant = 60
    }
    
    func initData() {
        lblContent.text = viewModel.content
    }

    // MARK: - Actions
    
    @IBAction func btnOKTouchUpInside(_ sender: Any) {
        self.view.layoutIfNeeded()
        self.animateConstraint(constraint: self.widthContentViewConstraint, newValueConstrant: 0, time: 0.5, completion: {
            self.dismiss(animated: false) {}
        })
    }
}
