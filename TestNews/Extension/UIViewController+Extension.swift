//
//  UIViewController+Extension.swift
//  TestNews
//
//  Created by pttung5 on 02/04/2022.
//

import MBProgressHUD
import UIKit
import AVKit

protocol XibViewController {
    static var name: String { get }
    static func create() -> Self
}

extension XibViewController where Self: UIViewController {
    
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create() -> Self {
        return self.init(nibName: Self.name, bundle: nil)
    }
    
    static func present(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
    
    static func push(from: UIViewController? = top(),
                     animated: Bool = true,
                     prepare: ((_ vc: Self) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        targetVC.hidesBottomBarWhenPushed = true
        prepare?(targetVC)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        parentVC.navigationController?.pushViewController(targetVC, animated: animated)
        CATransaction.commit()
    }
    
    static func showDialog(size: CGSize? = nil, ratio: CGFloat = 0.8, animated: Bool = false, prepare: ((_ vc: Self) -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
        guard let parentVC = top() else { return }
        let targetVC = create()
        prepare?(targetVC)
        var sizeFrame: CGSize
        if let size = size {
            sizeFrame = size
        } else {
            let sizeVC = targetVC.view.bounds.size
            sizeFrame = CGSize(width: sizeVC.width * ratio, height: sizeVC.height * ratio)
        }
        let transitioningDelegate = ModalTransitioningDelegate(from: parentVC, to: targetVC, sizeFrame, animated: animated)
        targetVC.modalPresentationStyle = .custom
        targetVC.transitioningDelegate = transitioningDelegate
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
}

extension UIViewController {
    
    var isModal: Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    class func top(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        return controller
    }
    
    func dismissToRoot(controller: UIViewController? = UIViewController.top(),
                       animated: Bool = true,
                       completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        guard let getController = controller else {
            completion?(nil)
            return
        }
        if let prevVC = getController.presentingViewController {
            if prevVC.isModal && prevVC.presentingViewController != nil {
                dismissToRoot(controller: prevVC, animated: animated, completion: completion)
            } else {
                getController.dismiss(animated: animated, completion: {
                    completion?(prevVC)
                })
            }
        } else {
            completion?(getController)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func removeController(asChildViewController viewController: UIViewController) {
        if viewController.isViewLoaded {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    func showDialog(size: CGSize? = nil, ratio: CGFloat = 0.8, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let parentVC = UIViewController.top() else { return }
        var sizeFrame: CGSize
        if let size = size {
            sizeFrame = size
        } else {
            let sizeVC = self.view.bounds.size
            sizeFrame = CGSize(width: sizeVC.width * ratio, height: sizeVC.height * ratio)
        }
        let transitioningDelegate = ModalTransitioningDelegate(from: parentVC, to: self, sizeFrame, animated: animated)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = transitioningDelegate
        parentVC.present(self, animated: animated, completion: completion)
    }
}

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    let size: CGSize
    let animated: Bool
    init(from presented: UIViewController, to presenting: UIViewController, _ size: CGSize, animated: Bool) {
        self.size = size
        self.animated = animated
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

extension UIViewController {
    
    var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }

    
    func pop(animated: Bool = true, checkInput: Bool = false) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true, checkInput: Bool = false) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true, checkInput: Bool = false) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func push(to viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func present(to viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: animated, completion: completion)
    }
}

extension UIViewController {
    func pushWith(subtype: CATransitionSubtype = .fromTop, animated: Bool = false, to viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = subtype
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.push(to: viewController, animated: animated)
    }
    
    func popWith(subtype: CATransitionSubtype = .fromBottom, animated: Bool = false) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = subtype
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.pop(animated: animated)
    }
}
extension UIViewController {
    func findResponder<T>(ofType type: T.Type, from target: UIViewController?) -> T? {
        guard let parent = target?.parent else { return nil }
        
        if let responder = parent as? T {
            return responder
        } else if let navResponder = parent as? UINavigationController {
            let firstChild = navResponder.children.first
            if let result = firstChild as? T {
                return result
            }
            return firstChild?.findResponder(ofType: type, from: firstChild)
        }
        
        return findResponder(ofType: type, from: parent)
    }
}

extension UIViewController {
    func addBackBarButtonItem() {
        let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back.pdf"), style: .done, target: self, action: #selector(backEvent))
        
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func backEvent() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    
    func showError(errorContent: String) {
        let viewModel = AlertCustomViewModel(content: errorContent)
        AlertCustomViewController.present(from: self, animated: false) { vc in
            vc.setupViewModel(viewModel: viewModel)
            vc.modalPresentationStyle = .overFullScreen
        } completion: {
            
        }

    }
    
    func showLoading() {
        
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.label.text = "Loading"
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension UIViewController {
    func animateConstraint(constraint: NSLayoutConstraint, newValueConstrant: CGFloat, time: TimeInterval, completion: @escaping (() -> Void)) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: time) {
            constraint.constant = newValueConstrant
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}
