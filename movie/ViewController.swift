//
//  ViewController.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/03.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import UIKit
import PinterestLayout
import Firebase

class ViewController: PinterestVC {
    
    
    
    var posts = [PostData]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let databaseRoot = Database.database().reference()
        
        if Auth.auth().currentUser == nil {
            
            performSegue(withIdentifier: "toRegister", sender: nil)
            
        } else {
            
            databaseRoot.observe(.value, with: { [weak self] snapshots in
                
                guard let self = self else { return }
                self.posts.removeAll()
                
                // 二階層になっているのでこの時点ではユーザーごとのデータ
                for users in snapshots.children {
                    
                    let userSnapshot = users as! DataSnapshot
                    
                    // ここで投稿のデータが取れる（databaseRootをobserveしているため）
                    for content in userSnapshot.children {
                        
                        let contentSnapshot = content as! DataSnapshot
                        // 最後はvalueで取ってこれる
                        let value = contentSnapshot.value as! [String: Any]
                        
                        let userId = value["user"] as! String
                        let text = value["text"] as! String
                        let dateString = value["date"] as! String
                        let imagePath = value["imagePath"] as! String
                        
                        let post = PostData(
                            text: text,
                            name: userId == (Auth.auth().currentUser?.uid)! ? "自分" : "他の人",
                            imagePath: imagePath == "" ? nil : URL(string: imagePath),
                            dateString: dateString,
                            userId: userId)
                        self.posts.append(post)
                    }
                }
                self.posts.reverse()
                self.collectionView.reloadData()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let text = "Some text. Some text. Some text. Some text."
        
        items = [
//            PinterestItem(image: UIImage(named: "apple1 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple2 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple3 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple4 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple5 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple1 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple2 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple3 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple4 2.jpeg")!, text: text),
//            PinterestItem(image: UIImage(named: "apple5 2.jpeg")!, text: text)
        ]

    }

    
    

}


