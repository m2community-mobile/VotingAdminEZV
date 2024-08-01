//
//  AddLectureViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 26/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class AddLectureViewController: UIViewController {

    @IBOutlet weak var backShadowView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var lectureTestField: UITextField!
    
    @IBOutlet weak var textFieldBackView: UIView!
    
    weak var lecutreListVC : LecutreListViewController?
    
    var isEdit = false
    var sid = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEdit {
            self.titleLabel.text = "Edit Lecture"
            self.lectureTestField.text = name
            self.registerButton.setTitle("수정", for: .normal)
        }
        
        self.backShadowView.layer.cornerRadius = 10
        self.backShadowView.layer.shadowColor = UIColor.black.cgColor
        self.backShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.backShadowView.layer.shadowRadius = 5
        self.backShadowView.layer.shadowOpacity = 0.7
        
        self.backView.layer.cornerRadius = 10
        self.backView.clipsToBounds = true

        textFieldBackView.layer.cornerRadius = 5
        textFieldBackView.layer.borderWidth = 1
        textFieldBackView.layer.borderColor = UIColor(white: 0.6, alpha: 1).cgColor
        
        lectureTestField.delegate = self
        lectureTestField.frame = textFieldBackView.bounds
        lectureTestField.frame.size.width -= 20
        lectureTestField.center = textFieldBackView.frame.center
        lectureTestField.autocapitalizationType = .none
        lectureTestField.autocorrectionType = .no
        
        lectureTestField.attributedPlaceholder =  NSMutableAttributedString(string: "Lecture Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 1),NSAttributedString.Key.font:UIFont(name: Nanum_Barun_Gothic_OTF, size: lectureTestField.frame.size.height * 0.4)!])
        lectureTestField.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: lectureTestField.frame.size.height * 0.4)
        
        
        self.closeButton.backgroundColor = UIColor.clear
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.layer.borderWidth = 0.5
        self.closeButton.layer.borderColor = UIColor.white.cgColor
        
        self.registerButton.backgroundColor = UIColor.clear
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.layer.borderWidth = 0.5
        self.registerButton.layer.borderColor = UIColor.white.cgColor
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDel.isAddLecture = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDel.isAddLecture = false
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
//        print("registerButtonPressed")
        if self.lectureTestField.text?.replacingOccurrences(of: " ", with: "") == "" {
//            print("강의제목을 입력하세요:\(self.lectureTestField.text)")
            appDel.showAlert(title: "안내", message: "강의제목을 입력하세요", actions: [UIAlertAction(title: "확인", style: .cancel, handler: { (action : UIAlertAction) in })])
            return
        }
        
        let urlString = LECTURE_POST
        var para = [
            "code":code,
            "name":self.lectureTestField.text!,
            "room":"\(room)"
        ]
        if isEdit {
            para["sid"] = self.sid
        }
        appDel.showHud()
        Server.postData(urlString: urlString, otherInfo: para) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                if let dataString = data.toString() {
                    print("dataString:\(dataString)")
                    if dataString == "insert" {
                        self.dismiss(animated: false, completion: {
                            self.lecutreListVC?.refresh()
                            appDel.showAlert(title: "안내", message: "\(self.lectureTestField.text!) 강의가 추가되었습니다.", viewCon: self.lecutreListVC)
                        })
                        return
                    }
                    if dataString == "update" {
                        self.dismiss(animated: false, completion: {
                            self.lecutreListVC?.refresh()
                            appDel.showAlert(title: "안내", message: "\(self.lectureTestField.text!) 강의로 수정되었습니다.", viewCon: self.lecutreListVC)
                        })
                    }
                }
            }
            
        }
    }
    

}
