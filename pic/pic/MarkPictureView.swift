//
//  MarkPicture.swift
//  pic
//
//  Created by huangyuan on 4/24/15.
//  Copyright (c) 2015 huangyuan. All rights reserved.
//

import Foundation
import UIKit
class MarkPictureView: UIView
{
    let imageView = UIImageView()
    let scaleBTN = UIButton()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        imageView.frame = bounds
        addSubview(imageView)
    }
}
