//
//  QuestionListViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 25/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit




class QuestionListViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleBackView: UIView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var initializeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var roomSelectButton: UIButton!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    
    
    
    var questionArray = [[String:Any]]()
    var heightInfo = [String:CGFloat]()
    
    var selectedSids = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.titlelabel.backgroundColor = UIColor.clear
        
        tableView.register(UINib(nibName: "QuestionListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "QuestionListViewCell")
        tableView.register(UINib(nibName: "ChairTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ChairTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.initializeButton.backgroundColor = UIColor.clear
        self.initializeButton.layer.cornerRadius = 5
        self.initializeButton.layer.borderWidth = 0.5
        self.initializeButton.layer.borderColor = UIColor.white.cgColor
        self.initializeButton.isHidden = !SHOW_QUESTION_SELECT_BUTTON
        
        self.editButton.backgroundColor = UIColor.clear
        self.editButton.layer.cornerRadius = 5
        self.editButton.layer.borderWidth = 0.5
        self.editButton.layer.borderColor = UIColor.white.cgColor
        
        self.deleteButton.backgroundColor = UIColor.clear
        self.deleteButton.layer.cornerRadius = 5
        self.deleteButton.layer.borderWidth = 0.5
        self.deleteButton.layer.borderColor = UIColor.white.cgColor
        self.deleteButton.isHidden = true
        
        self.hideButton.backgroundColor = UIColor.clear
        self.hideButton.layer.cornerRadius = 5
        self.hideButton.layer.borderWidth = 0.5
        self.hideButton.layer.borderColor = UIColor.white.cgColor
        self.hideButton.isHidden = true
        
        self.roomSelectButton.backgroundColor = UIColor.clear
        self.roomSelectButton.layer.cornerRadius = 5
        self.roomSelectButton.layer.borderWidth = 0.5
        self.roomSelectButton.layer.borderColor = UIColor.white.cgColor
//        self.roomSelectButton.isHidden = !SHOW_ROOM_SELECT_BUTTON
        self.roomSelectButton.isHidden = true //보류
        
        
        self.closeButton.backgroundColor = UIColor.clear
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.layer.borderWidth = 0.5
        self.closeButton.layer.borderColor = UIColor.white.cgColor
        
        self.settingButton.backgroundColor = UIColor.clear
        self.settingButton.layer.cornerRadius = 5
        self.settingButton.layer.borderWidth = 0.5
        self.settingButton.layer.borderColor = UIColor.white.cgColor
        
        self.plusButton.backgroundColor = UIColor.clear
        self.plusButton.layer.cornerRadius = 5
        self.plusButton.layer.borderWidth = 0.5
        self.plusButton.layer.borderColor = UIColor.white.cgColor
        
        self.minusButton.backgroundColor = UIColor.clear
        self.minusButton.layer.cornerRadius = 5
        self.minusButton.layer.borderWidth = 0.5
        self.minusButton.layer.borderColor = UIColor.white.cgColor
        
        
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 1, height: 1)
        backView.layer.shadowRadius = 5
        backView.layer.shadowOpacity = 0.7
        
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        var titleLabelBackgroundColors = [UIColor]()
        for i in 0..<5 {
            
            titleLabelBackgroundColors.append(#colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1).removeBrightness(val: 0.1 * CGFloat(i)))
        }
        titleBackView.setGradientBackgroundColor(colors: titleLabelBackgroundColors)
        
        
        let refreshCon = UIRefreshControl()
        refreshCon.addTarget(self, action: #selector(tableViewRefresh(refreshCon:)), for: .valueChanged)
        self.tableView.addSubview(refreshCon)
        
    }
    
    override var isEditing: Bool {
        didSet{
            self.editButton.setTitle(self.isEditing ? "편집완료" : "편집", for: .normal)
            appDel.isEditing = self.isEditing
            
            self.deleteButton.isHidden = !self.isEditing
            self.hideButton.isHidden = !self.isEditing
//            self.roomSelectButton.isHidden = !SHOW_ROOM_SELECT_BUTTON
            //보류
            
            selectedSids = Set<String>()
            tableView.reloadData()
        }
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        if SHOW_QUESTION_SELECT_BUTTON {
            return
        }
        
        self.isEditing = !self.isEditing
        
//        self.tableView.isEditing = !self.tableView.isEditing
//        sender.setTitle(self.tableView.isEditing ? "편집완료" : "편집", for: .normal)
        
        
    }
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: false) { }
        
//        appDel.questionListView = nil
//
//        UIView.animate(withDuration: 0.3, animations: {
//            self.alpha = 0
//        }) { (fi) in
//
//        }
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        print(#function)
        
        var nextFontSize = FONT_SIZE + 1
        nextFontSize = min(nextFontSize, 30)
        nextFontSize = max(nextFontSize, 17)
        FONT_SIZE = nextFontSize
        
        self.tableView.reloadData()
        
    }
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        print(#function)
        
        var nextFontSize = FONT_SIZE - 1
        nextFontSize = min(nextFontSize, 30)
        nextFontSize = max(nextFontSize, 17)
        FONT_SIZE = nextFontSize
        
        self.tableView.reloadData()
    }

    
    @IBAction func initializeButtonPressed(_ sender: UIButton) {
        
        let urlString = "\(QUESTION_RESET)?code=\(code)&room=\(room)"
        Server.postData(urlString: urlString) { (kData : Data?) in
            appDel.questionListUpdateTimerStart()
        }
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        // 요기
        let questionListSettingVC = QuestionListSettingViewController()
        questionListSettingVC.modalPresentationStyle = .popover
        questionListSettingVC.preferredContentSize = CGSize(width: 360, height: 250) //250
        #if targetEnvironment(macCatalyst)
        questionListSettingVC.preferredContentSize = CGSize(width: 360, height: 260) //260
        #endif
        let presentVC = questionListSettingVC.presentationController as! UIPopoverPresentationController
        presentVC.sourceView = sender
        presentVC.sourceRect = sender.bounds
        presentVC.permittedArrowDirections = [.up]
        presentVC.presentedView?.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        if #available(iOS 13.0, *) {
//            presentVC.popoverBackgroundViewClass = DDPopoverBackgroundView.self
//            presentVC.backgroundColor = UIColor.white
        }
        
        
        
        
        self.present(questionListSettingVC, animated: true, completion: {
            
        })
        
        
//        _popoverController = UIPopoverController(contentViewController: navController)
//            _popoverController?.delegate = self
//
//            let rect = slotCollectionView.cellForItem(at: indexPath)!.frame
//
//            self._popoverController!.contentSize = CGSize(width: 350, height: 600)
//
//            self._popoverController!.backgroundViewClass = DDPopoverBackgroundView.self
//            self._popoverController!.backgroundColor = UIColor.init(rgb: Int(quaternaryColorHexa)) //arrow color
//
//            OperationQueue.main.addOperation({
//                self._popoverController?.present(from: rect, in: self.slotCollectionView, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
//            })
        
    }
    
    var selectedRoom = "" {
        willSet(newSelectedRoom) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func roomSelectButtonPressed(_ sender: UIButton) {
        self.roomListUpdate { (roomList : [String]) in
            let alertCon = UIAlertController(title: "룸 선택", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alertCon.addAction(UIAlertAction(title: "all", style: UIAlertAction.Style.default, handler: { (action) in
                self.selectedRoom = ""
            }))
            for i in 0..<roomList.count {
                alertCon.addAction(UIAlertAction(title: roomList[i], style: UIAlertAction.Style.default, handler: { (action) in
                    self.selectedRoom = roomList[i]
                }))
            }
            alertCon.modalPresentationStyle = .popover
            alertCon.preferredContentSize = CGSize(width: 100, height: 100 * CGFloat(roomList.count + 1))
            let presentVC = alertCon.presentationController as! UIPopoverPresentationController
            presentVC.sourceView = sender
            presentVC.sourceRect = sender.bounds
            presentVC.permittedArrowDirections = [.up, .left]
            DispatchQueue.main.async {
                self.present(alertCon, animated: true) {}
            }
        }
    }
    
    /*
     Dictionary(grouping: statEvents, by: { $0.name })
     [
       "dinner": [
         StatEvents(name: "dinner", date: "01-01-2015", hours: 1),
         StatEvents(name: "dinner", date: "01-01-2015", hours: 1),
         StatEvents(name: "dinner", date: "01-01-2015", hours: 1)
       ],
       "lunch": [
         StatEvents(name: "lunch", date: "01-01-2015", hours: 1),
         StatEvents(name: "lunch", date: "01-01-2015", hours: 1)
     ]
     */
    
    
    func roomListUpdate(complete:@escaping(_ roomList:[String]) -> Void){
        
        let roomArray = self.questionArray.map { (ele : [String : Any]) -> String in
            return ele["room"] as? String ?? ""
        }
        
        let keys = Dictionary(grouping: roomArray, by: { $0 }).keys
        let roomList = Array(keys).sorted()

        if roomList.count == 1 { return complete([])}
        complete(roomList)
    }
    
    @objc func tableViewRefresh(refreshCon : UIRefreshControl ){
        appDel.questionListUpdateTimerStart()
        refreshCon.endRefreshing()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        if QUESTION_DELETE_OPTION {
            let noAction = UIAlertAction(title: "아니오", style: .default, handler: { (action) in
                
            })
            let yesAction = UIAlertAction(title: "예", style: .destructive, handler: { (action) in
                appDel.showHud()
                self.deleteSids {
                    appDel.hideHud()
                    self.editButtonPressed(self.editButton)
                    appDel.questionListUpdate()
                }
            })
            appDel.showAlert(title: "안내", message: "질문을 삭제하시겠습니까?", actions: [yesAction,noAction], viewCon: self) {}
        }else{
            appDel.showHud()
            self.deleteSids {
                appDel.hideHud()
                self.editButtonPressed(self.editButton)
                appDel.questionListUpdate()
            }
        }
    }
    func deleteSids(complete:@escaping()->Void){
        
        let sids = Array(self.selectedSids)
        print("sids:\(sids)")
        if sids.count == 0 { complete(); return}
        
        self.delete(sids: sids) { (succes : Bool) in
            
            DispatchQueue.main.async {
                if succes {
                    appDel.showAlert(title: "안내", message: "삭제가 완료되었습니다.")
                }else{
                    appDel.showAlert(title: "안내", message: "통신이 원활하지 않습니다.\n새로고침 해주세요.")
                }
                
            }
            complete()
        }
        
    }
    
    //순환 delete
    func delete(index : Int = 0, sids : [String], complete:@escaping(_ success : Bool)->Void) {
        
        print("delete index:\(index), sids:\(sids) ")
        
        if index >= sids.count {
            print("delete 종료")
            complete(true)
            return
        }
        let sid = sids[index]
        print("delete sid : \(sid)")
        delete(sid: sid) { (success : Bool) in
            if success {
                self.delete(index: index + 1, sids: sids, complete: complete)
                return
            }
            complete(false)
        }
    }
    
    //단일 sid 삭제
    func delete(sid:String, complete:@escaping(_ success : Bool)->Void){
        
        let urlString = "\(QUESTION_DEL)?sid=\(sid)&room=\(room)"
        
        Server.postData(urlString: urlString, completion: { (kData : Data?) in
            if let data = kData {
                if let dataString = data.toString() {
                    if dataString == "Y" {
                        complete(true)
                        return
                    }
                }
            }
            complete(false)
            return
        })
    }
    
    
    @IBAction func hideButtonPressed(_ sender: UIButton) {
        
        if QUESTION_DELETE_OPTION {
            let noAction = UIAlertAction(title: "아니오", style: .default, handler: { (action) in
                
            })
            let yesAction = UIAlertAction(title: "예", style: .destructive, handler: { (action) in
                appDel.showHud()
                self.hideSids {
                    appDel.hideHud()
                    self.editButtonPressed(self.editButton)
                    appDel.questionListUpdate()
                }
            })
            appDel.showAlert(title: "안내", message: "질문을 숨기시겠습니까?", actions: [yesAction,noAction], viewCon: self) {}
        }else{
            appDel.showHud()
            self.hideSids {
                appDel.hideHud()
                self.editButtonPressed(self.editButton)
                appDel.questionListUpdate()
            }
        }
    }
    func hideSids(complete:@escaping()->Void){
        
        let sids = Array(self.selectedSids)
        print("sids:\(sids)")
        if sids.count == 0 { complete(); return}
        
        self.hide(sids: sids) { (succes : Bool) in
            
            DispatchQueue.main.async {
                if succes {
                    appDel.showAlert(title: "안내", message: "숨기기가 완료되었습니다.")
                }else{
                    appDel.showAlert(title: "안내", message: "통신이 원활하지 않습니다.\n새로고침 해주세요.")
                }
                
            }
            complete()
        }
        
    }
    
    //순환 delete
    func hide(index : Int = 0, sids : [String], complete:@escaping(_ success : Bool)->Void) {
        
        print("hide index:\(index), sids:\(sids) ")
        
        if index >= sids.count {
            print("hide 종료")
            complete(true)
            return
        }
        let sid = sids[index]
        print("hide sid : \(sid)")
        hide(sid: sid) { (success : Bool) in
            if success {
                self.hide(index: index + 1, sids: sids, complete: complete)
                return
            }
            complete(false)
        }
    }
    
    //단일 sid 삭제
    func hide(sid:String, complete:@escaping(_ success : Bool)->Void){
        
        let urlString = "\(QUESTION_HIDE)?sid=\(sid)&room=\(room)"
        
        Server.postData(urlString: urlString, completion: { (kData : Data?) in
            if let data = kData {
                if let dataString = data.toString() {
                    if dataString == "Y" {
                        complete(true)
                        return
                    }
                }
            }
            complete(false)
            return
        })
    }
}

extension QuestionListViewController : UITableViewDelegate, UITableViewDataSource, ChairTableViewCellDelegate, QuestionListViewCellDelegate {
    
    func ChairTableViewCell(_ cell: ChairTableViewCell, indexPath: IndexPath, selectButtonPressed: UIButton) {

        var filteredArray = self.questionArray
        
//        if SHOW_ROOM_SELECT_BUTTON && self.selectedRoom != "" {
//            filteredArray = self.questionArray.filter { (dic : [String : Any]) -> Bool in
//                let dicRoom = dic["room"] as? String ?? ""
//                return dicRoom == self.selectedRoom
//            }
//        }//보류
        
//        let sid = filteredArray[indexPath.row]["sid"] as? String ?? ""
//        let urlString = "\(QUESTION_SET)?code=\(code)&room=\(room)&sid=\(sid)"
//        Server.postData(urlString: urlString) { (kData : Data?) in
//            appDel.questionListUpdateTimerStart()
//        }
        
        let isView = self.questionArray[indexPath.row]["view"] as? String ?? ""
        if isView == "Y" { return }
        
        if QUESTION_SELECT_OPTION {
            
            //        let question = self.questionArray[indexPath.row]["question"] as? String ?? ""
            
            let yesAction = UIAlertAction(title: "예", style: .default, handler: { (action : UIAlertAction) in
                let sid = self.questionArray[indexPath.row]["sid"] as? String ?? ""
                let urlString = "\(QUESTION_SET)?code=\(code)&room=\(room)&sid=\(sid)"
                let _ = Server.postData(urlString: urlString) { (kData : Data?) in
                    appDel.questionListUpdateTimerStart()
                }
            })
            let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: { (action : UIAlertAction) in
                appDel.questionListUpdateTimerStart()
            })
            
            //        let alertCon = UIAlertController(title: "안내", message: "이 질문을 선택 하시겠습니까?\n\n\"\(question)\"", preferredStyle: .alert)
            let alertCon = UIAlertController(title: "안내", message: "이 질문을 선택하여 연자에게 전달하시겠습니까?", preferredStyle: .alert)
            
            alertCon.addAction(yesAction)
            alertCon.addAction(cancelAction)
            
            appDel.questionListUpdateTimerStop()
            DispatchQueue.main.async {
                self.present(alertCon, animated: true) {}
            }
        }else{
            let sid = self.questionArray[indexPath.row]["sid"] as? String ?? ""
            let urlString = "\(QUESTION_SET)?code=\(code)&room=\(room)&sid=\(sid)"
            let _ = Server.postData(urlString: urlString) { (kData : Data?) in
                appDel.questionListUpdateTimerStart()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if room == "" && self.selectedRoom != "" {
            return self.questionArray.filter { (dic : [String : Any]) -> Bool in
                let dicRoom = dic["room"] as? String ?? ""
                return dicRoom == self.selectedRoom
            }.count
        }
        
        return self.questionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var filteredArray = self.questionArray
        
//        if SHOW_ROOM_SELECT_BUTTON && self.selectedRoom != "" {
//            filteredArray = self.questionArray.filter { (dic : [String : Any]) -> Bool in
//                let dicRoom = dic["room"] as? String ?? ""
//                return dicRoom == self.selectedRoom
//            }
//        }//보류
        
        if SHOW_QUESTION_SELECT_BUTTON {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChairTableViewCell", for: indexPath) as! ChairTableViewCell
            cell.selectionStyle = .none

            cell.indexPath = indexPath
            cell.delegate = self
            
            let question = filteredArray[indexPath.row]["question"] as? String ?? ""
            let sid = filteredArray[indexPath.row]["sid"] as? String ?? ""

            cell.accessoryType = .none
            
            let cellHeight = cell.questionUpdate(question: question)
            self.heightInfo[sid] = cellHeight

            ////
            let signdate = filteredArray[indexPath.row]["signdate"] as? String ?? ""
            if let cgfloat_signdate = signdate.toCGFloat() {
                let targetDate = Date(timeIntervalSince1970: TimeInterval(cgfloat_signdate))
                cell.timeLabel.text = DateCenter.shared.dateToStringWithFormat(formatString: "YYYY/MM/dd HH:mm", date: targetDate)
            }else{
                cell.timeLabel.text = ""
            }

            cell.lectureLabel.text = filteredArray[indexPath.row]["lecture"] as? String ?? ""
            
            let isView = filteredArray[indexPath.row]["view"] as? String ?? ""
            cell.isButtonSelected = isView == "Y"
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionListViewCell", for: indexPath) as! QuestionListViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            
            let question = filteredArray[indexPath.row]["question"] as? String ?? ""
            let sid = filteredArray[indexPath.row]["sid"] as? String ?? ""
            
            cell.accessoryType = (selectedSids.contains(sid) && isEditing) ? .checkmark : .none
            
            let cellHeight = cell.questionUpdate(question: question)
            self.heightInfo[sid] = cellHeight
                
            let room = filteredArray[indexPath.row]["room"] as? String ?? ""
            cell.roomLabel.text = "\(room)"
            
            ////
            let signdate = filteredArray[indexPath.row]["signdate"] as? String ?? ""
            if let cgfloat_signdate = signdate.toCGFloat() {
                let targetDate = Date(timeIntervalSince1970: TimeInterval(cgfloat_signdate))
                cell.timeLabel.text = DateCenter.shared.dateToStringWithFormat(formatString: "YYYY/MM/dd HH:mm", date: targetDate)
            }else{
                cell.timeLabel.text = ""
            }
            
            cell.lectureLabel.text = filteredArray[indexPath.row]["lecture"] as? String ?? ""
            
            
            return cell
        }
    }
    
    func questionListViewCell(cell: QuestionListViewCell, selected indexPath: IndexPath) {
        

        var filteredArray = self.questionArray
        
//        if SHOW_ROOM_SELECT_BUTTON && self.selectedRoom != "" {
//            filteredArray = self.questionArray.filter { (dic : [String : Any]) -> Bool in
//                let dicRoom = dic["room"] as? String ?? ""
//                return dicRoom == self.selectedRoom
//            }
//        }//보류
        
        if self.isEditing {
            
            let sid = filteredArray[indexPath.row]["sid"] as? String ?? ""
            
            if selectedSids.contains(sid) {
                selectedSids.remove(sid)
            }else{
                selectedSids.insert(sid)
            }
            
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = selectedSids.contains(sid) ? .checkmark : .none
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var filteredArray = self.questionArray
        
//        if SHOW_ROOM_SELECT_BUTTON && self.selectedRoom != "" {
//            filteredArray = self.questionArray.filter { (dic : [String : Any]) -> Bool in
//                let dicRoom = dic["room"] as? String ?? ""
//                return dicRoom == self.selectedRoom
//            }
//        }//보류
        
        let sid = filteredArray[indexPath.row]["sid"] as? String ?? ""
        if let cellHeight = self.heightInfo[sid] {
            return cellHeight
        }
        
        return 155
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      
        var filteredArray = self.questionArray
        
//        if SHOW_ROOM_SELECT_BUTTON && self.selectedRoom != "" {
//            filteredArray = self.questionArray.filter { (dic : [String : Any]) -> Bool in
//                let dicRoom = dic["room"] as? String ?? ""
//                return dicRoom == self.selectedRoom
//            }
//        }//보류
        let sid = filteredArray[indexPath.row]["sid"] as? String ?? ""
        if let cellHeight = self.heightInfo[sid] {
            return cellHeight
        }
        
        return 155
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        var filteredArray = self.questionArray

//        if SHOW_ROOM_SELECT_BUTTON && self.selectedRoom != "" {
//            filteredArray = self.questionArray.filter { (dic : [String : Any]) -> Bool in
//                let dicRoom = dic["room"] as? String ?? ""
//                return dicRoom == self.selectedRoom
//            }
//        }//보류
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { (action : UITableViewRowAction, indexPath : IndexPath) in
            
            if let sid = filteredArray[indexPath.row]["sid"] as? String {
                //?/
                let urlString = "\(QUESTION_DEL)?sid=\(sid)&room=\(room)"
                appDel.showHud()
                Server.postData(urlString: urlString, completion: { (kData : Data?) in
                    appDel.hideHud()
                    if let data = kData {
                        if let dataString = data.toString() {
                            if dataString == "Y" {
                                let indexPaths = [indexPath]
                                filteredArray.remove(at: indexPath.row)
                                DispatchQueue.main.async {
                                    self.tableView.beginUpdates()
                                    self.tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
                                    self.tableView.endUpdates()
                                }
                                
                            }
                        }
                    }
                })
            }
        }
        
        return [deleteAction]
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
//        return tableView.isEditing
    }
    
}
