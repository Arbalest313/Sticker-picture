//
//  StickerView.swift
//  pic
//
//  Created by huangyuan on 4/28/15.
//  Copyright (c) 2015 huangyuan. All rights reserved.
//

import UIKit

class StickerView: UIView,UIGestureRecognizerDelegate {
    var imageView = UIImageView()
    var scaleButton = UIButton() // button to scale the picture
    var dashLine = UIImageView()
    
    let baselength_BTN = CGFloat(30)
    let baselength = CGFloat(100)
    let basesize = CGSize(width: 100, height: 100) // base size of imageView
    var base_dist = CGFloat() //distence from center to button
    

    var initbound = CGRect()
    var initcenter = CGPoint()
    var imgbound = CGRect()
    var first_location = CGPoint()
    
    var lastScale = CGFloat()
    var lastAngle = CGFloat()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 1
    }
    
     func myinit( img : UIImage)
    {
        imageView.frame = CGRectMake(0,baselength_BTN, baselength, baselength)
        imageView.userInteractionEnabled = true
        resizeFrame(img)
        imageView.image = img
        self.addSubview(imageView)
        
        scaleButton.frame = CGRect(x: imageView.frame.size.width,y: 0,width: self.baselength_BTN,height: self.baselength_BTN)
        scaleButton.setTitle("X", forState: UIControlState.Normal)
        scaleButton.hidden = false
        scaleButton.userInteractionEnabled = true
        self.addSubview(scaleButton)
        
        //self.drawDashLine()
        dashLine.frame = CGRectMake(0, baselength_BTN, imageView.frame.width, imageView.frame.height)
        self.drawDashLine()
        self.addSubview(self.dashLine)
        
        //guesture
        var dragging : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "move:")
        imageView.addGestureRecognizer(dragging)
        dragging.delegate = self
        
        var scaling : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "scaleImage2:")
        scaling.delegate = self
        scaleButton.addGestureRecognizer(scaling)
        
        self.dismisDashLine()
    }
    
    func resizeFrame(img : UIImage)
    {
        var ratio_img = img.size.height / img.size.width
        if(ratio_img <= 1){
            
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y,width: baselength,height: baselength*ratio_img)
        }
        else{
            ratio_img = img.size.width / img.size.height
            
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y,width: baselength*ratio_img,height: baselength)
        }
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y
            , width: imageView.frame.width+self.baselength_BTN, height: imageView.frame.height+self.baselength_BTN)
    }
    
    func dismisDashLine(){
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.dashLine.alpha = 0
            self.scaleButton.alpha = 0.1
        })
    }
    func drawDashLine(){
        
        self.scaleButton.alpha = 1
        dashLine.frame =  CGRectMake(0, baselength_BTN, imageView.frame.width, imageView.frame.height)
        dashLine.alpha = 1
        dashLine.image = nil
        
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
    
    
    // self: - self Gesture
    func move(sender: UIPanGestureRecognizer ){
        var imgView : UIImageView = self.superview as! UIImageView
        println("the frame is :\(self.frame) the center is \(self.center)")
        if(sender.state == UIGestureRecognizerState.Began)
        {
            first_location = sender.locationInView(imgView)
            println("location in self.imageView \(first_location) frame \(self.imageView.frame)")
            self.drawDashLine()
            self.dashLine.alpha = 1
            initcenter = self.center
            initbound = self.bounds
        }
        var location = sender.locationInView(imgView)
        
        
        location.x = location.x - first_location.x
        location.y = location.y - first_location.y
        var newx = initcenter.x+location.x
        var newy = initcenter.y+location.y
        println("moving destance :\(location)")
        if(newx < round(self.imageView.frame.width/2) )
        {    newx = (self.frame.width/2)
        }
        if(newy < round(self.imageView.frame.height/2) )
        {   newy = (self.frame.height/2) - self.baselength_BTN
        }
        var maxX = imgView.frame.width - (self.imageView.frame.width/2)+self.baselength_BTN/2
        var maxY = imgView.frame.height - (self.frame.height/2)
        if(newx > maxX)
        {
            newx = maxX
        }
        if(newy > maxY)
        {
            newy = maxY
        }
        println("moving")
        println("the new center : \(self.center)")
        self.center = CGPoint(x:newx , y: newy )
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            self.dismisDashLine()
        }
    }
    
    
    func scaleImage2(sender: UIPanGestureRecognizer ){
        
        var imgView : UIImageView = self.superview as! UIImageView
        var location = sender.locationInView(imgView)
        
        var center :CGPoint = CGPoint(x: self.frame.width/2+self.frame.origin.x, y: self.frame.height/2+self.frame.origin.y)
        
        
        
        if(sender.state == UIGestureRecognizerState.Began)
        {
            lastScale = CGFloat( 1)
            self.drawDashLine()
            self.base_dist = location.x - center.x
            
            first_location = location
            dashLine.alpha = 1
            initbound = self.bounds
            imgbound = self.imageView.bounds
            
            self.base_dist = CGFloat(sqrt(pow(center.x-self.first_location.x, 2) + pow(center.y-self.first_location.y, 2)))
        }
        
        var dist = location.x - center.x
         dist = CGFloat(sqrt(pow(location.x-center.x, 2) + pow(location.y-center.y, 2)))

        var scale = CGFloat( dist/self.base_dist)
        scale = scale - lastScale + 1
        //println("base distence \(self.base_dist) distence \(dist)")
        
        var fromAngle = atan2(first_location.y-center.y, first_location.x-center.x)
        var toAngle = atan2(location.y-center.y, location.x-center.x)
        var newAngle = wrapd(self.lastAngle + (toAngle - fromAngle), min: 0, max: 2*3.14)
        var oneInFifty : Int = Int(((toAngle - fromAngle)*50)/(2*3.14))
        println("Angle : \(newAngle) in50: \(oneInFifty)")
        
        if (sender.state == UIGestureRecognizerState.Changed) {
        
        
        
        //oneInFifty == 0 , the angle is not big engough to rotate if oneInFity is 0, then you may scale the frame
        
            //println("last scale ratio is \(lastScale)")
            
            println("scale ratio is \(scale)")
            //
            var newx = self.frame.origin.x-( self.imageView.frame.width*scale - self.imageView.frame.width )
            var  newy = self.frame.origin.y-( self.imageView.frame.height*scale - self.imageView.frame.height )
            
            println("the new X : \(self.frame.origin.x) the new Y : \(self.frame.origin.y)")
            println("the new X : \(newx) the new Y : \(newy)")
        
            self.transform = CGAffineTransformMakeRotation(newAngle)
            if (newx > 1 && newy > 1 &&  imgView.frame.width > round(newx+self.frame.width*scale) && imgView.frame.height > round(self.frame.height*scale+newy) && round(self.frame.width*scale) > self.baselength*0.3+self.baselength_BTN && round(self.frame.height*scale) > self.baselength*0.3+self.baselength_BTN){
                
                
                self.bounds = CGRectMake(initbound.origin.x*scale, initbound.origin.y*scale, imgbound.width*scale+self.baselength_BTN, imgbound.height*scale+self.baselength_BTN)
                self.imageView.bounds = CGRectMake(0, self.baselength_BTN, imgbound.width*scale, imgbound.height*scale)
                self.imageView.frame = self.imageView.bounds
               // self.frame = CGRect(x: newx, y: newy,width: self.imageView.frame.width*scale+self.baselength_BTN,height: self.imageView.frame.height*scale+self.baselength_BTN)
//                imageView.frame = CGRect(x: 0, y: self.baselength_BTN,width: imageView.frame.width*scale,height: imageView.frame.height*scale)
                
                var newOrigin = CGPoint(x: imageView.frame.width, y:0) //button's new origin
                self.scaleButton.frame.origin = newOrigin


                self.drawDashLine()
              
                
             println("view - the frame : \(self.frame) \nthe bounds:\(self.bounds)")
               println("image - the frame : \(self.imageView.frame) \nthe bounds:\(self.imageView.bounds)")
            }
//        if(oneInFifty == 0)
//        {

            
//        }
        //       println(rotation)
        }
        
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            self.self.dismisDashLine()
            lastAngle = newAngle
            //scale_enable = true
        }
        
        lastScale = scale
        
        
        
    }
    
    
    func wrapd(val: CGFloat, min : CGFloat, max: CGFloat) -> CGFloat{
        if(val < min){return (max - (min - val))}
        if (val > max){return (min - (max - val))}
        return val
    }

}
