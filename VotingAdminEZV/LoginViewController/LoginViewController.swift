//
//  LoginViewController.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var codeBackView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var roomBackView: UIView!
    @IBOutlet weak var roomTextField: UITextField!
    
    @IBOutlet weak var idBackView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pwBackView: UIView!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var selectButtonBackView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backViewCornerRadius : CGFloat = 5
        codeBackView.layer.cornerRadius = backViewCornerRadius
        roomBackView.layer.cornerRadius = backViewCornerRadius
        idBackView.layer.cornerRadius = backViewCornerRadius
        pwBackView.layer.cornerRadius = backViewCornerRadius
        loginButton.layer.cornerRadius = backViewCornerRadius
        selectButtonBackView.layer.cornerRadius = backViewCornerRadius
        selectButtonBackView.clipsToBounds = true
//        codeTextField.placeholder = "코드를 입력하세요."
//        roomTextField.placeholder = "룸을 입력하세요."
//        idTextField.placeholder = "아이디를 입력하세요."
//        pwTextField.placeholder = "비밀번호를 입력하세요."
        
        [codeTextField,roomTextField,idTextField,pwTextField].forEach{
            $0?.autocapitalizationType = .none
            $0?.autocorrectionType = .no
        }
        
        loginButton.backgroundColor = UIColor.systemRed
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 20)
        loginButton.setTitle("Login", for: .normal)
        
        codeTextField.delegate = self
        roomTextField.delegate = self
        idTextField.delegate = self
        pwTextField.delegate = self
        
        codeTextField.text = code
        roomTextField.text = room
        idTextField.text = id
        pwTextField.text = pw
        
        pwTextField.isSecureTextEntry = true
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("here")
        
        UserDefaults.standard.removeObject(forKey: "chair")
        UserDefaults.standard.removeObject(forKey: "phil")
        
        
//        self.pwTextField.text = ""
        self.view.endEditing(true)
        
    }
    
    //MARK:
    @IBAction func selectButtonPressed(_ sender: UIButton) {
        
        self.urlListUpdate {
            let alertCon = UIAlertController(title: "행사 선택", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            for i in 0..<self.urlList.count {
                let dataDic = self.urlList[i]
                let name = dataDic["name"] as? String ?? ""
                
                alertCon.addAction(UIAlertAction(title: name, style: UIAlertAction.Style.default, handler: { (action) in
                    self.menuButtonDidSelected(index: i)
                }))
            }
            alertCon.modalPresentationStyle = .popover
            alertCon.preferredContentSize = CGSize(width: 300, height: 100 * CGFloat(self.urlList.count))
            let presentVC = alertCon.presentationController as! UIPopoverPresentationController
            presentVC.sourceView = sender
            presentVC.sourceRect = sender.bounds
            presentVC.permittedArrowDirections = [.up, .right]
            DispatchQueue.main.async {
                self.present(alertCon, animated: true) {}
            }
            
        }
    }
    
    var urlList = [[String:Any]]()
    func urlListUpdate( complete:@escaping() -> Void ){
        print("urlListUpdate")
        
        let listUrlString = "http://ezv.kr/s/voting_url_list.php"
        
    
        appDel.showHud()
        Server.postData(urlString: listUrlString) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                if let dataArray = data.toJson() as? [[String:Any]] {
                    self.urlList = dataArray
                    
                    complete()
                    
                    
                }
                
            }
        }
        
    }
    
    func menuButtonDidSelected(index : Int){
        print("menuButtonDidSelected:\(index)")
        if index < self.urlList.count {
            let dataDic = self.urlList[index]
            print("dataDic : \(dataDic)")
            
            if let url = dataDic["url"] as? String {
                appDel.rootURL = url
            }
            
            let name = dataDic["name"] as? String ?? ""
            appDel.rootName = name
            self.selectButton.setTitle(name, for: .normal)
            
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
//        PSStackedViewDelegate
        
        self.view.endEditing(true)
        
        if let codeString = codeTextField.text,
            let roomString = roomTextField.text,
            let idString = idTextField.text,
            let pwString = pwTextField.text{
            
            if pwString != "1234" { UIAlertController.showAlert(title: "안내", message: "아이디 혹은 비밀번호를 확인하세요."); return}
            
            if idString == "phil" {
                code = codeString
                room = roomString
                id = idString
                pw = pwString
        
                UserDefaults.standard.set(idTextField.text, forKey: "phil")
                
                let stackedViewController = PSStackedViewController(rootViewController: MainViewController())
                stackedViewController?.leftInset = 80
                stackedViewController?.largeLeftInset = 80
                appDel.stackedViewController = stackedViewController
                self.navigationController?.pushViewController(stackedViewController!, animated: true)
                return
            }
            if idString == "chair" {
                code = codeString
                room = roomString
                id = idString
                pw = pwString
                
                UserDefaults.standard.set(idTextField.text, forKey: "chair")
                
                
                let chairVC = ChairViewController()
                self.navigationController?.pushViewController(chairVC, animated: true)
                return
            }
            UIAlertController.showAlert(title: "안내", message: "아이디 혹은 비밀번호를 확인하세요.");
        }
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        print("textFieldShouldReturn")
        if textField == self.codeTextField {
            self.roomTextField.becomeFirstResponder()
            return true
        }
        if textField == self.roomTextField {
            self.idTextField.becomeFirstResponder()
            return true
        }
        if textField == self.idTextField {
            self.pwTextField.becomeFirstResponder()
            return true
        }
        if textField == self.pwTextField {
            self.loginButtonPressed(self.loginButton)
            return true
        }
        return true
    }
    
    

}

extension LoginViewController : PSStackedViewDelegate {
    
}
