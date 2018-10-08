//
//  SingupViewController.swift
//  movie
//
//  Created by 二宮啓 on 2018/10/08.
//  Copyright © 2018年 SatoshiNinomiya. All rights reserved.
//

import UIKit
import Firebase//firebaseインポート

class SingupViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
        
        emailTextField.placeholder = "E-mail address"
        passwordTextField.placeholder = "Password"
        
        //self.layoutFacebookButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
    //サインアップボタン
    @IBAction func willSignup() {
        //サインアップのための関数
        signup()
    }
    //ログイン画面への遷移ボタン
    @IBAction func willTransitionToLogin() {
        transitionToLogin()
    }
    
//    @IBAction func willLoginWithFacebook() {
//       self.loginWithFacebook()
//    }
    
    //ログイン画面への遷移
    func transitionToLogin() {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    //ListViewControllerへの遷移
    func transitionToView() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //Signupのためのメソッド
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        //第一引数にEmail、第二引数にパスワード
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] user, error in
            
            guard let self = self else { return }
            
            if let error = error {
                
                // 自分で確認するだけであればerrorをそのままprintするほうが詳しいエラーが見れる
                let alertController = UIAlertController(title: "登録エラー", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                
                // 登録が終わったらログインして元の画面へ
                // 今回はメールのバリデーションは省略
                Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
                    
                    if let error = error {
                        
                        let alertController = UIAlertController(title: "ログインエラー", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        
                        self.performSegue(withIdentifier: "toLogin", sender: self)
                       // self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        })

    }
}
