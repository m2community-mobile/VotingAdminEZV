//
//  ChairTableViewCell.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 30/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

var selecLabel = UILabel()

@objc protocol ChairTableViewCellDelegate {
    @objc optional func ChairTableViewCell(_ cell : ChairTableViewCell, indexPath : IndexPath, selectButtonPressed : UIButton)
}




class ChairTableViewCell: UITableViewCell {
    
    
    
    var delegate : ChairTableViewCellDelegate?
    var indexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var lectureBackView: UIView!
    @IBOutlet weak var lectureNoticeLabelBackView: UIView!
    @IBOutlet weak var lectureNoticeLabel: UILabel!
    
    @IBOutlet weak var lectureLabelBackView: UIView!
    @IBOutlet weak var lectureLabel: UILabel!
    
    
    @IBOutlet weak var questionlabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var separaterView: UIView!

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectButtonLabelBackView: UIView!
    @IBOutlet weak var selectButtonLabel: UILabel!
    
    var questionlabelOriginalY : CGFloat = 0
    
    var contentWidth : CGFloat = 0
    var contentWidthWhenHideSelectButton : CGFloat = 0
    
    var lectureBackViewWidth : CGFloat {
        QUESTION_SELECT_HIDE_OPTION ? (contentWidthWhenHideSelectButton - 15) : contentWidth
    }
    
    var lectureLabelBackViewWidth : CGFloat {
        lectureBackViewWidth - lectureNoticeLabelBackView.frame.maxX
    }
    var lectureLabelWidth : CGFloat {
        lectureLabelBackViewWidth - (8 * 2)
    }
    var questionlabelWidth : CGFloat {
        self.lectureBackViewWidth
    }
    var timeLabelWidth : CGFloat {
        self.lectureBackViewWidth
    }
    
    
    var timeLabelOriginalGap : CGFloat = 0
    
    var isButtonSelected : Bool = true {
        
        
        
        willSet(newValue){
            var colors = [UIColor]()
            for i in 0..<5 {
                if newValue {
                    colors.append(#colorLiteral(red: 0.7450980392, green: 0.3215686275, blue: 0.6588235294, alpha: 1).removeBrightness(val: 0.05 * CGFloat(i)))
                    
                    self.selectButtonLabel.text = "선택됨"
                    
                    if lanLabel.text == "한국어" {
                        self.selectButtonLabel.text = "선택됨"
                    }
                    
                    if lanLabel.text == "English" {
                        self.selectButtonLabel.text = "Selected"
                    }
                    
                    
                    
                    
                    
                }else{
                    colors.append(#colorLiteral(red: 0.3647058824, green: 0.3960784314, blue: 0.5647058824, alpha: 1).removeBrightness(val: 0.05 * CGFloat(i)))
                    self.selectButtonLabel.text = "질문선택"
                    
                    if lanLabel.text == "한국어" {
                        self.selectButtonLabel.text = "질문선택"
                    }
                    
                    if lanLabel.text == "English" {
                        self.selectButtonLabel.text = "Select"
                    }
                    
                    
                }
                
                
            }
            self.selectButtonLabelBackView.setGradientBackgroundColor(colors: colors)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveTestNotification(_:)), name: NSNotification.Name("change"), object: nil)
        
        contentWidth = lectureBackView.frame.size.width
        contentWidthWhenHideSelectButton = self.selectButtonLabelBackView.frame.maxX - lectureBackView.frame.minX
        
        
        self.questionlabelOriginalY = self.questionlabel.frame.origin.y
        
        self.timeLabelOriginalGap = self.timeLabel.frame.origin.x - self.questionlabel.frame.maxY
        
        lectureBackView.layer.cornerRadius = 5
        lectureBackView.clipsToBounds = true
        
        var lectureNoticeLabelBackViewBackgroundColors = [UIColor]()
        for i in 0..<5 {
            
            lectureNoticeLabelBackViewBackgroundColors.append(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).removeBrightness(val: 0.1 * CGFloat(i)))
        }
        lectureNoticeLabelBackView.setGradientBackgroundColor(colors: lectureNoticeLabelBackViewBackgroundColors)
        
        lectureLabelBackView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
        questionlabel.backgroundColor = UIColor.clear
        timeLabel.backgroundColor = UIColor.clear
        
        
        selectButtonLabelBackView.isUserInteractionEnabled = false
        selectButtonLabel.isUserInteractionEnabled = false
        
        var colors = [UIColor]()
        for i in 0..<5 {
            
            colors.append(#colorLiteral(red: 0.3647058824, green: 0.3960784314, blue: 0.5647058824, alpha: 1).removeBrightness(val: 0.05 * CGFloat(i)))
//            colors.append(#colorLiteral(red: 0.7450980392, green: 0.3215686275, blue: 0.6588235294, alpha: 1).removeBrightness(val: 0.05 * CGFloat(i)))
        }
        
        self.selectButtonLabelBackView.setGradientBackgroundColor(colors: colors)
        self.selectButtonLabelBackView.layer.cornerRadius = 5
        self.selectButtonLabelBackView.clipsToBounds = true
        
        self.selectButtonLabel.textColor = UIColor.white
        self.selectButtonLabel.backgroundColor = UIColor.clear
        
        self.selectButton.backgroundColor = UIColor.clear
        
//        self.uiCheck()
        
    }
    
    @IBAction func selectButtonPressed(_ sender: UIButton) {
        print("selectButtonPressed")
        self.delegate?.ChairTableViewCell?(self, indexPath: self.indexPath, selectButtonPressed: sender)
    }
    
    
    func lectureLabelShowUpdate(){
        if SHOW_LECTURE_LABEL {
            self.lectureBackView.isHidden = false
            self.questionlabel.frame.origin.y = self.questionlabelOriginalY
        }else{
            self.lectureBackView.isHidden = true
            self.questionlabel.frame.origin.y = self.lectureBackView.frame.origin.y
        }
    }
    
    func lectureLabelTextUpdate(){
        
        lectureBackView.frame.size.width = lectureBackViewWidth
        lectureLabelBackView.frame.size.width = lectureLabelBackViewWidth
        lectureLabel.frame.size.width = lectureLabelWidth
        timeLabel.frame.size.width = timeLabelWidth
        
        self.lectureNoticeLabel.text = LECTURE_LABEL_STRING
    }
    
    func questionUpdate(question : String) -> CGFloat{
        
        lectureLabelShowUpdate()
        
        lectureLabelTextUpdate()
        
        
        self.questionlabel.frame.size = CGSize(width: questionlabelWidth, height: 1000)
        self.questionlabel.text = question
        
        self.questionlabel.font = UIFont.systemFont(ofSize: FONT_SIZE)
        self.questionlabel.sizeToFit()
        
        self.timeLabel.frame.origin.y = self.questionlabel.frame.maxY + self.timeLabelOriginalGap
        
        separaterView.frame.origin.y = self.timeLabel.frame.maxY + 20
        
        self.frame.size.height = self.separaterView.frame.maxY
        
//        self.selectButton.frame.size.height = self.frame.size.height - 40
        self.selectButton.frame = selectButtonLabel.frame
        
        return self.frame.size.height
        
    }

    @objc func didRecieveTestNotification(_ notification: Notification) {
        print("Test Notification")
        
//        if lanLabel.text == "English" {
//            if selectButtonLabel.text == "질문선택" {
//                selectButtonLabel.text = "Select"
//                
//            }
//            if selectButtonLabel.text == "선택됨" {
//                selectButtonLabel.text = "Selected"
//                
//            }
//        
//        }
//        
//        if lanLabel.text == "한국어" {
//            if selectButtonLabel.text == "Select" {
//                selectButtonLabel.text = "질문선택"
//                
//            }
//            if selectButtonLabel.text == "Selected" {
//                selectButtonLabel.text = "선택됨"
//                
//            }
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

//        selectButtonLabel.text = selecLabel.text
    }
}
