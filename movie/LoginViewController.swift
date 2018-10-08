//
//  LoginViewController.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/08.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry  = true // 文字を非表示に
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
    //ログインのためのメソッド
    func login() {
        //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //signInWithEmailでログイン
        //第一引数にEmail、第二引数にパスワードを取ります
        // ログインして元の画面へ
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] user, error in
            
            guard let self = self else { return }
            
            if let error = error {
                
                let alertController = UIAlertController(title: "ログインエラー", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.transitionToView()
                //self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    //ログインボタン
    @IBAction func loginbutton() {
        //ログインのためのメソッド
        login()
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        self.performSegue(withIdentifier: "toVC", sender: self)
    }
}

