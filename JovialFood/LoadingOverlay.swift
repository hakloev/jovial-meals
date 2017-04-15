//
//  LoadingOverlay.swift
//  JovialFood
//
//  Created by Håkon Ødegård Løvdal on 14/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay {
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    static let sharedInstance = LoadingOverlay()
    
    public func showOverlay(view: UIView) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.addSubview(overlayView)
    }
    
    public func hideOverlay() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
