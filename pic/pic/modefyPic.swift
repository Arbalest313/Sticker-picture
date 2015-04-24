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
    var imgView2 = UIImageView()

    var img = UIImage()
    var subimg = UIImage()
    
    var offset = CGPoint()
    //
    var scrollView = UIScrollView()
    
    var ratio = CGFloat()
    var ratio_height = CGFloat()
    var lastScale = CGFloat()
    var base_dist = CGFloat()
    var location2 = CGPoint()
    var last_location = CGPoint()
    
    var scaleButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()

        
        imgView.frame = CGRectMake(10, 25, 350, 410)
        imgView2.frame = CGRectMake(80,50, baselength, baselength)
        img = resizeImage(img, size: imgView.frame.size)
        img =  cropImage(imgView, image: img)
        //img = Toucan(image: img).resize(CGSize(width: imgView.frame.width, height: imgView.frame.height), fitMode: Toucan.Resize.FitMode.Crop).image
        imgView.image = img
        imgView.userInteractionEnabled = true
        imgView2.userInteractionEnabled = true
        subimg = UIImage(named: "1.png")!
        
        //image resize according to image the width and height ratio
        var ratio_img = subimg.size.height / subimg.size.width
        if(ratio_img >= 0){
            //imgView2.transform = CGAffineTransformScale(imgView2.transform, CGFloat(1), ratio_img)
            imgView2.frame = CGRect(x: imgView2.frame.origin.x, y: imgView2.frame.origin.y,width: baselength,height: baselength*ratio_img)
        }
        else{
            ratio_img = subimg.size.width / subimg.size.height
            //mgView2.transform = CGAffineTransformScale(imgView2.transform, ratio_img, CGFloat(1))
            imgView2.frame = CGRect(x: imgView2.frame.origin.x, y: imgView2.frame.origin.y,width: baselength*ratio_img,height: baselength)
        }

        
        
        imgView2.image = subimg
        imgView.addSubview(imgView2)
        //imgView.contentMode = UIViewContentModeScaleAspectFit
        self.view.addSubview(imgView)
        
        println("imageView2 origin \(self.imgView2.frame.origin)")
        println("imageView2 origin \(self.imgView2.bounds.origin)")
        
        var press_imgView2 : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "tap_imgView2:")
        press_imgView2.delegate = self
        press_imgView2.minimumPressDuration = 0.01
        //last_location = imgView2.frame.origin
        //tap_imgView2.addTarget(self, action: "tap_imgView2:", forControlEvents: UIControlEventTouchDown)
        //self.imgView2.addGestureRecognizer(press_imgView2)
        
        
        var pinch :UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "scale:")
        self.imgView2.addGestureRecognizer(pinch)
        pinch.delegate = self
        
        var dragging : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "move:")
        self.imgView2.addGestureRecognizer(dragging)
        dragging.delegate = self
        
      
        scrollView.contentSize = CGSizeMake(180*CGFloat(self.photonumbers)+CGFloat(self.photonumbers*4),108)
        scrollView.frame =  CGRectMake(0, 450, 360, 108)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        
    
        //self.scrollView.addGestureRecognizer(pinch)
        //self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
        last_location = imgView2.frame.origin
        scaleButton.frame = CGRect(x: imgView2.frame.size.width+imgView2.frame.origin.x,y: imgView2.frame.origin.y-20,width: 20,height: 20)
        scaleButton.titleLabel?.text = "X"
        scaleButton.setTitle("X", forState: UIControlState.Normal)
        scaleButton.hidden = false
        scaleButton.userInteractionEnabled = true
        var draggingBTN : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "scaleImage:")
        self.imgView2.addGestureRecognizer(draggingBTN)
        draggingBTN.delegate = self
        //scaleButton.addTarget(self, action: "scaleImage:", forControlEvents: UIControlEvents.Touch)
        scaleButton.addGestureRecognizer(draggingBTN)
        self.imgView.addSubview(scaleButton)
        
        
        for var i = 1 ; i <= photonumbers ; i++ {
            
            var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
            tap.delegate = self
            var imageV :UIImageView = UIImageView(frame:CGRectMake(CGFloat((i-1)*180+4*i), 4, 180, 100))
            var demo_img = UIImage(named: "\(i)_\(i).jpg")
            //self.scaleimagetoView(imageV, image: demo_img!)
            //imageV.image = UIImage(named: "\(i)_\(i).jpg")
            //imageV.image = Toucan(image: demo_img!).resize(CGSize(width: imageV.frame.width, height: imageV.frame.height), fitMode: Toucan.Resize.FitMode.Crop).image
            demo_img = resizeImage(demo_img!, size: imageV.frame.size)
            imageV.image =  cropImage(imageV, image: demo_img!)
            imageV.userInteractionEnabled = true
            imageV.tag = i
            imageV.addGestureRecognizer(tap)
            
            
            
            
            self.scrollView.addSubview(imageV)
        }
        
        self.view.addSubview(scrollView)
        
    }
    
    func move(sender: UIPanGestureRecognizer ){
        
        if(sender.state == UIGestureRecognizerState.Began)
        {
            location2 = sender.locationInView(imgView2)
            println("location in imgView2 \(location2) frame \(imgView2.frame)")
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
        var maxX = self.imgView.frame.width - self.imgView2.frame.width
        var maxY = self.imgView.frame.height - self.imgView2.frame.height
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
        imgView2.frame.origin = location
        var orig = CGPoint(x: location.x+self.imgView2.frame.width, y: location.y-20)
        scaleButton.frame.origin = orig
       }
    
    func scale(sender: UIPinchGestureRecognizer ){
        
        
        sender.scale = sender.scale - lastScale+1
        println("\(imgView2.frame.width*sender.scale+self.imgView2.frame.origin.x)")
        //if(imgView.frame.width > (imgView2.frame.width*sender.scale+self.imgView2.frame.origin.x) && imgView.frame.height > (imgView2.frame.height*sender.scale+self.imgView2.frame.origin.y)
       //    && imgView2.frame.width > baselength*0.2 && imgView2.frame.height > baselength*0.15
        //    )
        if(imgView2.frame.origin.x > 1 && imgView2.frame.origin.y > 1 && imgView.frame.width > (imgView2.frame.width*sender.scale+self.imgView2.frame.origin.x) && imgView.frame.height > (imgView2.frame.height*sender.scale+self.imgView2.frame.origin.y) && imgView2.frame.width > baselength*0.3 && imgView2.frame.height > baselength*0.3)
        {
            //imgView2.transform = CGAffineTransformScale(imgView2.transform, sender.scale, sender.scale)
            var newx = imgView2.frame.origin.x-( imgView2.frame.width*sender.scale - imgView2.frame.width )
            var  newy = imgView2.frame.origin.y-( imgView2.frame.height*sender.scale - imgView2.frame.height )
            imgView2.frame = CGRect(x: newx, y: newy,width: imgView2.frame.width*sender.scale,height: imgView2.frame.height*sender.scale)
        }
        lastScale = sender.scale
        // 会被多次调用这个方法，所以每次都要重置缩放倍数为原始倍数
        //sender.scale = 1.0
        
    
    }
    
    func scaleImage(sender: UIPanGestureRecognizer ){
        println("scaling")
        
        var location = sender.locationInView(imgView)
        
        if(sender.state == UIGestureRecognizerState.Began)
        {
            last_location = location
            var center :CGPoint = CGPoint(x: self.imgView2.frame.width/2+self.imgView2.frame.origin.x, y: self.imgView2.frame.height/2+self.imgView2.frame.origin.y)
             self.base_dist = CGFloat(sqrt(pow(center.x-self.last_location.x, 2) + pow(center.y-self.last_location.y, 2)))
        }
        var center :CGPoint = CGPoint(x: self.imgView2.frame.width/2+self.imgView2.frame.origin.x, y: self.imgView2.frame.height/2+self.imgView2.frame.origin.y)
        var dist = CGFloat(sqrt(pow(location.x-center.x, 2) + pow(location.y-center.y, 2)))
        println("base distence \(base_dist) distence \(dist)")
       
        
        var scale = CGFloat( dist/base_dist)
         println("\(scale)")
        if(imgView2.frame.origin.x > 1 && imgView2.frame.origin.y > 1 && imgView.frame.width > (imgView2.frame.width*scale+self.imgView2.frame.origin.x) && imgView.frame.height > (imgView2.frame.height*scale+self.imgView2.frame.origin.y) && imgView2.frame.width > baselength*0.3 && imgView2.frame.height > baselength*0.3){
            
        var newx = imgView2.frame.origin.x-( imgView2.frame.width*scale - imgView2.frame.width )
        var  newy = imgView2.frame.origin.y-( imgView2.frame.height*scale - imgView2.frame.height )
        imgView2.frame = CGRect(x: newx, y: newy,width: imgView2.frame.width*scale,height: imgView2.frame.height*scale)
        var newOrigin = CGPoint(x: newx+imgView2.frame.width, y:newy-20)
        println("the new origin\(newOrigin)")
        var btn = sender.view as! UIButton
        btn.frame.origin = newOrigin
        }
        //var moving =CGPoint(x: <#CGFloat#>, y: <#CGFloat#>) CGPoint (x:location.x-self.last_location,y: location.y-self.last_location.y)
        // 会被多次调用这个方法，所以每次都要重置缩放倍数为原始倍数
        //sender.scale = 1.0

    }

    
    func tap(sender: UITapGestureRecognizer ){
        var imgV : UIImageView = sender.view as! UIImageView
        println(imgV.tag)
        //subimg = imgV.image!
        subimg = UIImage(named: "\(imgV.tag).png")!
        //self.scaleimagetoView(imgView2, image: subimg)
        //CGSizeApplyAffineTransform(basesize, imgView2.transform)
 
        self.imgView2.frame = CGRectMake(80,50, baselength, baselength)
        
        var ratio_img = subimg.size.height / subimg.size.width
        if(ratio_img >= 0){
            //imgView2.transform = CGAffineTransformScale(imgView2.transform, CGFloat(1), ratio_img)
            imgView2.frame = CGRect(x: 80, y: 50,width: baselength,height: baselength*ratio_img)
        }
        else{
            ratio_img = subimg.size.width / subimg.size.height
            //mgView2.transform = CGAffineTransformScale(imgView2.transform, ratio_img, CGFloat(1))
            imgView2.frame = CGRect(x: 80, y: 50,width: baselength*ratio_img,height: baselength)
        }
        println(self.imgView2.frame)
        imgView2.image = subimg
       // imgView2.image = Toucan(image: subimg).resize(CGSize(width: imgView2.frame.width, height: imgView2.frame.height), fitMode: Toucan.Resize.FitMode.Crop).image
        //println(sender.delegate.
    }
    
    
    func tap_imgView2(sender: UITapGestureRecognizer ){
        location2 = sender.locationInView(imgView2)
        println("location in imgView2 \(location2) frame \(imgView2.frame)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func saveToAlbum(sender: AnyObject) {
        var imgView3 = UIImageView()
        imgView3.frame = CGRectMake(10, 65, 350, 400)
        
        
        ratio = imgView2.frame.size.width / imgView.frame.size.width
        ratio_height = imgView2.frame.size.height / imgView.frame.size.height
        var ratio2 = (imgView2.frame.origin.x) / imgView.frame.size.width
        var ratio3 = (imgView2.frame.origin.y) / imgView.frame.size.height
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

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset :CGPoint = scrollView.contentOffset
        self.offset = offset
        //var intset :CGPoint = scrollView.contentInset
        println(offset)
       
    }
    
    
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
