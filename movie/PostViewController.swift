//
//  PostViewController.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/07.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!//投稿のための画像
    @IBOutlet var textfield: UITextField!//投稿のためのテキスト
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func useCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }else{
            print("error")
        }
    }
    
    //カメラ、カメラロールを使ったときに選択した画像をアプリ内に表示するメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        cameraImageView.image = info[.originalImage]as? UIImage
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func openAlbum(){
        
        //カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            //カメラロールの画像を選択して画像を表示する
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker,animated: true,completion: nil)
        }
    }
    
    @IBAction func post(){
        if textfield.text == "" && cameraImageView.image == nil {
            
            // アラートを出す
            let alertController = UIAlertController(title: "投稿エラー", message: "投稿内容がありません。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            // 途中で処理を終了したいときはその場でreturn
            return
        }
        // Realmに保存
        let post = Post.create()
        post.name = "自分"
        post.date = Date()
        post.text = textfield.text!
        // if let文は繋げられる
        if let image = cameraImageView.image {
            // jpgの形式にしてサイズをなるべく小さくしたものを保存（16MB以上だとRealmに保存できないため）
            post.imageData = image.jpegData(compressionQuality: 0.2)
        }
        post.save()
        
        // Firebaseに保存
        /// RealtimeDatabaseの大元
        let databaseRoot = Database.database().reference()
        /// Storageの大元
        let storageRoot = Storage.storage().reference()
        
        if let data = post.imageData {
            
            // 画像名を決定するためにまずデータを保存する場所を予め作っておく
            let postPlace = databaseRoot.child((Auth.auth().currentUser?.uid)!).childByAutoId()
            let imageName = postPlace.key! + ".png"
            storageRoot.child("images").child(imageName).putData(data, metadata: nil, completion: { [weak self] metadata, error in
                
                guard let self = self else { return }
                
                if let error = error {
                    
                    let alertController = UIAlertController(title: "アップロードエラー", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                storageRoot.child("images").child(imageName).downloadURL(completion: { url, error in
                    
                    databaseRoot.child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue([
                        "user": (Auth.auth().currentUser?.uid)!,
                        "text": post.text,
                        "date": post.dateString,
                        "imagePath": url?.absoluteString ?? ""
                        ])
                    self.dismiss(animated: true, completion: nil)
                })
            })
        } else {
            
            // なければそのまま画像以外を保存する
            // ユーザーごとの場所に投稿が保存されていくかたちにする
            // ログインされていない場合投稿されるのはおかしいのでわざと強制アンラップにする
            databaseRoot.child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue([
                "user": (Auth.auth().currentUser?.uid)!,
                "text": post.text,
                "date": post.dateString,
                "imagePath": ""
                ])
            dismiss(animated: true, completion: nil)
        }
    }
    
//    @IBAction func touchUpInsideCancelButton(_ sender: Any) {
//
//        // 編集されていた場合（UXの工場のため）
//        if textfield.text != "" || cameraImageView.image != nil {
//
//            // アラートを出す
//            let alertController = UIAlertController(title: "変更内容の破棄", message: "変更内容を破棄しますか?", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
//
//                // 循環参照というものを防ぐためなるべく行う [weak self]とセットの処理
//                // （メンバーにはやらせなくてもいい）
//                guard let self = self else { return }
//
//                // この中身はPostViewControllerの外側なので必ずselfが必要
//                self.dismiss(animated: true, completion: nil)
//            }))
//            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        } else {
//
//            dismiss(animated: true, completion: nil)
//        }
//    }
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}




