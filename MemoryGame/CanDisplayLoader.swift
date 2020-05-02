//
//  CanDisplayLoader.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

protocol CanDisplayLoader {
    func showLoader()
    func hideLoader()
}

extension CanDisplayLoader where Self: UIViewController {
    func showLoader() {
        let loadingView = getLoaderView()
        
        guard let animatedLoadingView = loadingView else {
            let loaderView = LoaderView(frame: view.bounds)
            view.addSubview(loaderView)
            loaderView.startAnimating()
            return
        }
        
        animatedLoadingView.isHidden = false
        animatedLoadingView.startAnimating()
    }
    
    func hideLoader() {
        let loadingView = getLoaderView()
        
        guard let animatedLoadingView = loadingView else {
            return
        }
        
        animatedLoadingView.stopAnimating()
        animatedLoadingView.isHidden = true
    }
    
    func getLoaderView() -> LoaderView? {
        var loaderView: LoaderView?
        
        for animatedView in view.subviews where ((animatedView as? LoaderView) != nil) {
            loaderView = animatedView as? LoaderView
            break
        }
        
        return loaderView
    }
}
