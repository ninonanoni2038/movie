//
//  TimeLineViewController.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/08.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage

class TimeLineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        // "Cell" はストーリーボードで設定したセルのID
        let testCell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                               for: indexPath)
        
        // Tag番号を使ってImageViewのインスタンス生成
        let imageView = testCell.contentView.viewWithTag(1) as! UIImageView
        
        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        //let cellImage = UIImage(named: photos[indexPath.row])
        
        // UIImageをUIImageViewのimageとして設定
        //imageView.image = cellImageの代わりが下
        
        imageView.af_setImage(withURL:posts[indexPath.row].imagePath!)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        
        // Tag番号を使ってLabelのインスタンス生成
        let label = testCell.contentView.viewWithTag(2) as! UILabel
        
//        label.text = photos[indexPath.row]の代わりが下
        label.text = posts[indexPath.row].text
        return testCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数は１つ
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        //return photos.count;
        return posts.count;
    }
    
//    @IBAction func print(){
//        Swift.print(posts)
//        Swift.print(posts.count)
//    }
}

