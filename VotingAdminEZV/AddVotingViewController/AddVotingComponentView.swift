
//
//  AddVotingComponentView.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 29/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

@objc protocol AddVotingComponentViewDelegate {
    @objc optional func addVotingComponentView(_ addVotingComponentView : AddVotingComponentView, deleteButtonPressed deleteButton:UIButton)
}

class AddVotingComponentView: UIView {

    var delegate : AddVotingComponentViewDelegate?
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.deleteButton.setTarget(event: .touchUpInside) { (button) in
            self.delegate?.addVotingComponentView?(self, deleteButtonPressed: self.deleteButton)
        }
    }
}
