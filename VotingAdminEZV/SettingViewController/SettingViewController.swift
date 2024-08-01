//
//  SettingViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 29/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var contentBackView: UIView!
    //Voting Count
    
    @IBOutlet weak var votingCountLabel: UILabel!
    @IBOutlet weak var votingCountUpButton: UIButton!
    @IBOutlet weak var votingCountDownButton: UIButton!
    
    //결과보기
    @IBOutlet weak var votingResultOptionSegmentedControl: UISegmentedControl!
    
    //Lecture 삭제시 물어보기
    @IBOutlet weak var lectureDeleteCheckOptionSwitch: UISwitch!
    
    //Voting 삭제시 물어보기
    @IBOutlet weak var votingDeleteCheckOptionSwitch: UISwitch!
    
    //Question 삭제시 물어보기
    @IBOutlet weak var questionDeleteCheckOptionSwitch: UISwitch!
    
    //QnA 정렬 옵션
    @IBOutlet weak var qnaViewAligmentOptionSegmentedControl: UISegmentedControl!
    
    //보팅 카운트 업/다운
    @IBOutlet weak var votingCountOptionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var sendStateOptionSwitch: UISwitch!
    
    //Voting 미리보기에서 정답 미리보기
    @IBOutlet weak var showCorrectNumberFromVotingPreviewSwitch: UISwitch!
    
    
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
        super.viewSafeAreaInsetsDidChange()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.votingCountLabel.backgroundColor = UIColor.clear
        
        self.votingCountUpButton.layer.borderColor = self.votingCountUpButton.tintColor.cgColor
        self.votingCountUpButton.layer.borderWidth = 0.5
        self.votingCountUpButton.backgroundColor = UIColor.clear
        
        self.votingCountDownButton.layer.borderColor = self.votingCountUpButton.tintColor.cgColor
        self.votingCountDownButton.layer.borderWidth = 0.5
        self.votingCountDownButton.backgroundColor = UIColor.clear
        
        self.votingCountLabel.text = "\(VOTING_COUNT)"
        
        
        let resultOption = VOTING_RESULT_OPTION.rawValue
        if resultOption <= 2 {
            self.votingResultOptionSegmentedControl.selectedSegmentIndex = resultOption
        }else{
            self.votingResultOptionSegmentedControl.selectedSegmentIndex = 2
        }
        
        self.lectureDeleteCheckOptionSwitch.isOn = LECTURE_DELETE_OPTION
        self.votingDeleteCheckOptionSwitch.isOn = VOTING_DELETE_OPTION
        self.questionDeleteCheckOptionSwitch.isOn = QUESTION_DELETE_OPTION
        self.sendStateOptionSwitch.isOn = SEND_STATE_OPTION
        self.showCorrectNumberFromVotingPreviewSwitch.isOn = IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION
        
        
        let questionViewAligmentOption = QUESTION_VIEW_ALIGEMENT_OPTION.rawValue
        if questionViewAligmentOption <= 1 {
            self.qnaViewAligmentOptionSegmentedControl.selectedSegmentIndex = questionViewAligmentOption
        }else{
            self.qnaViewAligmentOptionSegmentedControl.selectedSegmentIndex = 1
        }
        
        let votingCountOption = VOTING_COUNT_OPTION.rawValue
        if votingCountOption <= 1 {
            self.votingCountOptionSegmentedControl.selectedSegmentIndex = votingCountOption
        }else{
            self.votingCountOptionSegmentedControl.selectedSegmentIndex = 0
        }
        
        if #available(iOS 13.0, *) {
            contentBackView.frame.origin.x = 12.5
        }
    }
    
    @IBAction func votingResultOptionSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        VOTING_RESULT_OPTION = votingResultOption(rawValue: sender.selectedSegmentIndex) ?? .none
    }
    @IBAction func votingCountUpButtonPressed(_ sender: UIButton) {
        let value = self.votingCountLabel.text?.toInt() ?? 5
        let nextValue = value + 1
        
        VOTING_COUNT = nextValue
        self.votingCountLabel.text = "\(VOTING_COUNT)"
    }
    
    @IBAction func votingCountDownButtonPressed(_ sender: UIButton) {
        let value = self.votingCountLabel.text?.toInt() ?? 5
        let nextValue = max(value - 1, 0)
        
        VOTING_COUNT = nextValue
        self.votingCountLabel.text = "\(VOTING_COUNT)"
        
    }
    
    @IBAction func showCorrectNumberFromVotingPreviewSwitchValueChanged(_ sender: UISwitch){
        IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION = sender.isOn
    }
 
    @IBAction func lectureDeleteCheckOptionSwitchValueChanged(_ sender: UISwitch) {
        print("sender.isOn:\(sender.isOn)")
        LECTURE_DELETE_OPTION = sender.isOn
    }
    
    
    @IBAction func votingDeleteCheckOptionSwitchValueChanged(_ sender: UISwitch) {
        VOTING_DELETE_OPTION = sender.isOn
    }
    
    @IBAction func questionDeleteCheckOptionSwitchValueChanged(_ sender: UISwitch) {
        QUESTION_DELETE_OPTION = sender.isOn
    }

    @IBAction func qnaViewAligmentOptionSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        QUESTION_VIEW_ALIGEMENT_OPTION = questionViewAligmentOption(rawValue: sender.selectedSegmentIndex) ?? .center
    }
    
    @IBAction func votingCountOptionSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        VOTING_COUNT_OPTION = votingCountOption(rawValue: sender.selectedSegmentIndex) ?? votingCountOption.increase
    }
    
    @IBAction func sendStateOptionSwitchValueChange(_ sender: UISwitch) {
        SEND_STATE_OPTION = sender.isOn
    }
}
