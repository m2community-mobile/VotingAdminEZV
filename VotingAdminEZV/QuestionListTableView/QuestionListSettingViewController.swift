//
//  QuestionListSettingViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 25/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

var lanLabel = UILabel()

class QuestionListSettingViewController: UIViewController {

    @IBOutlet weak var contentBackView: UIView!
    
    @IBOutlet weak var showLectureLabelSwitch: UISwitch!
    @IBOutlet weak var lectureTextField: UITextField!
    
    @IBOutlet weak var lectureTextConfirmButton: UIButton!
    
    @IBOutlet weak var showSelectButtonSwitch: UISwitch!
    
    @IBOutlet weak var questionSelectCheckOptionSwitch: UISwitch!
    
    @IBOutlet weak var questionSelectHideOptionSwitch: UISwitch!
    
    
    @IBOutlet weak var titleChangedLabel: UILabel!
    @IBOutlet weak var showAndHideSwitch: UISwitch!
    
    var button : UIButton! = nil
    
    var isChecked = true
    
//    QUESTION_SELECT_HIDE_OPTION
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if UserDefaults.standard.string(forKey: "chair") == "chair" {
            button = UIButton(frame: CGRect(x: titleChangedLabel.frame.minX, y: 200, width: titleChangedLabel.frame.size.width, height: titleChangedLabel.frame.size.height))
            
            button.setTitle(language.text, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = .systemFont(ofSize: 17)
            
            self.view.addSubview(button)
            
            button.addTarget(self, action: #selector(languageChanged(_ :)), for: .touchUpInside)
            
            titleChangedLabel.text = ""
            button.setTitle("한국어", for: .normal)
            showAndHideSwitch.isHidden = true
            
        }
        if UserDefaults.standard.string(forKey: "phil") == "phil" {
            titleChangedLabel.text = "질문선택 표시"
            showAndHideSwitch.isHidden = false
            
        }
        
        
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.lectureTextConfirmButton.backgroundColor = self.lectureTextConfirmButton.tintColor
        self.lectureTextConfirmButton.setTitleColor(UIColor.white, for: .normal)
        self.lectureTextConfirmButton.layer.cornerRadius = 5
        
        self.showLectureLabelSwitch.isOn = SHOW_LECTURE_LABEL
        self.lectureTextField.text = LECTURE_LABEL_STRING
        self.showSelectButtonSwitch.isOn = SHOW_QUESTION_SELECT_BUTTON
        self.questionSelectCheckOptionSwitch.isOn = QUESTION_SELECT_OPTION
        self.questionSelectHideOptionSwitch.isOn = QUESTION_SELECT_HIDE_OPTION
            
        self.lectureTextField.autocapitalizationType = .none
        self.lectureTextField.autocorrectionType = .no
        
        if #available(iOS 13.0, *) {
            contentBackView.frame.origin.y = 12.5
        }
        
        
        
    }

    @IBAction func lectureLabelSwitchValueChange(_ sender: UISwitch) {
        SHOW_LECTURE_LABEL = sender.isOn
    }
    
    @IBAction func showSelectButtonSwitchValueChange(_ sender: UISwitch) {
        SHOW_QUESTION_SELECT_BUTTON = sender.isOn
    }
    
    @IBAction func lectureTextConfirmButtonPressed(_ sender: UIButton) {
        LECTURE_LABEL_STRING = self.lectureTextField.text!
        
        lectureTextField.resignFirstResponder()
        toastShow(message: "적용되었습니다.")
    }
    
    
    @IBAction func questionSelectCheckOptionSwitchValueChanged(_ sender: UISwitch) {
        QUESTION_SELECT_OPTION = sender.isOn
    }
    @IBAction func questionSelectHideOptionSwitchValueChanged(_ sender: UISwitch) {
        QUESTION_SELECT_HIDE_OPTION = sender.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("QuestionListSettingViewController viewWillAppear")
        
        
        if UserDefaults.standard.string(forKey: "chair") == "chair" {
            
            if lanLabel.text == nil {
                button.setTitle("언어선택", for: .normal)
            } else {
                button.setTitle(lanLabel.text, for: .normal)
            }
            appDel.isQuestionSetting = true
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("QuestionListSettingViewController viewDidDisappear")
        
        
        titleChangedLabel.text = ""
        
       
        
        appDel.isQuestionSetting = false
        appDel.questionListVC?.tableView.reloadData()
        appDel.chairVC?.tableView.reloadData()
        appDel.chairVC?.questionSelectHideOptionUpdate()
        appDel.questionListVC?.initializeButton.isHidden = !SHOW_QUESTION_SELECT_BUTTON
        
        
        
        
        
        appDel.questionListVC?.isEditing = false
        
        
        
        
    
        
        
        
    }
    
    @objc func languageChanged(_ : UIButton) {
        
        isChecked = !isChecked
        
        if (button != nil) == isChecked {
            titleChangedLabel.text = ""
            button.setTitle("한국어", for: .normal)
            UserDefaults.standard.set(button.titleLabel?.text, forKey: "ko")
            
            lanLabel.text = UserDefaults.standard.string(forKey: "ko")
            
            NotificationCenter.default.post(name: NSNotification.Name("change"), object: nil, userInfo: nil)
        } else {
            titleChangedLabel.text = ""
            button.setTitle("English", for: .normal)
            UserDefaults.standard.set(button.titleLabel?.text, forKey: "en")
            
            lanLabel.text = UserDefaults.standard.string(forKey: "en")
            
            NotificationCenter.default.post(name: NSNotification.Name("change"), object: nil, userInfo: nil)
            
            
            var tableVC = ChairTableViewCell()
            
            tableVC.selectButtonLabel?.text = (selecLabel.text)!
            
        }
    }
}
