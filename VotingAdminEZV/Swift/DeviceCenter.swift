//
//  DeviceCenter.swift
//  VotingAdminEZV
//
//  Created by JinGu's iMac on 2021/04/19.
//  Copyright © 2021 m2community. All rights reserved.
//

import UIKit
import Alamofire


class DeviceCenter: NSObject {
   
    static let shared : DeviceCenter = {
        let sharedCenter = DeviceCenter()
        return sharedCenter
    }()
    
    var timer : Timer?
    var request : DataRequest?
    
    func timerStop(){
        self.timer?.invalidate()

    }
    
    func timerStart(){
        
        timerStop()
        
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.monitoring), userInfo: nil, repeats: true)

    }
    
    @objc func monitoring(){
        
        if !SEND_STATE_OPTION { return }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        print("batteryLevel:\(batteryLevel)")
        
        var batteryState = ""
        switch UIDevice.current.batteryState {
        case .unplugged:
            batteryState = "unplugged"
        case .charging:
            batteryState = "charging"
        case .full:
            batteryState = "full"
        case .unknown:
            batteryState = "unknown"
        }
        
        
        let deviceName = UIDevice.current.name
        

        let urlStirng = "https://ezv.kr:4447/voting/php/ipad/setState.php"
        var dataDic = [
            "deviceName":deviceName,
            "modelName":UIDevice.modelName,
            "batteryLevel":"\(batteryLevel)",
            "batteryState":batteryState,
            "deviceid":deviceID,
            
            "serverName":appDel.rootName,
            "serverURL":appDel.rootURL,
            "room":room,
            "code":code,
            "id":id,
        ]
        var isLogin = false
        if let naviConCount = appDel.naviCon?.viewControllers.count, naviConCount > 1 {
            isLogin = true
        }
        dataDic["isLogin"] = isLogin ? "Y":"N"
        
        
        dataDic["questionSelectHideOption"] = (QUESTION_SELECT_HIDE_OPTION ? "숨김":"보임")
        
        //질문 선택시 확인하기
        dataDic["questionSelectOption"] = QUESTION_SELECT_OPTION ? "확인하기":"확인하지 않기"
        
        //질문목록에 Lecture 보이기
        dataDic["showLectureLabel"] = SHOW_LECTURE_LABEL ? "보이기":"숨기기"
        
        dataDic["lectureLabelString"] = LECTURE_LABEL_STRING
        
        dataDic["votingCount"] = "\(VOTING_COUNT)"
        
        dataDic["fontSize"] = "\(FONT_SIZE)"
        
        if VOTING_RESULT_OPTION == .none { dataDic["votingResultOption"] = "none" }
        else if VOTING_RESULT_OPTION == .number { dataDic["votingResultOption"] = "number" }
        else if VOTING_RESULT_OPTION == .percent { dataDic["votingResultOption"] = "percent" }
        
        if QUESTION_VIEW_ALIGEMENT_OPTION == .top { dataDic["questionViewAligmentOption"] = "top" }
        else if QUESTION_VIEW_ALIGEMENT_OPTION == .center { dataDic["questionViewAligmentOption"] = "center" }
        
        if VOTING_COUNT_OPTION == .decrease { dataDic["votingCountOption"] = "decrease" }
        else if VOTING_COUNT_OPTION == .increase { dataDic["votingCountOption"] = "increase" }
        
        dataDic["network"] = NetworkManager.shared.status == .ethernetOrWiFi ? "WiFi":"LTE"
        
        print("dataDic:\(dataDic)")

        self.request?.cancel()
        self.request = Server.postData(urlString: urlStirng, method: .post, otherInfo: dataDic) { (kData : Data?) in
            if let data = kData {
                if let dataString = data.toString() {
                    print("monitoring : \(dataString)")
                }
            }
        }
        
        
    }
    
}


public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
                
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
                
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4","iPad13,5","iPad13,6","iPad13,7":return "iPad Pro (11-inch) (3nd generation)" //2021.06.02 추가
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9","iPad13,10","iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"  //2021.06.02 추가
                
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

