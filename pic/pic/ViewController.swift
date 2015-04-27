//
//  ViewController.swift
//  pic
//
//  Created by huangyuan on 4/20/15.
//  Copyright (c) 2015 huangyuan. All rights reserved.
//

import UIKit

class ViewController2: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var imgView = UIImageView()
    
    
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imgView.frame = CGRectMake(100, 460, 100, 100)
        img = UIImage(named: "2_2.jpg")!
        imgView.image = img
        self.view.addSubview(imgView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goImage(sender: AnyObject) {
        var pickerImage = UIImagePickerController()
        
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            
            
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            
            
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
            
            
        }
        
        
        pickerImage.delegate = self
        
        
        
        //pickerImage.allowsEditing = true
        
        
        
        self.presentViewController(pickerImage, animated: true, completion: nil)

    }

    @IBAction func test(sender: AnyObject) {
         self.performSegueWithIdentifier("modefy", sender: self)
    }
    @IBAction func goCamera(sender: AnyObject) {
        var sourceType = UIImagePickerControllerSourceType.Camera
        
        
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            
            println(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            
            
        }
        
        
        var picker = UIImagePickerController()
        
        
        
        picker.delegate = self
        
        
        
        picker.allowsEditing = false//设置可编辑
        
        
        
        picker.sourceType = sourceType
        
        
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
      

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        
        println("choose--------->>")
        
        
        
        println(info)
        
        
        //img = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imgView.image = img
        
        picker.dismissViewControllerAnimated(false, completion: nil)
        
        self.performSegueWithIdentifier("modefy", sender: self)
    }
    
    
    //cancel后执行的方法
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        
        println("cancel--------->>")
        
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("**************")
        if(segue.identifier == "modefy")
        {
            var dest : modefyPic = segue.destinationViewController as! modefyPic
            dest.img = self.img
        }
    }
}

