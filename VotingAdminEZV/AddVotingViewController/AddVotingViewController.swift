//
//  AddVotingViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 29/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class AddVotingViewController: UIViewController, AddVotingComponentViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var questionTextBackView: UIView!
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var addAanswerButton: UIButton!
    
    @IBOutlet weak var answersBackView: UIView!
    
    @IBOutlet weak var shadowBackView: UIView!
    
    @IBOutlet weak var backView: UIView!
    
    var lecture = ""
    
    var addVotingComponentViews = [AddVotingComponentView]()
    
    var votingInfo = [String:Any]()
    var isEdit = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appDel.isAddVoting = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        appDel.isAddVoting = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shadowBackView.layer.cornerRadius = 10
        shadowBackView.layer.shadowColor = UIColor.black.cgColor
        shadowBackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowBackView.layer.shadowRadius = 5
        shadowBackView.layer.shadowOpacity = 0.7
        
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true

        questionTextBackView.layer.cornerRadius = 5
        questionTextBackView.layer.borderWidth = 1
        questionTextBackView.layer.borderColor = UIColor(white: 0.6, alpha: 1).cgColor
        
        questionTextView.backgroundColor = UIColor.clear
        questionTextView.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 20)
        questionTextView.text = ""
        
        answersBackView.layer.cornerRadius = 5
        answersBackView.layer.borderWidth = 1
        answersBackView.layer.borderColor = UIColor(white: 0.6, alpha: 1).cgColor
        answersBackView.clipsToBounds = true
        
        closeButton.backgroundColor = UIColor.clear
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 0.5
        closeButton.layer.borderColor = UIColor.white.cgColor
        
        registerButton.backgroundColor = UIColor.clear
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 0.5
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        addAanswerButton.backgroundColor = deepRedColor
        addAanswerButton.layer.cornerRadius = 5
        addAanswerButton.layer.borderWidth = 0.5
        addAanswerButton.layer.borderColor = UIColor.white.cgColor
        
        if isEdit {
            self.titleLabel.text = "Edit Voting"
            self.questionTextView.text = self.votingInfo["question"] as? String ?? ""
            self.registerButton.setTitle("수정", for: .normal)
            for i in 0..<5 {
                let answer = self.votingInfo["answer\(i+1)"] as? String ?? ""
                if answer != "" {
                    self.addComponent(answer: answer)
                }
            }
        }else{
            self.questionTextView.text = "선택해주세요"
            self.addComponent()
            self.addComponent()
        }
//        self.addComponent()
//        self.addComponent()
//        self.addComponent()
//        self.addComponent()
    }
    
    func addComponent(answer : String = ""){
        if self.addVotingComponentViews.count >= 5 {
            toastShow(message: "보기는 최대 5개까지 가능합니다.")
            return
        }
        
        if let addVotingComponentView = Bundle.main.loadNibNamed("AddVotingComponentView", owner: nil, options: nil)?.first as? AddVotingComponentView {
            addVotingComponentView.frame = CGRect(x: 0, y: CGFloat(self.addVotingComponentViews.count) * 61, width: 630, height: 60)
            addVotingComponentView.indexLabel.text = "\(self.addVotingComponentViews.count + 1)"
            addVotingComponentView.valueTextField.delegate = self
            addVotingComponentView.valueTextField.text = (answer == "") ? "\(self.addVotingComponentViews.count + 1)번" : answer
            addVotingComponentView.delegate = self
            addVotingComponentView.valueTextField.autocapitalizationType = .none
            addVotingComponentView.valueTextField.autocorrectionType = .no
            
            self.answersBackView.addSubview(addVotingComponentView)
            self.addVotingComponentViews.append(addVotingComponentView)
            
        }
        
    }
    
    func componentsRefresh(){
        for i in 0..<self.addVotingComponentViews.count {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.addVotingComponentViews[i].indexLabel.text = "\(i+1)"
                self.addVotingComponentViews[i].frame.origin.y = CGFloat(i) * 61
            }) { (fi) in
                
            }
            
        }
    }

    func addVotingComponentView(_ addVotingComponentView: AddVotingComponentView, deleteButtonPressed deleteButton: UIButton) {
        
        self.view.endEditing(true)
        
        if self.addVotingComponentViews.count <= 2 {
            toastShow(message: "최소 2개 이상의 보기가 필요합니다.")
            return
        }
        
        for i in 0..<self.addVotingComponentViews.count {
            let targetAddVotingComponentView = self.addVotingComponentViews[i]
            if targetAddVotingComponentView == addVotingComponentView {
                self.addVotingComponentViews.remove(at: i)
                UIView.animate(withDuration: 0.3, animations: {
                    targetAddVotingComponentView.frame.origin.x = -20
                    targetAddVotingComponentView.alpha = 0
                }) { (fi) in
                    targetAddVotingComponentView.removeFromSuperview()
                }
                break
            }
        }
        self.componentsRefresh()

    }
    
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let question = self.questionTextView.text ?? ""
        if question == "" {
            toastShow(message: "질문을 입력해주세요.")
            return
        }
        
        if isEdit {
            let question = self.votingInfo["question"] as? String ?? ""
            
            let noAction = UIAlertAction(title: "아니오", style: .default, handler: { (action) in
                
            })
            let yesAction = UIAlertAction(title: "예", style: .destructive, handler: { (action) in
                self.register(message: "수정되었습니다.")
            })
            
            appDel.showAlert(title: "안내", message: "\(question) 보팅을 수정하시겠습니까?", actions: [yesAction,noAction], viewCon: self) {}
            return
        }
        register(message: "등록되었습니다.")
    }
    
    func register(message : String){
        let urlString = VOTING_ADD
        let question = self.questionTextView.text ?? ""

        var para = [
            "code":code,
            "lecture":lecture,
            "question":question,
            "room":"\(room)"
        ]
        for i in 0..<self.addVotingComponentViews.count {
            let key = "answer\(i+1)"
            let value = self.addVotingComponentViews[i].valueTextField.text ?? ""
            para[key] = value
        }
        if isEdit {
            let sid = votingInfo["sid"] as? String ?? ""
            print("sid : \(sid)")
            para["sid"] = sid
        }
        appDel.showHud()
        Server.postData(urlString: urlString, otherInfo: para) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                if let dataString = data.toString() {
                    print("check dataString:\(dataString)")
                    if dataString == "insert" || dataString == "update"{
                        self.dismiss(animated: false, completion: {
                            toastShow(message: message)
                            appDel.votingListVC?.votingListUpdate{
                                appDel.stackedViewController?.pop(to: appDel.votingListVC!, animated: true)
                                appDel.votingListVC?.tableView.isEditing = false
                                appDel.votingListVC?.editButton.setTitle("편집", for: .normal)
                            }
                        })
                    }
                }
            }
            //todo
        }
    }
    
    @IBAction func addAnswerButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.addComponent()
    }
    
    
    

}
