//
//  AppDelegate.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var rootURL = "http://ezv.kr/voting/"
//    var rootURL = "https://kaim.or.kr/admin/workshop/php/voting/" //내과
    
    
    
//    var rootURL = "https://lungkorea.org/admin/workshop/" //대한결핵

    
    
    
    
    
    var rootName = "ezv.kr"
    

    
    
    
    var window: UIWindow?

    var loginVC : LoginViewController?
    var naviCon : UINavigationController?
    
    var stackedViewController : PSStackedViewController?
    var mainVC : MainViewController?
    
    var questionListVC : QuestionListViewController?
    var lecutreListVC : LecutreListViewController?
    var votingListVC : VotingListViewController?
    var votingPreviewVC : VotingPreviewViewController?
    
    var chairVC : ChairViewController?
    
    var questionListUpdateTimer : Timer?
    
    var qnaUpdateTimer : Timer?
    
    
    //이때는 question을 업데이트 하지 않는다.
    //QuestionListSettingViewController에 영향을 받는다.
    var isQuestionSetting = false
    
    //QuestionViewController에 영향을 받는다.
    var isQuestionViewShow = false
    
    var isVotingViewShow = false
    
    var isAddLecture = false
    
    var isAddVoting = false
    
    var isEditing = false
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        print("FONT_SIZE:\(FONT_SIZE)")
        
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        SoundCenter.shared.prepare()
        DeviceCenter.shared.timerStart()
        addKeyboardObserver()
        NetworkManager.shared.startNetworkReachabilityObserver()
        
        window = UIWindow(frame: SCREEN.BOUND)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        #if targetEnvironment(macCatalyst)
            print("UIKit running on macOS")
        #else
            print("Your regular code")
        #endif
        
        
        loginVC = LoginViewController()
        naviCon = UINavigationController(rootViewController: loginVC!)
        naviCon?.isNavigationBarHidden = true
        window?.rootViewController = naviCon

        window?.makeKeyAndVisible()
        
        

        
        
        return true
    }
    func questionListUpdateTimerStop(){
        self.questionListUpdateTimer?.invalidate()
    }
    
    var questionListUpdateRequest : DataRequest?
    func questionListUpdateTimerStart(){
        /* 테이블뷰 새로고침때도 사용 */
        
        //기존 타이머 제거
        self.questionListUpdateTimer?.invalidate()
        
        //업데이트 실행
        self.questionListUpdate()
        
        //3초마다 업데이트 재 실행
        self.questionListUpdateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.questionListUpdate), userInfo: nil, repeats: true)
    }

    @objc func questionListUpdate(){

//        self.questionListUpdateRequest?.cancel()

        if let isQuestionEditing = appDel.questionListVC?.tableView.isEditing, isQuestionEditing { return }
        if let isLectureEditing = appDel.lecutreListVC?.tableView.isEditing, isLectureEditing { return }
        if let isVotingListEditing = appDel.votingListVC?.tableView.isEditing, isVotingListEditing { return }
        
        if isQuestionSetting { return }
        if isQuestionViewShow { return }
        if isVotingViewShow { return }
        if isAddLecture { return }
        if isAddVoting { return }
        if isEditing { return }
        
        if let naviConCount = self.naviCon?.viewControllers.count, naviConCount == 1 { return }

        
        
        let urlStirng = "\(QUESTION_LIST)?code=\(code)&room=\(room)"
        
        self.questionListUpdateRequest = Server.postData(urlString: urlStirng) { (kData : Data?) in
            if let data = kData {
                print("qna data : \(data.toString())")
                
                if let dataArray = data.toJson() as? [[String:Any]] {
//                    NSLog("question List Update")
//                    print("\n\ndataArray:\(dataArray)\n\n")
                    appDel.mainVC?.questionListUpdate(questionArray: dataArray)
                    
                    appDel.questionListVC?.questionArray = dataArray
                    appDel.questionListVC?.tableView.reloadData()
                    
                    appDel.chairVC?.questionArray = dataArray
                    appDel.chairVC?.tableView.reloadData()
                    
                    
                    return
                }
//                print("QUESTION_LIST is empty")
                appDel.mainVC?.questionListUpdate(questionArray: [[String:Any]]())
                
                appDel.questionListVC?.questionArray = [[String:Any]]()
                appDel.questionListVC?.tableView.reloadData()
                
                appDel.chairVC?.questionArray = [[String:Any]]()
                appDel.chairVC?.tableView.reloadData()
            }
        }
        
    }
  
    
    func lectureListEndEditing(){
        self.lecutreListVC?.tableView.isEditing = false
        self.lecutreListVC?.tableView.reloadData()
        self.lecutreListVC?.editButton.setTitle("편집", for: .normal)
        
    }
    func votingListEndEditing(){
        self.votingListVC?.tableView.isEditing = false
        self.votingListVC?.tableView.reloadData()
        self.votingListVC?.editButton.setTitle("편집", for: .normal)
        
    }

}


class SoundCenter: NSObject {

    static let shared : SoundCenter = {
        let sharedCenter = SoundCenter()
        return sharedCenter
    }()
    
    var player: AVAudioPlayer?
    
    func prepare(){
        guard let url = Bundle.main.url(forResource: "count", withExtension: "wav") else {
            print("prepare fail")
            return
            
        }
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        player?.volume = 1
        player?.prepareToPlay()
    }
    
    func playSound() {
        player?.play()
        print("SoundCenter.shared.playSound()")
    }
    
    
}

