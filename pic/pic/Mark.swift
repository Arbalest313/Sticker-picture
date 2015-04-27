//
//  MarkPicture.swift
//  pic
//
//  Created by huangyuan on 4/24/15.
//  Copyright (c) 2015 huangyuan. All rights reserved.
//

import Foundation
import UIKit
class Mark
{
    var imageView = UIImageView()
    var scaleButton = UIButton() // button to scale the picture
    var dashLine = UIImageView()
    
    let baselength_BTN = CGFloat(20)
    let baselength = CGFloat(100)
    let basesize = CGSize(width: 100, height: 100) // base size of imageView
    var base_dist = CGFloat() //distence from center to button
    
    required init (){
        var x :CGFloat = 0
        
        var y :CGFloat = 0
        
        imageView.frame = CGRectMake(x,y, baselength, baselength)
        imageView.userInteractionEnabled = true
        
        scaleButton.frame = CGRect(x: imageView.frame.size.width+imageView.frame.origin.x,y: imageView.frame.origin.y-self.baselength_BTN,width: self.baselength_BTN,height: self.baselength_BTN)
        scaleButton.setTitle("X", forState: UIControlState.Normal)
        scaleButton.hidden = false
        scaleButton.userInteractionEnabled = true
    }

    
    
    init( img : UIImage, x:CGFloat,y:CGFloat)
    {
     imageView.frame = CGRectMake(x,y, baselength, baselength)
     imageView.userInteractionEnabled = true
     resizeFrame(img)
     imageView.image = img
        
     scaleButton.frame = CGRect(x: imageView.frame.size.width+imageView.frame.origin.x,y: imageView.frame.origin.y-self.baselength_BTN,width: self.baselength_BTN,height: self.baselength_BTN)
    scaleButton.setTitle("X", forState: UIControlState.Normal)
    scaleButton.hidden = false
    scaleButton.userInteractionEnabled = true
        
    //self.drawDashLine()
    dashLine.frame = CGRectMake(0, 0, imageView.frame.width, imageView.frame.height)
    imageView.addSubview(self.dashLine)
    
    }
        
    func resizeFrame(img : UIImage)
    {
        var ratio_img = img.size.height / img.size.width
        if(ratio_img >= 0){
           
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y,width: baselength,height: baselength*ratio_img)
        }
        else{
            ratio_img = img.size.width / img.size.height
            
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y,width: baselength*ratio_img,height: baselength)
        }

    }
    func drawDashLine(){

        dashLine.frame =  CGRectMake(0, 0, imageView.frame.width, imageView.frame.height)
 

        
        UIGraphicsBeginImageContextWithOptions(dashLine.frame.size, false, 0)
        dashLine.image?.drawInRect(CGRectMake(0, 0, dashLine.frame.size.width, dashLine.frame.size.height))//开始画线
        
        
        var lengths :[CGFloat] = [2, 5]
        var line :CGContextRef = UIGraphicsGetCurrentContext()
        CGContextBeginPath(line)
        CGContextSetLineWidth(line, 2.0)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)//设置线条终点形状
        

        CGContextSetStrokeColorWithColor(line, UIColor.grayColor().CGColor)
        CGContextSetLineDash(line, 0, lengths, 2)
        CGContextMoveToPoint(line, 0, 0.0)    //开始画线
        CGContextAddLineToPoint(line, dashLine.frame.size.width, 0.0)
        CGContextMoveToPoint(line, dashLine.frame.width, 0.0)    //开始画线
        CGContextAddLineToPoint(line, dashLine.frame.size.width, dashLine.frame.height)
        CGContextMoveToPoint(line, 0, dashLine.frame.height)    //开始画线
        CGContextAddLineToPoint(line, dashLine.frame.size.width, dashLine.frame.height)
        CGContextMoveToPoint(line, 0, 0.0)    //开始画线
        CGContextAddLineToPoint(line, 0, dashLine.frame.height)
        CGContextStrokePath(line)
        println("DASHING")
        dashLine.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

