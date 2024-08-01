//
//  VotingViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 29/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class VotingViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerBackView: UIView!
    
    @IBOutlet weak var votingButtonBackImageView: UIImageView!
    
    @IBOutlet weak var votingButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var beforeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var quiz_startImageView: UIImageView!
    @IBOutlet weak var quiz_endImageView: UIImageView!
    @IBOutlet weak var buttonBottomLabel: UILabel!
    
    
    var answerBackView2: UIView!
    
    var votingInfos = [[String:Any]]()
    var votingIndex = 0
    var votingInfo = [String:Any]()
    
    var results = [Int]()
    
    var answerComponentViews = [AnswerComponentView]()
    
    var isStartVoting = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.votingInfo = self.votingInfos[self.votingIndex]
        
        print("votingInfo:\(votingInfo.showValue())")
        
        quiz_startImageView.isUserInteractionEnabled = false
        quiz_startImageView.isHidden = false
        
        quiz_endImageView.isUserInteractionEnabled = false
        quiz_endImageView.isHidden = true
        
        
        buttonBottomLabel.isUserInteractionEnabled = false
        buttonBottomLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 90)
        buttonBottomLabel.isHidden = false
        
        self.questionLabel.backgroundColor = UIColor.clear
        self.questionLabel.adjustsFontSizeToFitWidth = true //?/
        
        self.votingButton.layer.cornerRadius = 5
        
        self.votingButton.setTitleColor(#colorLiteral(red: 1, green: 0.9215686275, blue: 0, alpha: 1), for: .normal)
        
        self.answerBackView.backgroundColor = UIColor.clear
        
        beforeButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        beforeButton.layer.cornerRadius = 5
        beforeButton.backgroundColor = UIColor.clear
        beforeButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        beforeButton.layer.borderWidth = 0.5
        
        refreshButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        refreshButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .highlighted)
        refreshButton.layer.cornerRadius = 5
        refreshButton.backgroundColor = UIColor.clear
        refreshButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        refreshButton.layer.borderWidth = 0.5
        
        nextButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        nextButton.layer.cornerRadius = 5
        nextButton.backgroundColor = UIColor.clear
        nextButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        nextButton.layer.borderWidth = 0.5
        
        let beforeIndex = self.votingIndex - 1
        self.beforeButton.isHidden = beforeIndex < 0
        
        let nextIndex = self.votingIndex + 1
        self.nextButton.isHidden = self.votingInfos.count <= nextIndex
        
        
        var votingButtonColors = [UIColor]()
        for i in 0..<5 {
            votingButtonColors.append(deepRedColor.removeBrightness(val: 0.05 * CGFloat(i)))
        }
        votingButtonBackImageView.setGradientColorImage(colors: votingButtonColors)
        votingButtonBackImageView.image = UIImage(named: "quiz_startBG")
        votingButtonBackImageView.contentMode = .scaleToFill
//        votingButtonBackImageView.layer.cornerRadius = 10
        votingButtonBackImageView.clipsToBounds = true
        
        votingButton.layer.cornerRadius = 10
        
        votingButton.rx.tap.debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).bind(onNext: { [weak self] (_)  in
            guard let self = self else { return }
            print("votingButtonPressed")
            self.votingButtonPressed(self.votingButton)
        }).disposed(by: disposeBag)
            
        
        self.answerBackView2 = UIView(frame: self.answerBackView.bounds)
        self.answerBackView2.frame.size.height -= 20
        self.answerBackView2.center = self.answerBackView.frame.center
        self.answerBackView.addSubview(self.answerBackView2)
        
        if let question = votingInfo["question"] as? String {
            self.questionLabel.text = question
        }
        
        let answers = self.mappingAnswer(infoDic: self.votingInfo)
        self.makeAnswerComponent(answers: answers)
        
        votingStatusApply()
    }
    
    func reload(){
        self.votingInfo = self.votingInfos[self.votingIndex]
        
        let beforeIndex = self.votingIndex - 1
        self.beforeButton.isHidden = beforeIndex < 0
        
        let nextIndex = self.votingIndex + 1
        self.nextButton.isHidden = self.votingInfos.count <= nextIndex
        
        if let question = votingInfo["question"] as? String {
            self.questionLabel.text = question
        }
        
        self.results = [Int]()
        
        let answers = self.mappingAnswer(infoDic: self.votingInfo)
        self.makeAnswerComponent(answers: answers)
        
        votingStatusApply()
    }
    
    func votingStatusApply(){
        if let status = votingInfo["status"] as? String {
            if status == "0" { //보팅 전
                votingButtonBackImageView.isHidden = false
                votingButton.isHidden = false
                self.votingButton.setTitle("Voting", for: .normal)
                self.votingButton.setTitleColor(UIColor.clear, for: .normal)
                self.votingButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 80)
                self.votingButtonBackImageView.image = UIImage(named: "quiz_startBG")
                self.quiz_startImageView.isHidden = false
                self.buttonBottomLabel.isHidden = false
                self.buttonBottomLabel.text = "Start"
            }else{
                //보팅 후
                votingButtonBackImageView.isHidden = true
                votingButton.isHidden = true
                buttonBottomLabel.isHidden = true
                quiz_endImageView.isHidden = true
                votingButtonBackImageView.image = UIImage(named: "quiz_endBG")
                quiz_startImageView.isHidden = true //?/ 2020.07.02 추가

                
                //결과 가공
                let result = self.votingInfo["result"] as? [String:Any] ?? [String:Any]()
                for i in 0..<6{
                    let key = "value\(i+1)"
                    let valueString = result[key] as? String ?? ""
                    let value = valueString.toInt() ?? 0
                    self.results.append(value)
                }
                if let otherResults = self.votingInfo["results"] as? [Int] {
                    self.results = otherResults
                }
                
                //결과 보여주기
                showResult{
                    self.votingButton.setTitle("", for: .normal)
                    self.votingButton.isHidden = true
                    self.votingButtonBackImageView.isHidden = true
                    self.buttonBottomLabel.isHidden = true
                    self.quiz_endImageView.isHidden = true
                }
                
            }
            
        }
        
    }
    
    func mappingAnswer(infoDic:[String:Any]) -> [[String:Any]] {
        
        //        print("===============mappingAnswer:\(infoDic.showValue())")
        
        var answers = [[String:Any]]()
        
        for i in 0..<10{
            let key = "answer\(i + 1)"
            if let answer = infoDic[key] as? String, answer != "" {
                var answerDic = [String:Any]()
                answerDic["answer"] = answer
                answers.append(answerDic)
            }
        }
        
        return answers
    }
    
    var answerComponentViewBackViews = [UIView]()
    func makeAnswerComponent(answers : [[String:Any]]){
        
        for i in 0..<self.answerComponentViews.count {
            self.answerComponentViews[i].removeFromSuperview()
        }
        self.answerComponentViews.removeAll()
        
        for i in 0..<self.answerComponentViewBackViews.count {
            self.answerComponentViewBackViews[i].removeFromSuperview()
        }
        self.answerComponentViewBackViews.removeAll()
        
        for i in 0..<answers.count{
            
            guard let answer = answers[i]["answer"] as? String else { return }
            
            let answerComponentViewHeight : CGFloat = answerBackView2.frame.size.height / CGFloat(answers.count)
            let answerComponentViewY : CGFloat = CGFloat(i) * answerComponentViewHeight
            
            let answerComponentViewBackView = UIView(frame: CGRect(
                x: 0,
                y: answerComponentViewY,
                width: answerBackView2.frame.size.width,
                height: answerComponentViewHeight))
            answerBackView2.addSubview(answerComponentViewBackView)
            
            var answerComponentViewFrame = answerComponentViewBackView.bounds
            answerComponentViewFrame.size.height = min(90, answerComponentViewFrame.size.height * 0.7)
            
            let answerComponentView = AnswerComponentView(frame: answerComponentViewFrame)
            answerComponentView.center = answerComponentViewBackView.frame.center
            answerComponentView.answerLabel.text = answer
            answerComponentView.indexLabel.text = "\(i+1)"
            answerComponentViewBackView.addSubview(answerComponentView)
            
            self.answerComponentViewBackViews.append(answerComponentViewBackView)
            self.answerComponentViews.append(answerComponentView)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        appDel.isVotingViewShow = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appDel.isVotingViewShow = true
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if isStartVoting { self.votingEnd {}}
        self.dismiss(animated: false) {
            appDel.votingListVC?.votingListUpdate {
                appDel.votingListVC?.tableView(appDel.votingListVC!.tableView, didSelectRowAt: IndexPath(row: self.votingIndex, section: 0))
            }
        }
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        self.refresh {
            self.showResult(fromZero: false) {}
        }
    }
    @IBAction func beforeButtonPressed(_ sender: UIButton) {
        
        self.votingCountDownTimer?.invalidate()

        if isStartVoting {
            self.votingEnd {
                self.isStartVoting = false
                
                let nextIndex = self.votingIndex - 1
                if nextIndex >= 0 {
                    self.votingIndex = nextIndex
                    self.reload()
                }
                return
            }
        }else{
            isStartVoting = false
            
            let nextIndex = self.votingIndex - 1
            if nextIndex >= 0 {
                self.votingIndex = nextIndex
                self.reload()
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.votingCountDownTimer?.invalidate()
        
        if isStartVoting {
            self.votingEnd {
                self.isStartVoting = false
                
                let nextIndex = self.votingIndex + 1
                if nextIndex < self.votingInfos.count {
                    self.votingIndex = nextIndex
                    self.reload()
                }
                return
            }
            
        }else{
            isStartVoting = false
            
            let nextIndex = self.votingIndex + 1
            if nextIndex < self.votingInfos.count {
                self.votingIndex = nextIndex
                self.reload()
            }
        }
    }
    
    @IBAction func votingButtonPressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Voting" {
            votingStart()
            return
        }
        if sender.titleLabel?.text == "End" {
            votingEnd{
                self.showResult{
                    self.votingButton.setTitle("", for: .normal)
                    self.votingButton.isHidden = true
                    self.votingButtonBackImageView.isHidden = true
                    self.quiz_endImageView.isHidden = true
                    self.buttonBottomLabel.isHidden = true
                }
            }
            return
        }
        if sender.titleLabel?.text == "결과보기" {
            showResult{}
            return
        }
        
    }
    
    func refresh(complete:@escaping()->Void){
        if let sid = votingInfo["sid"] as? String {
            let urlString = "\(VOTING_RESULT)?sid=\(sid)&room=\(room)"
            Server.postData(urlString: urlString) { (kData : Data?) in
                if let data = kData {
                    if let dataString = data.toString() {
                        print("dataString:\(dataString)")
                        
                        let dataArray = dataString.components(separatedBy: "||")
                        self.results = dataArray.map({ (valueString : String) -> Int in
                            if let intValue = valueString.toInt() {
                                return intValue
                            }else{
                                return 0
                            }
                        })
                        
                        print("self.results\(self.results)")
                        
                        DispatchQueue.main.async {
                            complete()
                            //                        self.votingButton.setTitle("결과보기", for: .normal)
                        }
                    }
                }
                
            }
        }
    }
    
    
    func votingStart(){
        if let sid = votingInfo["sid"] as? String {
            let urlString = "\(VOTING_START)?code=\(code)&sid=\(sid)&room=\(room)"
            print("urlString:\(urlString)")
            Server.postData(urlString: urlString) { (kData : Data?) in
                if let data = kData {
                    if let dataString = data.toString() {
                        print("dataString:\(dataString)")
                        
                        if dataString == "Y" {
                            
                            self.isStartVoting = true
                            
                            if VOTING_COUNT == 0 {
                                DispatchQueue.main.async {
                                    self.votingButton.setTitle("End", for: .normal)
                                    self.votingButton.setTitleColor(UIColor.clear, for: .normal)
                                    self.votingButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 80)
                                    self.quiz_endImageView.isHidden = false
                                }
                            }else{
                                self.currentVotingCount = VOTING_COUNT
                                DispatchQueue.main.async {
//                                    self.votingButton.setTitle("\(VOTING_COUNT)", for: .normal)
                                    if VOTING_COUNT_OPTION == .increase {
                                        self.votingButton.setTitle("0", for: .normal)
                                    }else{
                                        self.votingButton.setTitle("\(VOTING_COUNT)", for: .normal)
                                    }
                                    self.votingButton.setTitleColor(#colorLiteral(red: 1, green: 0.9215686275, blue: 0, alpha: 1), for: .normal)
                                    self.votingButtonBackImageView.image = UIImage(named: "quiz_count_bg")
                                    self.votingButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 200)
                                    self.quiz_startImageView.isHidden = true
                                    self.buttonBottomLabel.isHidden = true
                                    self.quiz_endImageView.isHidden = true
                                }
                                if self.currentVotingCount > 0 {
                                    SoundCenter.shared.playSound()
                                }
                                self.votingCountDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.votingCountDownTimerFunc), userInfo: nil, repeats: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    var currentVotingCount = 0
    var votingCountDownTimer : Timer?
    @objc func votingCountDownTimerFunc(){
        if currentVotingCount <= 0 {
            self.votingButton.setTitle("End", for: .normal)
            self.votingButton.setTitleColor(UIColor.clear, for: .normal)
            self.votingButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 80)
            self.buttonBottomLabel.isHidden = false
            self.buttonBottomLabel.text = "Voting"
            self.quiz_endImageView.isHidden = false
            votingButtonBackImageView.image = UIImage(named: "quiz_endBG")
            votingCountDownTimer?.invalidate()
            
        }else{
            SoundCenter.shared.playSound()
            currentVotingCount -= 1
            if VOTING_COUNT_OPTION == .increase {
                self.votingButton.setTitle("\(VOTING_COUNT - currentVotingCount)", for: .normal)
            }else{
                self.votingButton.setTitle("\(currentVotingCount)", for: .normal)
            }
            self.quiz_startImageView.isHidden = true
            self.quiz_endImageView.isHidden = true
            self.buttonBottomLabel.isHidden = true
            self.votingButtonBackImageView.image = UIImage(named: "quiz_count_bg")
            self.votingButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 200)
        }
    }
    
    func votingEnd(complete:@escaping()->Void){
        if let sid = votingInfo["sid"] as? String {
            
            let urlString = "\(VOTING_END)?code=\(code)&sid=\(sid)&room=\(room)"
            
            Server.postData(urlString: urlString) { (kData : Data?) in
                if let data = kData {
                    if let dataString = data.toString() {
                        print("dataString:\(dataString)")
                        
                        let dataArray = dataString.components(separatedBy: "||")
                        self.results = dataArray.map({ (valueString : String) -> Int in
                            if let intValue = valueString.toInt() {
                                return intValue
                            }else{
                                return 0
                            }
                        })
                        
                        print("self.results\(self.results)")
                        self.votingInfos[self.votingIndex]["status"] = "2"
                        self.votingInfos[self.votingIndex]["results"] = self.results
                        
                        
                        DispatchQueue.main.async {
                            complete()
                            //                        self.votingButton.setTitle("결과보기", for: .normal)
                        }
                    }
                }
                
            }
        }
    }
    
    func showResult(fromZero : Bool = true, complete:@escaping()->Void){
        
        let count = min(self.answerComponentViews.count, self.results.count)
        let sum = Array(0..<count).reduce(0) { (result : Int, value : Int) -> Int in
            return result + self.results[value]
        }
        
        var maxValue = 0
        for i in 0..<count {
            if maxValue < self.results[i] {
                maxValue = self.results[i]
            }
        }
        
        
        for i in 0..<count {
            let value = (sum == 0) ? 0 : CGFloat(self.results[i]) / CGFloat(sum)
            self.answerComponentViews[i].resultBar.backgroundColor = (self.results[i] == maxValue) ? self.answerComponentViews[i].highValueBarColor : self.answerComponentViews[i].nomalValueBarColor
            self.answerComponentViews[i].resultUpdate(value: value, withAnimation: true, fromZero: fromZero)
            
//            if let status = self.votingInfo["status"] as? String, status != "0" {
                if VOTING_RESULT_OPTION == .number {
                    let optionString = "\(self.results[i]) / \(sum)"
                    self.answerComponentViews[i].optionLabel.text = optionString
                }else if VOTING_RESULT_OPTION == .percent {
                    let optionString = "\(Int(value * 100))%"
                    self.answerComponentViews[i].optionLabel.text = optionString
                }
//            }
            
            
        }
        complete()
        
    }
    
    
    
}



