//
//  modefyPic.swift
//  pic
//
//  Created by huangyuan on 4/20/15.
//  Copyright (c) 2015 huangyuan. All rights reserved.
//

import UIKit
//import Toucan

class modefyPic: UIViewController, UIScrollViewDelegate,UIGestureRecognizerDelegate{

    let photonumbers = 14
    let baselength = CGFloat(100)
    let basesize = CGSize(width: 100, height: 100)
    var imgView = UIImageView()
    var img = UIImage()
    var subimg = UIImage()
    
    
    var offset = CGPoint()
    //
    var scrollView = UIScrollView()
    
    var ratio = CGFloat()
    var ratio_height = CGFloat()
    var lastScale = CGFloat()
    var location2 = CGPoint()
    var last_location = CGPoint()
    
    var mark : Mark = Mark()
    var scaleButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()

        
        imgView.frame = CGRectMake(10, 25, 350, 410)
        img = resizeImage(img, size: imgView.frame.size)
        img =  cropImage(imgView, image: img)

        imgView.image = img
        imgView.userInteractionEnabled = true
        

        subimg = UIImage(named: "1.png")!
        mark = Mark(img: subimg,x: 80,y: 50)
        
        
        imgView.addSubview(mark.imageView)
        self.view.addSubview(imgView)
        
        println("imageView2 origin \(self.mark.imageView.frame.origin)")

        
        var dragging : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "move:")
        mark.imageView.addGestureRecognizer(dragging)
        dragging.delegate = self
        
      
        scrollView.contentSize = CGSizeMake(180*CGFloat(self.photonumbers)+CGFloat(self.photonumbers*4),108)
        scrollView.frame =  CGRectMake(0, 450, 360, 108)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        
    
    
        last_location = mark.imageView.frame.origin
        var draggingBTN : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "scaleImage2:")
        draggingBTN.delegate = self
        mark.scaleButton.addGestureRecognizer(draggingBTN)
        var rotateBTN : UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "rotate:")
        rotateBTN.delegate = self
        //mark.imageView.addGestureRecognizer(rotateBTN)
        
        self.imgView.addSubview(mark.scaleButton)
        
        
        for var i = 1 ; i <= photonumbers ; i++ {
            
            var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
            tap.delegate = self
            var imageV :UIImageView = UIImageView(frame:CGRectMake(CGFloat((i-1)*180+4*i), 4, 180, 100))
            var demo_img = UIImage(named: "\(i)_\(i).jpg")
           
            demo_img = resizeImage(demo_img!, size: imageV.frame.size)
            imageV.image =  cropImage(imageV, image: demo_img!)
            imageV.userInteractionEnabled = true
            imageV.tag = i
            imageV.addGestureRecognizer(tap)
            
            
            
            
            self.scrollView.addSubview(imageV)
        }
        
        self.view.addSubview(scrollView)
        
    }
    
     // MARK: - mark Gesture
    func move(sender: UIPanGestureRecognizer ){
        
        if(sender.state == UIGestureRecognizerState.Began)
        {
            location2 = sender.locationInView(mark.imageView)
            println("location in mark.imageView \(location2) frame \(mark.imageView.frame)")
            self.mark.drawDashLine()
             self.mark.dashLine.alpha = 1
        }
        var location = sender.locationInView(self.imgView)
        println(location)
        location.x = location.x - location2.x
        location.y = location.y - location2.y
        
        if(location.x < 0)
        {    location.x = 1
        }
        if(location.y < 0)
        {   location.y = 1
        }
        var maxX = self.imgView.frame.width - mark.imageView.frame.width
        var maxY = self.imgView.frame.height - mark.imageView.frame.height
        if(location.x > maxX)
        {
            location.x = maxX
        }
        if(location.y > maxY)
        {
            location.y = maxY
        }
        println("moving")
        println(location)
        mark.imageView.frame.origin = location
        var orig = CGPoint(x: location.x+mark.imageView.frame.width, y: location.y-20)
        mark.scaleButton.frame.origin = orig
        
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            self.mark.dismisDashLine()
        }
       }
    
    var rotation = CGFloat()
    func rotate(sender: UIRotationGestureRecognizer ){
        rotation = sender.rotation
        println("roating")
        mark.imageView.transform = CGAffineTransformMakeRotation(rotation)
        mark.scaleButton.transform = CGAffineTransformMakeRotation(rotation)
        mark.dashLine.transform = CGAffineTransformMakeRotation(rotation)
        //sender.rotation = 0
    }
    func scaleImage2(sender: UIPanGestureRecognizer ){

        
        var location = sender.locationInView(imgView)
        var center :CGPoint = CGPoint(x: mark.imageView.frame.width/2+mark.imageView.frame.origin.x, y: mark.imageView.frame.height/2+mark.imageView.frame.origin.y)
        if(sender.state == UIGestureRecognizerState.Began)
        {
            lastScale = 1
            
            
            mark.base_dist = location.x - center.x
            
        }
        var dist = location.x - center.x
        
//        var y = location.y - center.y
//        rotation = tan(y/self.mark.base_dist) //tan(y/x)
//        rotation = atan(rotation)
        
        println("base distence \(mark.base_dist) distence \(dist)")
        
        println("last scale ratio is \(lastScale)")
        var scale = CGFloat( dist/mark.base_dist)
        scale = scale - lastScale + 1
        println("scale ratio is \(scale)")

        var newx = mark.imageView.frame.origin.x-( mark.imageView.frame.width*scale - mark.imageView.frame.width )
        var  newy = mark.imageView.frame.origin.y-( mark.imageView.frame.height*scale - mark.imageView.frame.height )
        
            
        mark.scaleButton.transform = CGAffineTransformMakeRotation(rotation)
        if (newx > 1 && newy > 1 &&  imgView.frame.width > round(newx+mark.imageView.frame.width*scale) && imgView.frame.height > round(mark.imageView.frame.height*scale+newy) && round(mark.imageView.frame.width*scale) > mark.baselength*0.3 && round(mark.imageView.frame.height*scale) > mark.baselength*0.3){
            mark.imageView.frame = CGRect(x: newx, y: newy,width: mark.imageView.frame.width*scale,height: mark.imageView.frame.height*scale)
            //mark.dashLine.frame = CGRect(x: 0, y: 0,width: mark.imageView.frame.width,height: mark.imageView.frame.height)
            var newOrigin = CGPoint(x: newx+mark.imageView.frame.width, y:newy-mark.scaleButton.frame.height) //button's new origin
            var btn = sender.view as! UIButton
            btn.frame.origin = newOrigin
            
            mark.drawDashLine()
            
            
        }
        
        println(rotation)
    
        
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            self.mark.dismisDashLine()
        }
        
        lastScale = scale

    
    }
    
    func scaleImage(sender: UIPanGestureRecognizer ){
        println("scaleing")
        var location = sender.locationInView(imgView)
        if(sender.state == UIGestureRecognizerState.Began)
        {
            lastScale = 1
            last_location = CGPoint(x:mark.scaleButton.frame.width/2+mark.scaleButton.frame.origin.x, y: mark.scaleButton.frame.height/2+mark.scaleButton.frame.origin.y)
            var center :CGPoint = CGPoint(x: mark.imageView.frame.width/2+mark.imageView.frame.origin.x, y: mark.imageView.frame.height/2+mark.imageView.frame.origin.y)
             mark.base_dist = CGFloat(sqrt(pow(center.x-self.last_location.x, 2) + pow(center.y-self.last_location.y, 2)))
        }
        var center :CGPoint = CGPoint(x: mark.imageView.frame.width/2+mark.imageView.frame.origin.x, y: mark.imageView.frame.height/2+mark.imageView.frame.origin.y)
        var dist = CGFloat(sqrt(pow(location.x-center.x, 2) + pow(location.y-center.y, 2)))
        
        println("base distence \(mark.base_dist) distence \(dist)")
       
         println("last scale ratio is \(lastScale)")
        var scale = CGFloat( dist/mark.base_dist)
        scale = scale - lastScale
        println("scale ratio is \(scale)")
        
        println("w :\(round(mark.imageView.frame.width*scale+mark.imageView.frame.origin.x)) h:\(round(mark.imageView.frame.height*scale+mark.imageView.frame.origin.y))")
        println("w :\(round(mark.imageView.frame.width*scale)) h:\(round(mark.imageView.frame.height*scale))")
  
            
        var newx = mark.imageView.frame.origin.x-( mark.imageView.frame.width*scale - mark.imageView.frame.width )
        var  newy = mark.imageView.frame.origin.y-( mark.imageView.frame.height*scale - mark.imageView.frame.height )
        
        if (newx > 1 && newy > 1 &&  imgView.frame.width > round(newx+mark.imageView.frame.width*scale) && imgView.frame.height > round(mark.imageView.frame.height*scale+newy) && round(mark.imageView.frame.width*scale) > mark.baselength*0.3 && round(mark.imageView.frame.height*scale) > mark.baselength*0.3){
        mark.imageView.frame = CGRect(x: newx, y: newy,width: mark.imageView.frame.width*scale,height: mark.imageView.frame.height*scale)
        //mark.dashLine.frame = CGRect(x: 0, y: 0,width: mark.imageView.frame.width,height: mark.imageView.frame.height)
        var newOrigin = CGPoint(x: newx+mark.imageView.frame.width, y:newy-mark.scaleButton.frame.height) //button's new origin
        var btn = sender.view as! UIButton
        btn.frame.origin = newOrigin
        
        mark.drawDashLine()

        
        }
       
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            self.mark.dismisDashLine()
        }
    
        lastScale = scale
    }

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - save image
    
    @IBAction func saveToAlbum(sender: AnyObject) {
        var imgView3 = UIImageView()
        imgView3.frame = CGRectMake(10, 65, 350, 400)
        
        
        ratio = mark.imageView.frame.size.width / imgView.frame.size.width
        ratio_height = mark.imageView.frame.size.height / imgView.frame.size.height
        var ratio2 = (mark.imageView.frame.origin.x) / imgView.frame.size.width
        var ratio3 = (mark.imageView.frame.origin.y) / imgView.frame.size.height
        println(ratio)
        println(ratio2)
        println(ratio3)
        
        var imgRef :CGImageRef = self.img.CGImage
        let originalWidth  = CGFloat(CGImageGetWidth(imgRef))
        let originalHeight = CGFloat(CGImageGetHeight(imgRef))
        let rect = CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight)
        let rect2 = CGRect(x: originalWidth*ratio2, y: originalHeight*ratio3, width: originalWidth*self.ratio, height: originalHeight*self.ratio_height)
        
        UIGraphicsBeginImageContext(rect.size);
        println(img.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextClipToRect(context, rect)
        // Draw image1
        img.drawInRect(rect)
        subimg.drawInRect(rect2)
    
        
        var resultingImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        imgView3.image = resultingImage
        self.view.addSubview(imgView3)
        
        UIImageWriteToSavedPhotosAlbum(resultingImage,nil,nil,nil)
        println("saved-------------")
    }
    
    
 // MARK: - scrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset :CGPoint = scrollView.contentOffset
        self.offset = offset
        //var intset :CGPoint = scrollView.contentInset
        println(offset)
       
    }
    
    func tap(sender: UITapGestureRecognizer ){
        var imgV : UIImageView = sender.view as! UIImageView
        println(imgV.tag)
        //subimg = imgV.image!
        subimg = UIImage(named: "\(imgV.tag).png")!
        
        //        mark.imageView.frame = CGRectMake(80,50, mark.baselength, mark.baselength)
        //        mark.scaleButton.frame = CGRectMake(80,50, mark.baselength_BTN, mark.baselength_BTN)
        //        var ratio_img = subimg.size.height / subimg.size.width
        //        self.resizeFrame(subimg, imageView: mark.imageView)
        //        println(mark.imageView.frame)
        //        mark.imageView.image = subimg
        //        mark.dashLine.image = nil
        mark.reinit(subimg, x: 80, y: 50)
        mark.drawDashLine()
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            self.mark.dismisDashLine()
        }
    }

    
     // MARK: - resieze image
    func resizeImage(image :UIImage, size : CGSize) ->UIImage
    
    {
        var imgRef :CGImageRef = image.CGImage
        let originalWidth  = CGFloat(CGImageGetWidth(imgRef))
        let originalHeight = CGFloat(CGImageGetHeight(imgRef))
        let widthRatio = size.width / originalWidth
        let heightRatio = size.height / originalHeight
        
        let scaleRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        let rect = CGRect(x: 0, y: 0, width: round(originalWidth * scaleRatio), height: round(originalHeight * scaleRatio))
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        var context = UIGraphicsGetCurrentContext()
        CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height))
        image.drawInRect(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    
    }
    
    
    func cropImage(imgV: UIImageView, image:UIImage) -> UIImage{
        var size : CGSize = imgV.frame.size
        let croppedRect = CGRect(x: (image.size.width - size.width) / 2,
            y: (image.size.height - size.height) / 2,
            width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(croppedRect.size, false, 0)
        var context = UIGraphicsGetCurrentContext()
        let drawRect = CGRectMake(-croppedRect.origin.x, -croppedRect.origin.y, image.size.width, image.size.height)
        CGContextClipToRect(context, CGRectMake(0, 0, croppedRect.size.width, croppedRect.size.height))
        image.drawInRect(drawRect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    
    }
    
    func resizeFrame(img : UIImage,imageView : UIImageView)
    {
        var ratio_img = img.size.height / img.size.width
        if(ratio_img >= 0){
            //imageView.transform = CGAffineTransformScale(imageView.transform, CGFloat(1), ratio_img)
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y,width: baselength,height: baselength*ratio_img)
        }
        else{
            ratio_img = img.size.width / img.size.height
            //mgView2.transform = CGAffineTransformScale(imageView.transform, ratio_img, CGFloat(1))
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y,width: baselength*ratio_img,height: baselength)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
