//
//  ImageViewController.swift
//  CloudApp
//
//  Created by Anusha on 8/17/16.
//  Copyright © 2016 Anusha. All rights reserved.
//

import UIKit
import CloudKit

class ImageViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTapped(sender: AnyObject) {
        let alert = UIAlertController.init(title: "Cloud App", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert .addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.takePhoto()
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert .addAction(UIAlertAction.init(title: "Upload Photo", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) in
            self.uploadPhoto()
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert .addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendToCloud(sender: AnyObject) {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let imageData = UIImageJPEGRepresentation(self.imageView.image!, 0.8)
        let imagePath : String = path.stringByAppendingString("tempImage.png")
        let imageUrl : NSURL = NSURL.fileURLWithPath(imagePath)
        imageData!.writeToURL(imageUrl, atomically: true)
        
        let timeStampString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let recordId = CKRecordID.init(recordName: timeStampString.componentsSeparatedByString(".")[0])
        let record = CKRecord.init(recordType: "Notes", recordID: recordId)
        record.setObject(self.nameTextField.text, forKey: "name")
        record.setObject(self.textView.text, forKey: "description")
        let asset = CKAsset.init(fileURL: imageUrl)
        record.setObject(asset, forKey: "image")
        
        let container = CKContainer.defaultContainer()
        let database = container.privateCloudDatabase
        database.saveRecord(record) { (record : CKRecord?, error : NSError?) in
            if error != nil {
                self.showAlertWithText(error!.description)
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            self.showAlertWithText("Device has no camera")
        }
        else {
            let picker = UIImagePickerController.init()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func uploadPhoto() {
        
        let picker = UIImagePickerController.init()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func showAlertWithText(text:String) {
        let alert = UIAlertController.init(title: "Cloud App", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imageView.image = chosenImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
