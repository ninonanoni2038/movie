//
//  ViewController.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/03.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import UIKit
import PinterestLayout

class ViewController: PinterestVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let text = "Some text. Some text. Some text. Some text."
        
        items = [
            PinterestItem(image: UIImage(named: "apple1 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple2 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple3 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple4 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple5 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple1 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple2 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple3 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple4 2.jpeg")!, text: text),
            PinterestItem(image: UIImage(named: "apple5 2.jpeg")!, text: text)
        ]
    }


}

