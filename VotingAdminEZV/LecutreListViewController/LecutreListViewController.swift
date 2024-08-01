//
//  LecutreListViewController.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class LecutreListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    var lectureArray = [[String:Any]]()
    
//    var dataArray = Array(0..<10).map { (value : Int) -> String in
//        return "\(value)"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        appDel.lecutreListVC = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = 5
        
        self.addButton.layer.cornerRadius = 5
        self.addButton.layer.borderWidth = 0.5
        self.addButton.layer.borderColor = UIColor.white.cgColor
        
        self.editButton.layer.cornerRadius = 5
        self.editButton.layer.borderWidth = 0.5
        self.editButton.layer.borderColor = UIColor.white.cgColor
        
        
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let addLectureVC = AddLectureViewController()
        addLectureVC.modalPresentationStyle = .overCurrentContext
        addLectureVC.lecutreListVC = self
        appDel.mainVC?.present(addLectureVC, animated: false, completion: {
            
        })
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        self.tableView.isEditing = !self.tableView.isEditing
        sender.setTitle(self.tableView.isEditing ? "편집완료":"편집", for: .normal)
        
        appDel.votingListEndEditing()
    }
    
    func refresh(){
        
        appDel.lectureListEndEditing()
        appDel.votingListEndEditing()
        
        let urlString = "\(LECTURE_LIST)?code=\(code)&room=\(room)"
        appDel.showHud()
        Server.postData(urlString: urlString) { (kData : Data?) in
            appDel.hideHud()
            if let data = kData {
                if let dataArray = data.toJson() as? [[String:Any]] {
                    self.lectureArray = dataArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

}

extension LecutreListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lectureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let votingArray = self.lectureArray[indexPath.row]["votings"] as? [[String:Any]] ?? [[String:Any]]()
        let name = self.lectureArray[indexPath.row]["name"] as? String ?? ""

        //name
        cell.textLabel?.text = "\(name) (\(votingArray.count))"
        
        let infos : [(String,[NSAttributedString.Key:NSObject])] = [
        (name,[NSAttributedString.Key.foregroundColor:UIColor.black]),
        (" (\(votingArray.count))",[NSAttributedString.Key.foregroundColor:UIColor.gray])
        ]
        cell.textLabel?.attributedText = NSMutableAttributedString(stringsInfos: infos)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let votingArray = self.lectureArray[indexPath.row]["votings"] as? [[String:Any]] ?? [[String:Any]]()
        let name = self.lectureArray[indexPath.row]["name"] as? String ?? ""
        let lectureSid = self.lectureArray[indexPath.row]["sid"] as? String ?? ""
        
        
        
        
        let votingListVC = VotingListViewController()
        votingListVC.votingArray = votingArray
        votingListVC.name = name
        votingListVC.lectrueSid = lectureSid
        appDel.stackedViewController?.pushViewController(votingListVC, from: self, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "삭제") { (action : UITableViewRowAction, indexPath : IndexPath) in
            
            let name = self.lectureArray[indexPath.row]["name"] as? String ?? ""

            if LECTURE_DELETE_OPTION {
                                
                let noAction = UIAlertAction(title: "아니오", style: .default, handler: { (action) in
                    
                })
                let yesAction = UIAlertAction(title: "예", style: .destructive, handler: { (action) in
                    if let sid = self.lectureArray[indexPath.row]["sid"] as? String {
                        let urlString = "\(LECTURE_DEL)?sid=\(sid)&room=\(room)"
                        appDel.showHud()
                        Server.postData(urlString: urlString, completion: { (kData : Data?) in
                            appDel.hideHud()
                            if let data = kData {
                                if let dataString = data.toString() {
                                    if dataString == "Y" {
                                        self.lectureArray.remove(at: indexPath.row)
                                        DispatchQueue.main.async {
                                            self.tableView.beginUpdates()
                                            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                            self.tableView.endUpdates()
                                            
                                            toastShow(message: "\(name) 강의가 삭제되었습니다.")
                                        }
                                    }
                                }
                            }
                        })
                    }
                })
                
                appDel.showAlert(title: "안내", message: "\(name) 강의를 삭제하시겠습니까?", actions: [yesAction,noAction], viewCon: self) {}
            }else{
                if let sid = self.lectureArray[indexPath.row]["sid"] as? String {
                    let urlString = "\(LECTURE_DEL)?sid=\(sid)&room=\(room)"
                    appDel.showHud()
                    Server.postData(urlString: urlString, completion: { (kData : Data?) in
                        appDel.hideHud()
                        if let data = kData {
                            if let dataString = data.toString() {
                                if dataString == "Y" {
                                    self.lectureArray.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        self.tableView.beginUpdates()
                                        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                        self.tableView.endUpdates()
                                        
                                        toastShow(message: "\(name) 강의가 삭제되었습니다.")
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
            
            let name = self.lectureArray[indexPath.row]["name"] as? String ?? ""
            let sid = self.lectureArray[indexPath.row]["sid"] as? String ?? ""
            let addLectureVC = AddLectureViewController()
            addLectureVC.modalPresentationStyle = .overCurrentContext
            addLectureVC.isEdit = true
            addLectureVC.name = name
            addLectureVC.lecutreListVC = self
            addLectureVC.sid = sid
            self.present(addLectureVC, animated: false, completion: {
                
            })
            
            
        }
        return [deleteAction,editAction]
        
    }
}
