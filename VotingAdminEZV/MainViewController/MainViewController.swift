//
//  MainViewController.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

var language = UILabel()

class MainViewController: UIViewController {

    @IBOutlet weak var reloadButton: UIButton!
    
    @IBOutlet weak var questionViewButton: UIButton!
    @IBOutlet weak var wideQuestionViewButton: UIButton!
    var lectureArray = [[String:Any]]()
    
    @IBOutlet weak var leftLogoButton: UIButton!
    
    @IBOutlet weak var questionNumberLabelBackView: UIView!
    var questionNumberLabel : UILabel!
    
    @IBOutlet weak var lastQuestionLabelBackView: UIView!
    var lastQuestionLabel : UILabel!
    var lastQuestionLabelBackViewOriginalRect = CGRect.zero
    
    @IBOutlet weak var serverInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    

        appDel.mainVC = self
        
        
        lastQuestionLabelBackViewOriginalRect = lastQuestionLabelBackView.frame
        
        lastQuestionLabelBackView.layer.cornerRadius = lastQuestionLabelBackView.frame.size.height / 2
        lastQuestionLabelBackView.clipsToBounds = true
        var gradientColors1 = [UIColor]()
        for i in 0..<5 {
            gradientColors1.append(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).removeBrightness(val: 0.05 * CGFloat(i)))
        }
        lastQuestionLabelBackView.setGradientBackgroundColor(colors: gradientColors1)
        
        lastQuestionLabel = UILabel(frame: lastQuestionLabelBackView.bounds)
        lastQuestionLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: lastQuestionLabel.frame.size.height * 0.4)
        lastQuestionLabelBackView.addSubview(lastQuestionLabel)
        
        
        questionNumberLabelBackView.isUserInteractionEnabled = false
        questionNumberLabelBackView.backgroundColor = UIColor.clear
        questionNumberLabelBackView.backgroundColor = UIColor.systemRed
        questionNumberLabelBackView.layer.cornerRadius = questionNumberLabelBackView.frame.size.width / 2
        questionNumberLabelBackView.clipsToBounds = true
        questionNumberLabelBackView.layer.borderColor = UIColor.white.cgColor
        questionNumberLabelBackView.layer.borderWidth = 2
        var gradientColors = [UIColor]()
        for i in 0..<5 {
            gradientColors.append(UIColor.systemRed.removeBrightness(val: 0.05 * CGFloat(i)))
        }
        questionNumberLabelBackView.setGradientBackgroundColor(colors: gradientColors)
        
        questionNumberLabel = UILabel(frame: questionNumberLabelBackView.bounds)
        questionNumberLabel.text = "0"
        questionNumberLabel.textColor = UIColor.white
        questionNumberLabel.textAlignment = .center
        questionNumberLabel.font = UIFont(name: HelveticaNeue_Bold, size: questionNumberLabel.frame.size.height * 0.6)
        questionNumberLabelBackView.addSubview(questionNumberLabel)
        
        questionViewButton.layer.cornerRadius = 5
        questionViewButton.layer.borderWidth = 0.5
        questionViewButton.layer.borderColor = UIColor.black.cgColor
        questionViewButton.clipsToBounds = true
        var gradientColors2 = [UIColor]()
        for i in 0..<5 {
            gradientColors2.append(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).removeBrightness(val: 0.05 * CGFloat(i)))
        }
        questionViewButton.setGradientBackgroundColor(colors: gradientColors2)
        
        wideQuestionViewButton.layer.cornerRadius = 5
        wideQuestionViewButton.layer.borderWidth = 0.5
        wideQuestionViewButton.layer.borderColor = UIColor.black.cgColor
        wideQuestionViewButton.clipsToBounds = true
        wideQuestionViewButton.setGradientBackgroundColor(colors: gradientColors2)
        
//        serverInfoLabel.text = appDel.rootName + "/ code : " + code + " / room : " + room
        let roomInfo = room == "" ? "공백" : room
        
        let infoTextAtt : [NSAttributedString.Key:NSObject] = [
            NSAttributedString.Key.foregroundColor:UIColor.systemRed,
            NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: serverInfoLabel.font.pointSize)
        ]
        let columnTextAtt : [NSAttributedString.Key:NSObject] = [
            NSAttributedString.Key.foregroundColor:UIColor.black,
            NSAttributedString.Key.font:serverInfoLabel.font
        ]
        
        let serverInfoLabelTextAttInfos : [(String,[NSAttributedString.Key:NSObject])] = [
            (appDel.rootName,infoTextAtt),
            (" code : ",columnTextAtt),
            (code,infoTextAtt),
            (" room : ",columnTextAtt),
            (roomInfo,infoTextAtt),
        ]
        serverInfoLabel.attributedText = NSMutableAttributedString(stringsInfos: serverInfoLabelTextAttInfos)
        
        
        self.reloadButtonPressed(reloadButton)

        appDel.questionListUpdateTimerStart()

    }
    
    
    var questionArray = [[String:Any]]()
    func questionListUpdate(questionArray kQuestionArray : [[String:Any]]){
        questionArray = kQuestionArray
        let numberOfQuestion = min(questionArray.count, 99)
        questionNumberLabel.text = "\(numberOfQuestion)"
        if numberOfQuestion < 10 {
            questionNumberLabel.font = UIFont(name: HelveticaNeue_Bold, size: questionNumberLabel.frame.size.height * 0.6)
        }else{
            questionNumberLabel.font = UIFont(name: HelveticaNeue_Bold, size: questionNumberLabel.frame.size.height * 0.5)
        }
        
        if let lastQuestionDic = questionArray.first {
            if let lastQuestion = lastQuestionDic["question"] as? String {
                
                //원래 사이즈로 돌리고
                let sampleBackView = UIView(frame: lastQuestionLabelBackViewOriginalRect)
                let sampleLabel = UILabel(frame: sampleBackView.bounds)
                sampleLabel.frame.size.width -= 30
                sampleLabel.frame.origin.x = 15
                let lastQuestionLabelMaxRect = sampleLabel.frame
                
                sampleLabel.font = lastQuestionLabel.font
                sampleLabel.text = lastQuestion.toHtmlAttString()?.string.replacingOccurrences(of: "\n", with: " ")
                sampleLabel.numberOfLines = 0
                sampleLabel.sizeToFit()
                //height은 원래 height
                sampleLabel.frame.size.height = lastQuestionLabelMaxRect.height

                //width는 조정된 크기와 맥스 크기중 작은걸 선택 (조정된 크기가 맥스를 넘을 경우 맥스에 맞추기 위함)
                sampleLabel.frame.size.width = min(sampleLabel.frame.size.width, lastQuestionLabelMaxRect.size.width)
                //라운드 뷰 사이즈 조정
                sampleBackView.frame.size.width = sampleLabel.frame.maxX + 15
                
                //sample을 통해서 알아낸 프레임 적용
                lastQuestionLabel.frame = sampleLabel.frame
                lastQuestionLabel.text = sampleLabel.text
                lastQuestionLabelBackView.frame = sampleBackView.frame
                
                return
            }
        }
        //라스트 질문이 없으면, 즉 질문이 아무것도 없을때
        lastQuestionLabelBackView.frame = CGRect.zero
        
    }
    
    @IBAction func questionViewButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let questionVC = QuestionViewController()
        questionVC.modalPresentationStyle = .fullScreen
        self.present(questionVC, animated: false) {
            
        }
    }
    
    @IBAction func wideQuestionViewButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let questionVC = QuestionViewController()
        questionVC.wideMode = true
        questionVC.modalPresentationStyle = .fullScreen
        self.present(questionVC, animated: false) {
            
        }
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let urlString = "\(LECTURE_LIST)?code=\(code)&room=\(room)"
        
        appDel.showHud()
        Server.postData(urlString: urlString) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                let dataArray = data.toJson() as? [[String:Any]] ?? [[String:Any]]()
                self.lectureArray = dataArray
                DispatchQueue.main.async {
                    let lecutreListVC = LecutreListViewController()
                    lecutreListVC.lectureArray = self.lectureArray
                    appDel.stackedViewController?.popToRootViewController(animated: false)
                    appDel.stackedViewController?.pushViewController(lecutreListVC, animated: true)
                    
                    
                }
                return
                
            }
        }
        
        
    }
    
    @IBAction func leftLogoButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let alertCon = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alertCon.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { (action) in
            
        }))
        alertCon.addAction(UIAlertAction(title: "예", style: .default, handler: { (action) in
            appDel.naviCon?.popToRootViewController(animated: true)
        }))
        appDel.naviCon?.present(alertCon, animated: true, completion: {
            
        })
        
    }
    
    @IBAction func questionListButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let questionListVC = QuestionListViewController()
        questionListVC.questionArray = questionArray
        appDel.questionListVC = questionListVC
        questionListVC.modalPresentationStyle = .overCurrentContext
    
        self.present(questionListVC, animated: false) {
            questionListVC.tableView.reloadData()
        }
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let settingVC = SettingViewController()
        settingVC.modalPresentationStyle = .popover
        settingVC.preferredContentSize = CGSize(width: 360, height: 450)
        #if targetEnvironment(macCatalyst)
        settingVC.preferredContentSize = CGSize(width: 370, height: 450)
        #endif
        let presentVC = settingVC.presentationController as! UIPopoverPresentationController
        presentVC.sourceView = sender
        presentVC.sourceRect = sender.bounds
        presentVC.permittedArrowDirections = [.down, .left]
        
//        if #available(iOS 13.0, *) {
//            presentVC.permittedArrowDirections = []
//        }

        self.present(settingVC, animated: true) {
            
        }
    }

}
