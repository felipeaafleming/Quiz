//
//  LoadingUtils.swift
//  Quiz
//
//  Created by Felipe Fleming on 14/08/19.
//  Copyright © 2019 Fleming. All rights reserved.
//

import UIKit

struct LoadingUtils {
    static var container: UIView = UIView()
    static var loadingView: UIView = UIView()
    static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    static func displayLoadingView(forParentView view: UIView) {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = Colors.gray.withAlphaComponent(0.9)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = Colors.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    static func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
