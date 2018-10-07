//
//  Post.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/08.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {
    /// PrimaryKey用 ... 投稿一つ一つを区別するために用いる値
    @objc dynamic var id = 0
    /// 投稿の本文
    @objc dynamic var text = ""
    /// 投稿者の名前
    @objc dynamic var name = ""
    /// 投稿された日付
    @objc dynamic var date = Date()
    /// 添付された画像
    @objc dynamic var imageData: Data?
    
    /// 日付を文字列で取得したいときに使う
    var dateString: String {
        
        get {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
    }
    
    /// 最後のIDを取ってくる
    static func lastId() -> Int {
        let realm = try! Realm()
        // 投稿のうち最新のもののidを取ってくる
        if let latestPost = realm.objects(Post.self).last {
            return latestPost.id + 1
        } else {
            return 1
        }
    }
    
    /// 新しい投稿を作る
    static func create() -> Post {
        // インスタンス化
        let post = Post()
        // lastId()を使ってidを設定
        post.id = lastId()
        return post
    }
    
    /// 自分自身を保存する
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    /// PrimaryKey
    override static func primaryKey() -> String? {
        return "id"
    }
}

/// データの読み込み用
/// structを使うとイニシャライザを自分で書かなくてよくなり少し便利
struct PostData {
    var text: String
    var name: String
    var imagePath: URL?
    var dateString: String
    var userId: String
}
