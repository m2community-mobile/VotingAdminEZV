//
//  ChairViewController.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 30/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

var setLabel = UILabel()
var initLabel = UILabel()

class ChairViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleBackView: UIView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var initializeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var logOutButtonView: UIView!

    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    

    var isChecked = true
    
    var seletedSid = ""
    
    var questionArray = [[String:Any]]()
    var heightInfo = [String:CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel.chairVC = self

        self.titlelabel.backgroundColor = UIColor.clear
        
        
        tableView.register(UINib(nibName: "ChairTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ChairTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.initializeButton.backgroundColor = UIColor.clear
        self.initializeButton.layer.cornerRadius = 5
        self.initializeButton.layer.borderWidth = 0.5
        self.initializeButton.layer.borderColor = UIColor.white.cgColor
        
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
        
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(tapGestureFunc))
        tapGesutre.numberOfTapsRequired = 5
        logOutButtonView.addGestureRecognizer(tapGesutre)
        
        questionSelectHideOptionUpdate()
        
        appDel.questionListUpdateTimerStart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveTestNotification(_:)), name: NSNotification.Name("change"), object: nil)

        if lanLabel.text == nil {
            settingButton.setTitle("설정", for: .normal)
        } else {
            settingButton.setTitle(setLabel.text, for: .normal)
        }
        
        if lanLabel.text == nil {
            initializeButton.setTitle("초기화", for: .normal)
        } else {
            initializeButton.setTitle(initLabel.text, for: .normal)
        }

    }
    
    
    @objc func didRecieveTestNotification(_ notification: Notification) {
            print("Test Notification")
    
        if lanLabel.text == "한국어" {
            settingButton.setTitle("설정", for: .normal)
            UserDefaults.standard.set(settingButton.titleLabel?.text, forKey: "koset")
            
            let test = UILabel()
            test.text = UserDefaults.standard.string(forKey: "koset")
            print("test---:\(test.text)")
            
            if test.text == "Setting" {
                settingButton.titleLabel?.text = "설정"
                
                UserDefaults.standard.set(settingButton.titleLabel?.text, forKey: "setting")
                setLabel.text = UserDefaults.standard.string(forKey: "setting")
                print("\(setLabel.text)")
            }
                
                
            initializeButton.setTitle("초기화", for: .normal)
            UserDefaults.standard.set(initializeButton.titleLabel?.text, forKey: "koinit")
            
            let initTest = UILabel()
            initTest.text = UserDefaults.standard.string(forKey: "koinit")
            print("initTest---:\(initTest.text)")
            
            if initTest.text == "Reset" {
                initializeButton.titleLabel?.text = "초기화"
                
                UserDefaults.standard.set(initializeButton.titleLabel?.text, forKey: "initTest")
                initLabel.text = UserDefaults.standard.string(forKey: "initTest")
                print("\(initLabel.text)")
            }
            
        }
        
        if lanLabel.text == "English" {
            settingButton.setTitle("Setting", for: .normal)
            UserDefaults.standard.set(settingButton.titleLabel?.text, forKey: "set")
            
            let test = UILabel()
            test.text = UserDefaults.standard.string(forKey: "set")
            print("test---:\(test.text)")
            
            if test.text == "설정" {
                settingButton.titleLabel?.text = "Setting"
               
                UserDefaults.standard.set(settingButton.titleLabel?.text, forKey: "setting")
                setLabel.text = UserDefaults.standard.string(forKey: "setting")
                print("\(setLabel.text)")
            }
            
            
            initializeButton.setTitle("Reset", for: .normal)
            UserDefaults.standard.set(initializeButton.titleLabel?.text, forKey: "init")
            
            let initTest = UILabel()
            initTest.text = UserDefaults.standard.string(forKey: "init")
            print("initTest---:\(initTest.text)")
            
            if initTest.text == "초기화" {
                initializeButton.titleLabel?.text = "Reset"
                
                UserDefaults.standard.set(initializeButton.titleLabel?.text, forKey: "initTest")
                initLabel.text = UserDefaults.standard.string(forKey: "initTest")
                print("\(initLabel.text)")
            }
        }
    
    }

    @objc func tapGestureFunc(gesture : UITapGestureRecognizer) {
        let alertCon = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alertCon.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { (action) in
            
        }))
        alertCon.addAction(UIAlertAction(title: "예", style: .default, handler: { (action) in
            appDel.naviCon?.popToRootViewController(animated: true)
            appDel.questionListUpdateTimerStop()
        }))
        self.present(alertCon, animated: true, completion: {
            
        })
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        
        var nextFontSize = FONT_SIZE + 1
        nextFontSize = min(nextFontSize, MAX_FONT_SIZE)
        nextFontSize = max(nextFontSize, MIN_FONT_SIZE)
        FONT_SIZE = nextFontSize
        
        self.tableView.reloadData()
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        
        var nextFontSize = FONT_SIZE - 1
        nextFontSize = min(nextFontSize, MAX_FONT_SIZE)
        nextFontSize = max(nextFontSize, MIN_FONT_SIZE)
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
        questionListSettingVC.preferredContentSize = CGSize(width: 360, height: 250) //200
        #if targetEnvironment(macCatalyst)
        questionListSettingVC.preferredContentSize = CGSize(width: 360, height: 260) //210
        #endif
        let presentVC = questionListSettingVC.presentationController as! UIPopoverPresentationController
        presentVC.sourceView = sender
        presentVC.sourceRect = sender.bounds
        presentVC.permittedArrowDirections = [.up]
        self.present(questionListSettingVC, animated: true, completion: {
            
        })
        
    }
    
        
    
    
    @objc func tableViewRefresh(refreshCon : UIRefreshControl ){
        appDel.questionListUpdateTimerStart()
        refreshCon.endRefreshing()
    }

}

extension ChairViewController : UITableViewDelegate, UITableViewDataSource, ChairTableViewCellDelegate {
    
    
    
    // 버튼 전달하기
    func ChairTableViewCell(_ cell: ChairTableViewCell, indexPath: IndexPath, selectButtonPressed: UIButton) {
        
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
        
        return self.questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChairTableViewCell", for: indexPath) as! ChairTableViewCell
        cell.selectionStyle = .none

        cell.indexPath = indexPath
        cell.delegate = self
        
        //2020.06.30 추가
        cell.selectButton.isHidden = QUESTION_SELECT_HIDE_OPTION
        cell.selectButtonLabelBackView.isHidden = QUESTION_SELECT_HIDE_OPTION
        cell.selectButtonLabel.isHidden = QUESTION_SELECT_HIDE_OPTION
        
        let question = self.questionArray[indexPath.row]["question"] as? String ?? ""
        let sid = self.questionArray[indexPath.row]["sid"] as? String ?? ""

        let cellHeight = cell.questionUpdate(question: question)
        self.heightInfo[sid] = cellHeight

        ////
        let signdate = self.questionArray[indexPath.row]["signdate"] as? String ?? ""
        if let cgfloat_signdate = signdate.toCGFloat() {
            let targetDate = Date(timeIntervalSince1970: TimeInterval(cgfloat_signdate))
            cell.timeLabel.text = DateCenter.shared.dateToStringWithFormat(formatString: "YYYY/MM/dd HH:mm", date: targetDate)
        }else{
            cell.timeLabel.text = ""
        }

        cell.lectureLabel.text = self.questionArray[indexPath.row]["lecture"] as? String ?? ""
        
        let isView = self.questionArray[indexPath.row]["view"] as? String ?? ""
        cell.isButtonSelected = isView == "Y"
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sid = self.questionArray[indexPath.row]["sid"] as? String ?? ""
        if let cellHeight = self.heightInfo[sid] {
            return cellHeight
        }
        
        return 155
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let sid = self.questionArray[indexPath.row]["sid"] as? String ?? ""
        if let cellHeight = self.heightInfo[sid] {
            return cellHeight
        }
        
        return 155
    }
    
    
    
 }

extension ChairViewController {
    func questionSelectHideOptionUpdate(){
        self.initializeButton.isHidden = QUESTION_SELECT_HIDE_OPTION
        self.minusButton.frame.origin.x = QUESTION_SELECT_HIDE_OPTION ? 612 : 536
        self.plusButton.frame.origin.x = QUESTION_SELECT_HIDE_OPTION ? 655 : 579
    }
}
