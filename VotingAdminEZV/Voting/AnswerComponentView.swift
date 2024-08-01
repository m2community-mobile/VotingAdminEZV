//
//  VotingComponentView.swift
//  VotingAdminEZV
//
//  Created by JinGu-MacBookPro on 20/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class AnswerComponentView: UIView {

    var index = 1
    
    //보팅을 진행하기 전 기본 컬러
    let nonValueBarColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    
    //가장 많은 답변을 제외한 나머지 바 컬러
    let nomalValueBarColor = #colorLiteral(red: 0.6823529412, green: 0.137254902, blue: 0.09411764706, alpha: 1)
    
    //가장 많은 답변을 받은 바 컬러
    let highValueBarColor = #colorLiteral(red: 0.3882352941, green: 0.662745098, blue: 0.2117647059, alpha: 1)
    
    //정답의 바 컬러 - 보류
    let answerValueBarColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    
    //좌우 여백을 가지기 위한 안쪽 뷰
    var innerView : UIView!
    
    var indexLabel : UILabel!
    var answerLabel : UILabel!
    var valueBar : UIView!
    var resultBar : UIView!
    
    var optionLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let halfHeight = self.frame.size.height / 2
        let fontSize = halfHeight * 0.6
        
        innerView = UIView(frame: self.bounds)
//        innerView.frame.size.width *= 0.85
        self.addSubview(innerView)
        
        indexLabel = UILabel(frame: CGRect(x: 0, y: 0, width: halfHeight, height: halfHeight))
        indexLabel.backgroundColor = UIColor.black
        indexLabel.text = "\(index)"
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.white
        indexLabel.font = UIFont(name: HelveticaNeue_Bold, size: fontSize)
        innerView.addSubview(indexLabel)
        
        optionLabel = UILabel(frame: CGRect(x: self.frame.size.width - (halfHeight * 2), y: 0, width: halfHeight * 2, height: halfHeight))
        optionLabel.textAlignment = . center
        optionLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: optionLabel.frame.size.height * 0.4)
        optionLabel.text = ""
        innerView.addSubview(optionLabel)
        if VOTING_RESULT_OPTION == .none {
            optionLabel.frame.origin.x = innerView.frame.size.width
            optionLabel.frame.size.width = 0
        }
        
        let answerLabelBackView = UIView(frame: CGRect(x: indexLabel.frame.maxX, y: 0, width: optionLabel.frame.minX - indexLabel.frame.maxX, height: indexLabel.frame.size.height))
        innerView.addSubview(answerLabelBackView)
        
        answerLabel = UILabel(frame: answerLabelBackView.bounds)
        answerLabel.frame.size.width -= 30
        answerLabel.center = answerLabelBackView.frame.center
        answerLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: fontSize)
        answerLabelBackView.addSubview(answerLabel)
        
        answerLabel.numberOfLines = 2
        answerLabel.adjustsFontSizeToFitWidth = true
        
        valueBar = UIView(frame: CGRect(x: 0, y: indexLabel.frame.maxY, width: innerView.frame.size.width, height: halfHeight))
        valueBar.backgroundColor = nonValueBarColor
        innerView.addSubview(valueBar)
        
        resultBar = UIView(frame: valueBar.bounds)
        resultBar.frame.size.width = 0
        resultBar.backgroundColor = highValueBarColor
        valueBar.addSubview(resultBar)
        
        innerView.frame.size.height = valueBar.frame.maxY
        innerView.center = self.frame.center
        self.frame.size.height = innerView.frame.maxY

//        answerLabel.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        answerLabelBackView.backgroundColor = UIColor.random.withAlphaComponent(0.3)
//        innerView.backgroundColor = UIColor.random.withAlphaComponent(0.3)
        
    }
    
    func resultUpdate(value : CGFloat, withAnimation : Bool, fromZero : Bool = true){
        let afterWidth = self.valueBar.frame.size.width * value
        if fromZero {
            self.resultBar.frame.size.width = 0
        }
        
        if withAnimation {
            UIView.animate(withDuration: 0.8, animations: {
                self.resultBar.frame.size.width = afterWidth
            }) { (fi) in
                
            }
        }else{
            self.resultBar.frame.size.width = afterWidth
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
