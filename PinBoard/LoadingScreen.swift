//
//  LoadingScreen.swift
//  Testing stuff
//
//  Created by Alexis Duong (student LM) on 4/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class LoadingScreen: UIView {

    static let instance = LoadingScreen()
    
    static let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    
    var viewColor : UIColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    var setAlpha: CGFloat = 0.7
    var gifName: String = "pin-animation-final"
    
    lazy var transparentView:UIView = {
        let transparentView = UIView(frame: UIScreen.main.bounds)
        transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        
        transparentView.isUserInteractionEnabled = false
        
        return transparentView
    }()
    
    lazy var gifImage: UIImageView = {
        let gifImage = UIImageView(frame:
        CGRect(x: 0, y: 0, width: 240, height: 214))
        gifImage.loadGif(name: gifName)
        gifImage.contentMode = .scaleAspectFit
        gifImage.center = transparentView.center
        gifImage.isUserInteractionEnabled = false
        return gifImage
    }()

    
    func showLoader() {
        self.addSubview(transparentView)
        self.transparentView.addSubview(gifImage)
        self.transparentView.bringSubviewToFront(self.gifImage)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(transparentView)
    }
    
    func hideLoader(){
        self.transparentView.removeFromSuperview()
    }
}
