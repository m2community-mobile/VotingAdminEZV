//
//  VotingView.swift
//  VotingAdminEZV
//
//  Created by JinGu-MacBookPro on 20/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class VotingView: UIView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerBackView: UIView!
    
    @IBOutlet weak var votingButtonBackImageView: UIImageView!
    
    @IBOutlet weak var votingButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var beforeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var answerBackView2: UIView!
    
    var votingInfo = [String:Any]()
    
    var results = [Int]()
    
    var answerComponentViews = [AnswerComponentView]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        print("votingInfo:\(votingInfo.showValue())")
        
        
        self.questionLabel.backgroundColor = UIColor.clear
        
        self.votingButton.layer.cornerRadius = 5
        self.answerBackView.backgroundColor = UIColor.clear
        
        beforeButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        beforeButton.layer.cornerRadius = 5
        beforeButton.backgroundColor = UIColor.clear
        beforeButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        beforeButton.layer.borderWidth = 0.5
        
        refreshButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        refreshButton.layer.cornerRadius = 5
        refreshButton.backgroundColor = UIColor.clear
        refreshButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        refreshButton.layer.borderWidth = 0.5
        
        nextButton.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        nextButton.layer.cornerRadius = 5
        nextButton.backgroundColor = UIColor.clear
        nextButton.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
        nextButton.layer.borderWidth = 0.5
        
        var votingButtonColors = [UIColor]()
        for i in 0..<5 {
            votingButtonColors.append(deepRedColor.removeBrightness(val: 0.05 * CGFloat(i)))
        }
        votingButtonBackImageView.setGradientColorImage(colors: votingButtonColors)
        votingButtonBackImageView.layer.cornerRadius = 10
        votingButtonBackImageView.clipsToBounds = true
        
        votingButton.layer.cornerRadius = 10
        
        self.answerBackView2 = UIView(frame: self.answerBackView.bounds)
        self.answerBackView2.frame.size.height -= 20
        self.answerBackView2.center = self.answerBackView.frame.center
        self.answerBackView.addSubview(self.answerBackView2)
        
        if let question = votingInfo["question"] as? String {
            self.questionLabel.text = question
        }
        
        let answers = self.mappingAnswer(infoDic: self.votingInfo)
//        print("answers:\(answers)")
        self.makeAnswerComponent(answers: answers)
        
        votingStatusApply()
    }
    
    
    
    func votingStatusApply(){
        if let status = votingInfo["status"] as? String {
            if status == "0" { //보팅 전
                votingButtonBackImageView.isHidden = false
                votingButton.isHidden = false
                self.votingButton.setTitle("Voting", for: .normal)
            }else{
                //보팅 후
                votingButtonBackImageView.isHidden = true
                votingButton.isHidden = true
            
                //결과 가공
                let result = self.votingInfo["result"] as? [String:Any] ?? [String:Any]()
                self.results = [Int]()
                for i in 0..<6{
                    let key = "value\(i+1)"
                    let valueString = result[key] as? String ?? ""
                    let value = valueString.toInt() ?? 0
                    self.results.append(value)
                }
                
                //결과 보여주기
                showResult()
                
            }
            
        }
        
    }
    
    func mappingAnswer(infoDic:[String:Any]) -> [[String:Any]] {
        
//        print("                          ===========mappingAnswer:\(infoDic.showValue())")
        
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
    
    func makeAnswerComponent(answers : [[String:Any]]){
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
            answerComponentViewFrame.size.height *= 0.7
            
            let answerComponentView = AnswerComponentView(frame: answerComponentViewFrame)
            answerComponentView.center = answerComponentViewBackView.frame.center
            answerComponentView.answerLabel.text = answer
            answerComponentView.answerLabel.numberOfLines = 2
            answerComponentView.answerLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: answerComponentViewFrame.size.height * 0.5 * 0.4)
            answerComponentView.indexLabel.text = "\(i+1)"
            answerComponentViewBackView.addSubview(answerComponentView)
            
            answerComponentViews.append(answerComponentView)
            //            answerComponentViewBackView.backgroundColor = UIColor.random.withAlphaComponent(0.3)
        }
    }

    

    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        print("closeButtonPressed")
        
        appDel.isVotingViewShow = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (fi) in
            self.removeFromSuperview()
            appDel.votingListVC?.votingListUpdate {
                
            }
        }
                
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    @IBAction func beforeButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction func votingButtonPressed(_ sender: UIButton) {
        print(#function)
//        print("votingInfo:\(votingInfo.showValue())")
        
            if sender.titleLabel?.text == "Voting" {
                votingStart()
                return
            }
            if sender.titleLabel?.text == "End" {
                votingEnd()
                return
            }
            if sender.titleLabel?.text == "결과보기" {
                showResult()
                return
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
                            DispatchQueue.main.async {
                                self.votingButton.setTitle("End", for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func votingEnd(){
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
                    
                    DispatchQueue.main.async {
                        self.showResult()
//                        self.votingButton.setTitle("결과보기", for: .normal)
                    }
                }
            }
            
            }
        }
    }
    
    func showResult(){
        
        let count = min(self.answerComponentViews.count, self.results.count)
        let sum = Array(0..<count).reduce(0) { (result : Int, value : Int) -> Int in
            return result + self.results[value]
        }
        
        for i in 0..<count {
            let value = (sum == 0) ? 0 : CGFloat(self.results[i]) / CGFloat(sum)
            self.answerComponentViews[i].resultUpdate(value: value, withAnimation: true)
        }
        self.votingButton.setTitle("", for: .normal)
        self.votingButton.isHidden = true
        self.votingButtonBackImageView.isHidden = true
    }

}
