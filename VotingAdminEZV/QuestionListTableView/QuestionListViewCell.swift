//
//  QuestionListViewCell.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 25/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

@objc protocol QuestionListViewCellDelegate {
    @objc optional func questionListViewCell(cell : QuestionListViewCell, selected indexPath:IndexPath)
}

class QuestionListViewCell: UITableViewCell {

    @IBOutlet weak var lectureBackView: UIView!
    @IBOutlet weak var lectureNoticeLabelBackView: UIView!
    @IBOutlet weak var lectureNoticeLabel: UILabel!
    
    @IBOutlet weak var lectureLabelBackView: UIView!
    @IBOutlet weak var lectureLabel: UILabel!
    
    
    @IBOutlet weak var questionlabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var separaterView: UIView!
    
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var personImageView: UIImageView!
    
    
    var questionlabelOriginalY : CGFloat = 0
    var questionlabelOriginalWidth : CGFloat = 0
    
    var timeLabelOriginalGap : CGFloat = 0
    
    var indexPath = IndexPath(row: 0, section: 0)
    weak var delegate : QuestionListViewCellDelegate?
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        self.delegate?.questionListViewCell?(cell: self, selected: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lectureBackViewOriginalY = self.lectureBackView.frame.origin.y
        
        self.questionlabelOriginalWidth = self.questionlabel.frame.size.width
        self.questionlabelOriginalY = self.questionlabel.frame.origin.y
        
        self.timeLabelOriginalGap = self.timeLabel.frame.origin.x - self.questionlabel.frame.maxY
        
        lectureBackView.layer.cornerRadius = 5
        lectureBackView.clipsToBounds = true

        roomLabel.adjustsFontSizeToFitWidth = true
        
        var lectureNoticeLabelBackViewBackgroundColors = [UIColor]()
        for i in 0..<5 {
            
            lectureNoticeLabelBackViewBackgroundColors.append(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).removeBrightness(val: 0.1 * CGFloat(i)))
        }
        lectureNoticeLabelBackView.setGradientBackgroundColor(colors: lectureNoticeLabelBackViewBackgroundColors)
        
        lectureLabelBackView.backgroundColor = UIColor(white: 0.85, alpha: 1)

        questionlabel.backgroundColor = UIColor.clear
        timeLabel.backgroundColor = UIColor.clear

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
        self.lectureNoticeLabel.text = LECTURE_LABEL_STRING
    }
    
    func questionUpdate(question : String) -> CGFloat{
        
        lectureLabelShowUpdate()
        
        lectureLabelTextUpdate()
        
        self.questionlabel.frame.size = CGSize(width: self.questionlabelOriginalWidth, height: 1000)
        self.questionlabel.text = question
        
        self.questionlabel.font = UIFont.systemFont(ofSize: FONT_SIZE)
        self.questionlabel.sizeToFit()
        
        self.timeLabel.frame.origin.y = self.questionlabel.frame.maxY + self.timeLabelOriginalGap
        
        separaterView.frame.origin.y = self.timeLabel.frame.maxY + 10
        
        self.frame.size.height = self.separaterView.frame.maxY
        self.actionButton.frame.size.height = self.frame.size.height
        
        roomLabel.frame = CGRect(x: personImageView.frame.origin.x, y: personImageView.frame.maxY, width: 55, height: separaterView.frame.minY - (personImageView.frame.maxY))
        
        return self.frame.size.height
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
