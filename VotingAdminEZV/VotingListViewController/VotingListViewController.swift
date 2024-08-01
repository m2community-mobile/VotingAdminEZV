//
//  VotingListViewController.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class VotingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var quickAddButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    var name = ""
    
    var lectrueSid = ""
    var votingArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDel.votingListVC = self
        
        self.titleLabel.text = name
        
        tableView.register(UINib(nibName: "VotingListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "VotingListViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        
        self.addButton.backgroundColor = UIColor.clear
        self.addButton.setTitleColor(UIColor.white, for: .normal)
        self.addButton.layer.cornerRadius = 5
        self.addButton.layer.borderWidth = 0.5
        self.addButton.layer.borderColor = UIColor.white.cgColor
        
        self.resetButton.backgroundColor = UIColor.clear
        self.resetButton.setTitleColor(UIColor.white, for: .normal)
        self.resetButton.layer.cornerRadius = 5
        self.resetButton.layer.borderWidth = 0.5
        self.resetButton.layer.borderColor = UIColor.white.cgColor
        self.resetButton.isHidden = true
        
        self.editButton.backgroundColor = UIColor.clear
        self.editButton.setTitleColor(UIColor.white, for: .normal)
        self.editButton.layer.cornerRadius = 5
        self.editButton.layer.borderWidth = 0.5
        self.editButton.layer.borderColor = UIColor.white.cgColor
       
        self.refreshButton.backgroundColor = UIColor.clear
        self.refreshButton.setTitleColor(UIColor.white, for: .normal)
        self.refreshButton.layer.cornerRadius = 5
        self.refreshButton.layer.borderWidth = 0.5
        self.refreshButton.layer.borderColor = UIColor.white.cgColor
        
        
        self.quickAddButton.backgroundColor = UIColor.clear
        self.quickAddButton.setTitleColor(UIColor.white, for: .normal)
        self.quickAddButton.layer.cornerRadius = 5
        self.quickAddButton.layer.borderWidth = 0.5
        self.quickAddButton.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func quickAddButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.tableView.isEditing = false
        self.tableView.reloadData()
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let urlString = "\(VOTING_ADD_QUICK)?code=\(code)&lecture=\(lectrueSid)&room=\(room)"
        appDel.showHud()
        Server.postData(urlString: urlString) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                if let dataString = data.toString() {
                    if dataString == "Y"{
                        DispatchQueue.main.async {
                            toastShow(message: "등록되었습니다.")
                            self.votingListUpdate {}
                        }
                    }
                }
                print("")
            }
        }
        
        
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        self.tableView.isEditing = !self.tableView.isEditing
        
        appDel.lectureListEndEditing()
        
        sender.setTitle(self.tableView.isEditing ? "편집완료":"편집", for: .normal)
        
        self.tableView.reloadData()
    }
    
//    @IBAction func resetButtonPressed(_ sender: UIButton) {
//        
//        appDel.lectureListEndEditing()
//        appDel.votingListEndEditing()
//        
//        let yesAction = UIAlertAction(title: "예", style: .destructive) { (action : UIAlertAction) in
//            let urlString = "\(LECTURE_RESET)?code=\(code)&sid=\(self.lectrueSid)&room=\(room)"
//            appDel.showHud()
//            Server.postData(urlString: urlString) { (kData : Data?) in
//                appDel.hideHud()
//                self.votingListUpdate{
//                    appDel.stackedViewController?.pop(to: self, animated: true)
//                    toastShow(message: "초기화 완료")
//                }
//            }
//        }
//        let noAction = UIAlertAction(title: "아니오", style: .default) { (action : UIAlertAction) in
//            
//        }
//        appDel.showAlert(title: "초기화", message: "\(name) 강의에 포함된 모든 퀴즈의 통계데이터를 초기화 하시겠습니까?", actions: [yesAction,noAction])
//    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let addVotingVC = AddVotingViewController()
        addVotingVC.lecture = self.lectrueSid
        addVotingVC.modalPresentationStyle = .overCurrentContext
        self.present(addVotingVC, animated: false) {
            
        }
    }
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        self.votingListUpdate{
            appDel.stackedViewController?.pop(to: self, animated: true)
            toastShow(message: "새로고침 완료")
        }
        
    }
    
    
    func votingListUpdate(complete:@escaping()->Void){
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let urlString = "\(VOTING_LIST)?code=\(code)&sid=\(lectrueSid)&room=\(room)"
        print("votingListUpdate urlString:\(urlString)")
         appDel.showHud()
        Server.postData(urlString: urlString) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                if let dataArray = data.toJson() as? [[String:Any]] {
                    self.votingArray = dataArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            complete()
        }
    }

}

extension VotingListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.votingArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingListViewCell", for: indexPath) as! VotingListViewCell
//        cell.selectionStyle = .none
//        question
        cell.valueLabel.text = self.votingArray[indexPath.row]["question"] as? String ?? ""

        cell.statusLabel.backgroundColor = UIColor.clear
        if let status = self.votingArray[indexPath.row]["status"] as? String {
            /*
             0 보팅 전
             1 보팅 중
             2 보팅 후
             */
            if status == "0" {
                cell.statusLabel.textColor = deepRedColor
            }else{
                cell.statusLabel.textColor = deepGreenColor
            }
        }
        
        cell.statusLabel.frame.origin.x = tableView.isEditing ? 50 : 0
        cell.valueLabelBackView.frame.origin.x = cell.statusLabel.frame.maxX
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let votingPreviewVC = VotingPreviewViewController()
        votingPreviewVC.lectureSid = self.lectrueSid
        votingPreviewVC.votingInfos = self.votingArray
        votingPreviewVC.votingIndex = indexPath.row
        votingPreviewVC.votingListVC = self
        appDel.stackedViewController?.pushViewController(votingPreviewVC, from: self, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "삭제") { (action : UITableViewRowAction, indexPath : IndexPath) in

            let question = self.votingArray[indexPath.row]["question"] as? String ?? ""
            
            if VOTING_DELETE_OPTION {
                
                let noAction = UIAlertAction(title: "아니오", style: .default, handler: { (action) in
                    
                })
                let yesAction = UIAlertAction(title: "예", style: .destructive, handler: { (action) in
                    if let sid = self.votingArray[indexPath.row]["sid"] as? String {
                        let urlString = "\(VOTING_DEL)?sid=\(sid)&room=\(room)"
                        appDel.showHud()
                        Server.postData(urlString: urlString, completion: { (kData : Data?) in
                            appDel.hideHud()
                            if let data = kData {
                                if let dataString = data.toString() {
                                    print("보팅 삭제:\(dataString)")
                                    if dataString == "Y" {
                                        self.votingArray.remove(at: indexPath.row)
                                        DispatchQueue.main.async {
                                            self.tableView.beginUpdates()
                                            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                            self.tableView.endUpdates()
                                            
                                            toastShow(message: "\(question) 보팅이 삭제되었습니다.")
                                        }
                                    }
                                }
                            }
                        })
                    }
                })
                
                appDel.showAlert(title: "안내", message: "\(question) 보팅을 삭제하시겠습니까?", actions: [yesAction,noAction], viewCon: self) {}
            }else{
                if let sid = self.votingArray[indexPath.row]["sid"] as? String {
                    let urlString = "\(VOTING_DEL)?sid=\(sid)&room=\(room)"
                    appDel.showHud()
                    Server.postData(urlString: urlString, completion: { (kData : Data?) in
                        appDel.hideHud()
                        if let data = kData {
                            if let dataString = data.toString() {
                                print("보팅 삭제:\(dataString)")
                                if dataString == "Y" {
                                    self.votingArray.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        self.tableView.beginUpdates()
                                        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                        self.tableView.endUpdates()
                                        
                                        toastShow(message: "\(question) 보팅이 삭제되었습니다.")
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "수정") { (action : UITableViewRowAction, indexPath : IndexPath) in
            print("edit")
            
            let addVotingVC = AddVotingViewController()
            addVotingVC.lecture = self.lectrueSid
            
            addVotingVC.votingInfo = self.votingArray[indexPath.row]
            addVotingVC.isEdit = true
            addVotingVC.modalPresentationStyle = .overCurrentContext
            self.present(addVotingVC, animated: false) {
                
            }
        }
        
        if let status = self.votingArray[indexPath.row]["status"] as? String {
            if status == "2" {
                return [deleteAction]
            }
        }
        return [deleteAction,editAction]
    }
}
