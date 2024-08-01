//
//  VotingPreviewViewController.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit



class VotingPreviewViewController: UIViewController {

    weak var votingListVC : VotingListViewController?
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var answersBackView: UIView!
    
    var answersBackView2 : UIView!
    
    var answerComponentViews = [AnswerComponentView]()
    
    var votingInfos = [[String:Any]]()
    var votingIndex = 0
    var votingInfo = [String:Any]()
    
    var lectureSid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.votingInfo = self.votingInfos[self.votingIndex]
        
        appDel.votingPreviewVC = self
        
        editButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        editButton.layer.cornerRadius = 5
        editButton.backgroundColor = UIColor.clear
        editButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        editButton.layer.borderWidth = 0.5
        
        resetButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        resetButton.layer.cornerRadius = 5
        resetButton.backgroundColor = UIColor.clear
        resetButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        resetButton.layer.borderWidth = 0.5
        resetButton.isHidden = true
        
        self.startButton.backgroundColor = UIColor.clear
        var startButtonColors = [UIColor]()
        for i in 0..<5 {
            startButtonColors.append(deepRedColor.removeBrightness(val: 0.05 * CGFloat(i)))
        }
        self.startButton.setGradientColorImage(colors: startButtonColors, for: .normal)
        
        self.answersBackView2 = UIView(frame: self.answersBackView.bounds)
        self.answersBackView2.frame.size.width *= 0.85
        self.answersBackView2.frame.size.height -= 20
        self.answersBackView2.center = self.answersBackView.frame.center
        self.answersBackView.addSubview(self.answersBackView2)
        
        ///
        if let question = votingInfo["question"] as? String {
           self.questionLabel.text = question
        }
        
        let answers = self.mappingAnswer(infoDic: self.votingInfo)
        self.makeAnswerComponent(answers: answers)
        
        //보팅이 끝난 항목은 수정을 못한다
        //보팅이 끝난 항목만 초기화가 가능하다
        if let status = self.votingInfo["status"] as? String,
            status == "2" {
            self.editButton.isHidden = true
//            self.resetButton.isHidden = false
        }else{
            self.editButton.isHidden = false
//            self.resetButton.isHidden = true
        }
        
        showResult(results: self.makeResultFromInfo())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("here")
        
//        showResult(results: self.makeResultFromInfo())
        
        
    }
    
    func makeResultFromInfo() -> [Int]{
        
        //결과 가공
        let result = self.votingInfo["result"] as? [String:Any] ?? [String:Any]()
        var kResults = [Int]()
        for i in 0..<6{
            let key = "value\(i+1)"
            let valueString = result[key] as? String ?? ""
            let value = valueString.toInt() ?? 0
            kResults.append(value)
        }
        return kResults
    }
    
    func showResult(results : [Int]){
        
        //결과보기
        let count = min(self.answerComponentViews.count, results.count)
        let sum = Array(0..<count).reduce(0) { (result : Int, value : Int) -> Int in
            return result + results[value]
        }
        
        var maxValue = 0
        for i in 0..<count {
            if maxValue < results[i] {
                maxValue = results[i]
            }
        }

        for i in 0..<count {
            let value = (sum == 0) ? 0 : CGFloat(results[i]) / CGFloat(sum)
            self.answerComponentViews[i].resultBar.backgroundColor = (results[i] == maxValue) ? self.answerComponentViews[i].highValueBarColor : self.answerComponentViews[i].nomalValueBarColor

            self.answerComponentViews[i].resultUpdate(value: value, withAnimation: true)
            
            if let status = self.votingInfo["status"] as? String, status != "0" {
                
                
                
                if VOTING_RESULT_OPTION == .number {
                    let optionString = "\(results[i]) / \(sum)"
                    self.answerComponentViews[i].optionLabel.text = optionString
                }else if VOTING_RESULT_OPTION == .percent {
                    let optionString = "\(Int(value * 100))%"
                    self.answerComponentViews[i].optionLabel.text = optionString
                }
            }
        }
        
        
    }
    
    func mappingAnswer(infoDic:[String:Any]) -> [[String:Any]] {
        
        print("===============mappingAnswer:\(infoDic.showValue())")
        
        var answers = [[String:Any]]()
        
        for i in 0..<10{
            let key = "answer\(i + 1)"
            if let answer = infoDic[key] as? String, answer != "" {
                var answerDic = [String:Any]()
                answerDic["answer"] = answer
                answerDic["correct"] = infoDic["correct"]
                answers.append(answerDic)
            }
        }
        
        return answers
    }

    func makeAnswerComponent(answers : [[String:Any]]){
        for i in 0..<answers.count{
            
            guard let answer = answers[i]["answer"] as? String else { return }
            
            print("\(answer)")
            
            let answerComponentViewHeight : CGFloat = answersBackView2.frame.size.height / CGFloat(answers.count)
            let answerComponentViewY : CGFloat = CGFloat(i) * answerComponentViewHeight
            
            let answerComponentViewBackView = UIView(frame: CGRect(
                x: 0,
                y: answerComponentViewY,
                width: answersBackView2.frame.size.width,
                height: answerComponentViewHeight))
            answersBackView2.addSubview(answerComponentViewBackView)
            
            var answerComponentViewFrame = answerComponentViewBackView.bounds
            answerComponentViewFrame.size.height = min(90, answerComponentViewFrame.size.height * 0.7)
            
            let answerComponentView = AnswerComponentView(frame: answerComponentViewFrame)
            answerComponentView.center = answerComponentViewBackView.frame.center
            answerComponentView.answerLabel.text = answer
            answerComponentView.indexLabel.text = "\(i+1)"
            if IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION,
               let correct = answers[i]["correct"] as? String,
               correct == "\(i+1)" {
                answerComponentView.indexLabel.backgroundColor = UIColor(colorWithHexString: "AF2600")
            }
            answerComponentViewBackView.addSubview(answerComponentView)
            
            self.answerComponentViews.append(answerComponentView)
            //            answerComponentViewBackView.backgroundColor = UIColor.random.withAlphaComponent(0.3)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        appDel.lecutreListVC?.tableView.isEditing = false
        appDel.lecutreListVC?.tableView.reloadData()
        appDel.lecutreListVC?.editButton.setTitle("편집", for: .normal)
        
        appDel.votingListVC?.tableView.isEditing = false
        appDel.votingListVC?.tableView.reloadData()
        appDel.votingListVC?.editButton.setTitle("편집", for: .normal)
        
        let votingVC = VotingViewController()
//        votingVC.modalPresentationStyle = .
        votingVC.votingInfos = self.votingInfos
        votingVC.votingIndex = self.votingIndex
        votingVC.modalPresentationStyle = .fullScreen
        appDel.mainVC?.present(votingVC, animated: false, completion: {
            
        })
    }
    
//    @IBAction func resetButtonPressed(_ sender: UIButton) {
//        
//        appDel.lectureListEndEditing()
//        appDel.votingListEndEditing()
//        
//        let yesAction = UIAlertAction(title: "예", style: .destructive) { (action : UIAlertAction) in
//            if let sid = self.votingInfo["sid"] as? String {
//                let urlString = "\(VOTING_RESET)?sid=\(sid)&room=\(room)"
//                appDel.showHud()
//                Server.postData(urlString: urlString) { (kData : Data?) in
//                    appDel.hideHud()
//                    toastShow(message: "초기화 완료")
//                    self.votingListVC?.votingListUpdate {
//                        appDel.stackedViewController?.popViewController(self, animated: true)
//                    }
//                }
//            }
//        }
//        let noAction = UIAlertAction(title: "아니오", style: .default) { (action : UIAlertAction) in
//            
//        }
//        appDel.showAlert(title: "초기화", message: "해당 퀴즈의 통계데이터를 초기화 하시겠습니까?", actions: [yesAction,noAction])
//        
//    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let addVotingVC = AddVotingViewController()
        addVotingVC.lecture = self.lectureSid
        addVotingVC.votingInfo = self.votingInfo
        addVotingVC.isEdit = true
        addVotingVC.modalPresentationStyle = .overCurrentContext
        self.present(addVotingVC, animated: false) {
            
        }
        
    }
    
}

