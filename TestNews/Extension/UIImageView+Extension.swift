//
//  UIImageView+Extension.swift
//  TestNews
//
//  Created by pttung5 on 02/04/2022.
//

import UIKit
import Kingfisher
import Alamofire

extension UIImageView {
    
    func loadImage(url: URL?,
                   resize: CGSize? = nil,
                   model: Int = 2,
                   headers: HTTPHeaders? = nil,
                   placeholder: UIImage? = nil,
                   timeout: TimeInterval? = nil,
                   showIndicator: Bool = false,
                   forceRefresh: Bool = false,
                   progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64, _ percentage: Double) -> Void)? = nil,
                   completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        if showIndicator {
            kf.indicator?.startAnimatingView()
        }
        var options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        if forceRefresh {
            options.append(.forceRefresh)
        }
        if let size = resize {
            let p = ResizingImageProcessor(referenceSize: size,
                                           mode: model == 2 ? .aspectFill : model == 1 ? .aspectFit : .none)
            options.append(.processor(p))
        }
        kf.setImage(with: url, placeholder: placeholder, options: options, progressBlock: { receivedSize, totalSize in
            guard let _ = progressBlock else { return }
            let percentage = Double(totalSize) / Double(receivedSize)
            progressBlock?(receivedSize, totalSize, percentage)
        }, completionHandler: { [weak self] result in
            if showIndicator {
                self?.kf.indicator?.stopAnimatingView()
            }
            switch result {
            case .success(let value):
                completion?(value.image, nil, value.source.url)
            case .failure(let error):
                completion?(nil, error, nil)
            }
        })
    }
    
    func cancelLoadingImage() {
        self.kf.cancelDownloadTask()
    }
    func renderOriginal() {
        image = image?.template
    }
    
    func renderTemplate() {
        image = image?.template
    }
    
    func roundRectWith(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        shape.backgroundColor = UIColor.red.cgColor
        self.layer.mask = shape
    }
}
