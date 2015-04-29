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
    //var imgView = UIImageView()
    var img = UIImage()
    var subimg = UIImage()
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var offset = CGPoint()
    //
    //var scrollView = UIScrollView()
    
    var ratio = CGFloat()
    var ratio_height = CGFloat()
    

    var sticker : StickerView = StickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()

        
        imgView.frame = CGRectMake(10, 25, 350, 410)
        img = resizeImage(img, size: imgView.frame.size)
        img =  cropImage(imgView, image: img)

        imgView.image = img
        imgView.userInteractionEnabled = true
        

        subimg = UIImage(named: "1.png")!
        
        
      //  imgView.addSubview(mark.imageView)
      //  self.view.addSubview(imgView)
        
       // println("imageView2 origin \(self.mark.imageView.frame.origin)")

        
     
        
      
        scrollView.contentSize = CGSizeMake(180*CGFloat(self.photonumbers)+CGFloat(self.photonumbers*4),self.view.frame.height*0.2)
        scrollView.frame =  CGRectMake(0, 450, 360, self.scrollView.contentSize.height)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        
    
        
        
        for var i = 1 ; i <= photonumbers ; i++ {
            
            var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
            tap.delegate = self
            var imageV :UIImageView = UIImageView(frame:CGRectMake(CGFloat((i-1)*180+4*i), 4, 180, self.scrollView.frame.height-8))
            println("imageV height \(scrollView.frame.height)")
                println("imageV height \(scrollView.contentSize.height)")
            var demo_img = UIImage(named: "\(i)_\(i).jpg")
           
            demo_img = resizeImage(demo_img!, size: imageV.frame.size)
            imageV.image =  cropImage(imageV, image: demo_img!)
            imageV.userInteractionEnabled = true
            imageV.tag = i
            imageV.addGestureRecognizer(tap)
            
            
            
            
            self.scrollView.addSubview(imageV)
        }
        
        self.view.addSubview(scrollView)
        
        sticker = StickerView(frame: CGRect(x: 80, y: 150, width: 120, height: 120))
        sticker.myinit(subimg)
        self.imgView.addSubview(sticker)
        
    }
    
    

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - save image
    
    
    @IBAction func saveToAlbum(sender: AnyObject) {
        var imgView3 = UIImageView()
        //imgView3.frame = CGRectMake(10, 65, 350, 400)
        imgView3.frame = CGRectMake(10, 65, self.imgView.frame.width, self.imgView.frame.height)
        
        
        sticker.scaleButton.alpha = 0
        

        UIGraphicsBeginImageContextWithOptions(imgView.frame.size, false, 0.0)
        //UIGraphicsBeginImageContext(imgView.frame.size);
        
        var context = UIGraphicsGetCurrentContext()
        //CGContextClipToRect(context, rect)
        // Draw image1
        imgView.layer.renderInContext(context)
        //sticker.imageView.layer.renderInContext(context)
        
        var resultingImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        imgView3.image = resultingImage
        self.view.addSubview(imgView3)
        
        UIImageWriteToSavedPhotosAlbum(resultingImage,nil,nil,nil)
        sticker.scaleButton.alpha = 0.1
        
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
        
        sticker.removeFromSuperview()
        sticker = StickerView(frame: CGRect(x: 80, y: 150, width: 120, height: 120))
        sticker.myinit(subimg)
        imgView.addSubview(sticker)
        if(sender.state == UIGestureRecognizerState.Ended)
        {
             sticker.dismisDashLine()
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
