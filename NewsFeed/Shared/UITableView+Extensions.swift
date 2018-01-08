//
//  UITableView+Extensions.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    func empty(message: String) {
        let messageLabel = UILabel(frame:
            CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.backgroundView?.isHidden = true
    }
    
    func showEmpty() {
        self.backgroundView?.isHidden = false
    }
    
    func hideEmpty() {
        self.backgroundView?.isHidden = true
    }
}

extension Reactive where Base: UITableView {
    
    var nearBottom: Signal<()> {
        func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 20.0) -> Bool {
            return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
        }
        
        return self.contentOffset.asDriver()
            .flatMap { _ in
                return isNearBottomEdge(tableView: self.base, edgeOffset: 20.0)
                    ? Signal.just(())
                    : Signal.empty()
        }
    }
}
