//
//  SCViewController.swift
//  Facebook
//
//  Created by THOTA NAGARAJU on 1/22/20.
//  Copyright © 2020 THOTA NAGARAJU. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare

class SCViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SharingDelegate{
  
    let imagePickerController = UIImagePickerController()
    func sharer(_ sharer: Sharing, didCompleteWithResults results :[String:Any])
    {
        print("share sucess")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
          print("sharing with error")

      }
    func sharerDidCancel(_ sharer: Sharing) {
        print("SharingCancel")
    }
    @IBOutlet weak var lastNmeLbl: UILabel!
    
    @IBOutlet weak var bdyLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
          let GraphReq = GraphRequest(graphPath: "/me", parameters: ["fields" : "name , picture.width(400),first_name,last_name, email, birthday"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
          let connection = GraphRequestConnection()
          connection.add(GraphReq ,completionHandler:  { (connection, values , error) in
              if let responseDic = values as? [String:Any]{
                  
                  
               let fullName = responseDic["name"] as! String
                  
                  let pic = responseDic["picture"] as! [String:Any]
                  let imgDic = pic["data"] as! [String:Any]
                  let imageUrl = imgDic["url"] as! String
                  
                  do{
                      self.imageView.image = UIImage(data: try Data(contentsOf: URL(string: imageUrl)!))
                      
                      self.nameLbl.text = fullName
                      
                  }catch{
                      print("image not display")
                  }
                  
              }
          })
          connection.start()
      }
    

    @IBAction func shareLinkBtn(_ sender: Any) {
       
        let content = ShareLinkContent()
        content.contentURL = URL(string: "https://newsroom.fb.com/")!
        content.quote = "hahaha"
        
        
        let shareDialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        
        shareDialog.mode = .automatic
        shareDialog.show()
        
        
    }
    
    @IBAction func sharePhotoBtn(_ sender: Any) {
   imagePickerController.delegate = self
   imagePickerController.sourceType = .photoLibrary
    imagePickerController.mediaTypes = ["public.image"]
            
           present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func shareVideoBtn(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"] //[String(kUTTypeMovie)]
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        // Use editedImage Here
        
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        // Use originalImage Here
        dismiss(animated: true){
            // if app is available
            if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
                let photo = SharePhoto(image: originalImage, userGenerated: true)
                let content = SharePhotoContent()
                
                content.photos = [photo]
                
                let shareDialog = ShareDialog(fromViewController: self, content: content, delegate: self)
                
                shareDialog.mode = .automatic
                shareDialog.show()

            }else {
                print("app not installed")
                //                    UIApplication.shared.open(URL(string: "itms://itunes.apple.com/in/app/facebook/id284882215")!, options: [ : ], completionHandler: nil)
            }
        }
    }
        
    else if let videoURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
        picker.dismiss(animated: true){
            // if app is available
            if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
                let video =j  ShareVideo(videoURL: videoURL)
                let myContent = ShareVideoContent()
                
                myContent.video = video
                let shareDialog = ShareDialog(fromViewController: self, content: myContent, delegate: self)
                
                shareDialog.mode = .automatic
                shareDialog.show()
            }else {
                print("app not installed")
                //                  UIApplication.shared.open(URL(string: "itms://itunes.apple.com/in/app/facebook/id284882215")!, options: [ : ], completionHandler: nil)
            }
        }
    
    
        }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
