//
//  QuestionViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 25/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var questionLabelOriginalRect = CGRect.zero
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var backImageView: UIImageView!
    var wideMode = false
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.questionLabelOriginalRect = self.questionLabel.frame
        
        self.resetButton.backgroundColor = UIColor.clear
        self.refreshButton.backgroundColor = UIColor.clear
        
        if wideMode { wideModeSet() }
        
        qnaUpdateTimerStart()
        
    }
    
    func wideModeSet(){
        backImageView.setImageWithFrameHeight(image: UIImage(named: "question_view_bg_wide"))
        backImageView.center = self.view.center
        self.view.backgroundColor = UIColor.black
        
        closeButton.frame.origin.y = 143
        
        questionLabel.frame.origin.y = 245
        questionLabel.frame.size.height = 365
        self.questionLabelOriginalRect = self.questionLabel.frame
        
        resetButton.frame.origin.y = 504
        refreshButton.frame.origin.y = 574
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDel.isQuestionViewShow = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDel.isQuestionViewShow = false
        appDel.qnaUpdateTimer?.invalidate()
    }
    
    
    
    func qnaUpdateTimerStart(){
        appDel.qnaUpdateTimer?.invalidate()
        qnaUpdate()
        appDel.qnaUpdateTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(qnaUpdate), userInfo: nil, repeats: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        appDel.qnaUpdateTimer?.invalidate()
        self.dismiss(animated: false) {
            
        }
    }
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        let urlString = "\(QUESTION_RESET)?code=\(code)&room=\(room)"
        Server.postData(urlString: urlString) { (kData : Data?) in
            self.qnaUpdate()
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        qnaUpdateTimerStart()
    }
    

    @objc func qnaUpdate(){

        let urlString = "\(QUESTION_GET)?code=\(code)&room=\(room)"
        Server.postData(urlString: urlString) { (kData : Data?) in
            if let data = kData {
                if let dataString = data.toString() {
                    print("dataString:\(dataString)")
                    
                    if dataString == "Q&AQ&A" {
                        DispatchQueue.main.async {
                            self.questionLabel.frame = self.questionLabelOriginalRect
                            self.questionLabel.text = dataString
                            self.questionLabel.font = UIFont(name: HelveticaNeue_Medium, size: CGFloat(self.QNA_FONT_SIZE))
                            
                            if QUESTION_VIEW_ALIGEMENT_OPTION == .top {
                                let beforeWidth =  self.questionLabel.frame.size.width
                                self.questionLabel.sizeToFit()
                                self.questionLabel.frame.size.width = beforeWidth
                            }
                        }
                        return
                    }
                    self.qunSizeUpdate(qnaString: dataString)
                    
                }
            }
        }
    }
    
    let MAX_QNA_FONT_SIZE = 80
//    let MIN_QNA_FONT_SIZE = 40
    let MIN_QNA_FONT_SIZE = 25
    let QNA_FONT_SIZE : CGFloat = 200
    func qunSizeUpdate(qnaString : String){
        
        guard let dataAttString = qnaString.toHtmlAttString() else { return }
        
        for i in stride(from: MAX_QNA_FONT_SIZE, to: MIN_QNA_FONT_SIZE - 1, by: -1) {
            
            self.questionLabel.frame = self.questionLabelOriginalRect
            
            let attString = NSMutableAttributedString(attributedString: dataAttString)
            attString.setAttributes([NSAttributedString.Key.font : UIFont(name: HelveticaNeue_Medium, size: CGFloat(i))!], range: NSMakeRange(0, attString.length))
            self.questionLabel.attributedText = attString
            self.questionLabel.sizeToFit()
            
            if self.questionLabel.size.height < self.questionLabelOriginalRect.size.height {
                self.questionLabel.frame = self.questionLabelOriginalRect
//                attString.setAttributes([NSAttributedString.Key.font : UIFont(name: HelveticaNeue_Medium, size: CGFloat(i+1))!], range: NSMakeRange(0, attString.length))
//                self.questionLabel.attributedText = attString
                break
            }

            
            
            
        }
        
        self.questionLabel.frame = self.questionLabelOriginalRect
        
        if QUESTION_VIEW_ALIGEMENT_OPTION == .top {
            let beforeWidth =  self.questionLabel.frame.size.width
            self.questionLabel.sizeToFit()
            self.questionLabel.frame.size.width = beforeWidth
        }
        
        
    }
}
