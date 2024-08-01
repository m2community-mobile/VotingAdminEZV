//
//  Global.swift
//  VotingAdminEZV
//
//  Created by m2comm on 18/07/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import Foundation

/*
 votingStatus
 0 - 보팅 전
 1 - 보팅 중
 2 - 보팅 후

 
 */

let deepRedColor = #colorLiteral(red: 0.6901960784, green: 0.1411764706, blue: 0.09411764706, alpha: 1)
let deepGreenColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

let CODE = "CODE"
var code : String {
    set(value){
        userD.set(value, forKey: CODE)
        userD.synchronize()
    }
    get{
        return userD.object(forKey: CODE) as? String ?? ""
    }
}

let ROOM = "ROOM"
var room : String {
    set(value){
        userD.set(value, forKey: ROOM)
        userD.synchronize()
    }
    get{
        return userD.object(forKey: ROOM) as? String ?? ""
    }
}


let ID = "ID"
var id : String {
    set(value){
        userD.set(value, forKey: ID)
        userD.synchronize()
    }
    get{
        return userD.object(forKey: ID) as? String ?? ""
    }
}

let PW = "PW"
var pw : String {
    set(value){
        userD.set(value, forKey: PW)
        userD.synchronize()
    }
    get{
        return userD.object(forKey: PW) as? String ?? ""
    }
}

var LECTURE_LIST : String {
    get{
        let url = "\(appDel.rootURL)php/voting/app/lectureList.php"
        print("LECTURE_LIST:\(url)")
        return url
    }
}
var LECTURE_RESET : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/resetLecture.php"
        print("LECTURE_RESET:\(url)")
        return url
    }
}
var LECTURE_POST : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/postLecture.php"
        print("LECTURE_POST:\(url)")
        return url
    }
}
var LECTURE_DEL : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/delLecture.php"
        print("LECTURE_DEL:\(url)")
        return url
    }
}

var VOTING_LIST : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/votingList.php"
        print("VOTING_LIST:????\(url)")
        return url
        
    }
    
}
var VOTING_ADD : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/addVoting.php"
        print("VOTING_ADD:\(url)")
        return url
        
    }
    
}
var VOTING_ADD_QUICK : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/addVotingQuick.php"
        print("VOTING_ADD_QUICK:\(url)")
        return url
        
    }
    
}
var VOTING_DEL : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/del.php"
        print("VOTING_DEL:\(url)")
        return url
        
    }
    
}
var VOTING_RESULT : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/refresh.php"
//        let url = "https://kaim.or.kr/admin/workshop/php/voting/app/refresh.php"
        print("VOTING_RESULT:\(url)")
        return url
        
    }
    
}
var VOTING_START : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/start.php"
        print("VOTING_START:\(url)")
        return url
        
    }
    
}
var VOTING_END : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/end.php"
        print("VOTING_END:\(url)")
        return url
        
    }
    
}
var VOTING_RESET : String {
    get {
        let url = "\(appDel.rootURL)php/voting/app/reset.php"
        print("VOTING_RESET:\(url)")
        return url
        
    }
    
}

var QUESTION_LIST : String {
    get {
        let url = "\(appDel.rootURL)php/question/app/list.php"
        print("QUESTION_LIST:\(url)")
        return url
        
    }
    
}
var QUESTION_DEL : String {
    get {
        let url = "\(appDel.rootURL)php/question/app/del.php"
        print("QUESTION_DEL:\(url)")
        return url
        
    }
    
}

var QUESTION_HIDE : String {
    get {
        let url = "\(appDel.rootURL)php/question/app/hide.php"
        print("QUESTION_HIDE:\(url)")
        return url
        
    }
    
}

var QUESTION_GET : String {
    get {
        let url = "\(appDel.rootURL)php/question/app/get.php"
        print("QUESTION_GET:\(url)")
        return url
        
    }
    
}
var QUESTION_RESET : String {
    get {
        let url = "\(appDel.rootURL)php/question/app/reset.php"
        print("QUESTION_RESET:\(url)")
        return url
        
    }
    
}
var QUESTION_SET : String {
    get {
        let url = "\(appDel.rootURL)php/question/app/set.php"
        print("QUESTION_SET:\(url)")
        return url
    }
    
}




















struct URL_KEY {
    
    
    //https://webinar.katrdic.org/php/question/app/list.php
//    static let LECTURE_LIST = "http://ezv.kr/voting/php/voting/app/lectureList.php"
//    static let LECTURE_RESET = "http://ezv.kr/voting/php/voting/app/resetLecture.php"
//    static let LECTURE_POST = "http://ezv.kr/voting/php/voting/app/postLecture.php"
//    static let LECTURE_DEL = "http://ezv.kr/voting/php/voting/app/delLecture.php"

    
//    static let VOTING_LIST = "http://ezv.kr/voting/php/voting/app/votingList.php"
//    static let VOTING_ADD = "http://ezv.kr/voting/php/voting/app/addVoting.php"
//    static let VOTING_ADD_QUICK = "http://ezv.kr/voting/php/voting/app/addVotingQuick.php"
//    static let VOTING_DEL = "http://ezv.kr/voting/php/voting/app/del.php"
//    static let VOTING_RESULT = "http://ezv.kr/voting/php/voting/app/refresh.php"
//    static let VOTING_START = "http://ezv.kr/voting/php/voting/app/start.php"
//    static let VOTING_END = "http://ezv.kr/voting/php/voting/app/end.php"
//    static let VOTING_RESET = "http://ezv.kr/voting/php/voting/app/reset.php"
//
//    static let QUESTION_LIST = "http://ezv.kr/voting/php/question/app/list.php"
//    static let QUESTION_DEL = "http://ezv.kr/voting/php/question/app/del.php"
//    static let QUESTION_GET = "http://ezv.kr/voting/php/question/app/get.php"
//    static let QUESTION_RESET = "http://ezv.kr/voting/php/question/app/reset.php"
//    static let QUESTION_SET = "http://ezv.kr/voting/php/question/app/set.php"
    
}


//SettingValue

let QUESTION_SELECT_HIDE_OPTION_KEY = "QUESTION_SELECT_HIDE_OPTION_KEY"
var QUESTION_SELECT_HIDE_OPTION : Bool {
    set(value){
        userD.set(value, forKey: QUESTION_SELECT_HIDE_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let value = userD.bool(forKey: QUESTION_SELECT_HIDE_OPTION_KEY)
        return value
    }
}

//questionSelectCheckOptionSwitchValueChanged
let QUESTION_SELECT_OPTION_KEY = "QUESTION_SELECT_OPTION_KEY"
var QUESTION_SELECT_OPTION : Bool {
    set(value){
        userD.set(value, forKey: QUESTION_SELECT_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let value = userD.bool(forKey: QUESTION_SELECT_OPTION_KEY)
        return value
    }
}

let SHOW_LECTURE_LABEL_KEY = "SHOW_LECTURE_LABEL_KEY"
var SHOW_LECTURE_LABEL : Bool {
    set(value){
        userD.set(value, forKey: SHOW_LECTURE_LABEL_KEY)
        userD.synchronize()
    }
    get{
        let value = userD.bool(forKey: SHOW_LECTURE_LABEL_KEY)
        return value
    }
}
let SHOW_QUESTION_SELECT_BUTTON_KEY = "SHOW_QUESTION_SELECT_BUTTON_KEY"
var SHOW_QUESTION_SELECT_BUTTON : Bool {
    set(value){
        userD.set(value, forKey: SHOW_QUESTION_SELECT_BUTTON_KEY)
        userD.synchronize()
    }
    get{
        let value = userD.bool(forKey: SHOW_QUESTION_SELECT_BUTTON_KEY)
        return value
    }
}






let LECTURE_LABEL_STRING_KEY = "LECTURE_LABEL_STRING_KEY"
var LECTURE_LABEL_STRING : String {
    set(value){
        userD.set(value, forKey: LECTURE_LABEL_STRING_KEY)
        userD.synchronize()
    }
    get{
        if let value = userD.string(forKey: LECTURE_LABEL_STRING_KEY) {
            return value
        }else{
            let value = "강의명"
            userD.set(value, forKey: LECTURE_LABEL_STRING_KEY)
            userD.synchronize()
            return value
        }
    }
}


let VOTING_COUNT_KEY = "VOTING_COUNT_KEY"
var VOTING_COUNT : Int {
    set(value){
        userD.set("\(value)", forKey: VOTING_COUNT_KEY)
        userD.synchronize()
    }
    get{
        if let value = userD.string(forKey: VOTING_COUNT_KEY){
            return value.toInt() ?? 5
        }else{
            userD.set("5", forKey: VOTING_COUNT_KEY)
            userD.synchronize()
            return 5
        }
    }
}
let MAX_FONT_SIZE : CGFloat = 30
let MIN_FONT_SIZE : CGFloat = 17

let FONT_SIZE_KEY = "FONT_SIZE_KEY"
var FONT_SIZE : CGFloat {
    set(value){
        userD.set("\(value)", forKey: FONT_SIZE_KEY)
        userD.synchronize()
    }
    get{
        if let value = userD.string(forKey: FONT_SIZE_KEY){
            return value.toCGFloat() ?? MIN_FONT_SIZE
        }else{
            userD.set("\(MIN_FONT_SIZE)", forKey: FONT_SIZE_KEY)
            userD.synchronize()
            return MIN_FONT_SIZE
        }
    }
}


let VOTING_RESULT_OPTION_KEY = "VOTING_RESULT_OPTION_KEY"
enum votingResultOption : Int {
    case none = 0
    case percent = 1
    case number = 2
}
var VOTING_RESULT_OPTION : votingResultOption {
    set(value){
        userD.set("\(value.rawValue)", forKey: VOTING_RESULT_OPTION_KEY)
        userD.synchronize()
    }
    get{
        if let value = userD.string(forKey: VOTING_RESULT_OPTION_KEY){
            let valueOfInt = value.toInt() ?? 1
            return votingResultOption(rawValue: valueOfInt) ?? votingResultOption.none
        }else{
            userD.set("1", forKey: VOTING_RESULT_OPTION_KEY)
            userD.synchronize()
            return votingResultOption.percent
        }
    }
}

let LECTURE_DELETE_OPTION_KEY = "LECTURE_DELETE_OPTION_KEY"
var LECTURE_DELETE_OPTION : Bool {
    set(value){
        let saveValue = value ? "1":"0"
        userD.set(saveValue, forKey: LECTURE_DELETE_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let valueString = userD.string(forKey: LECTURE_DELETE_OPTION_KEY) ?? "1"
        return valueString == "1" ? true : false
    }
}

let VOTING_DELETE_OPTION_KEY = "VOTING_DELETE_OPTION_KEY"
var VOTING_DELETE_OPTION : Bool {
    set(value){
        let saveValue = value ? "1":"0"
        userD.set(saveValue, forKey: VOTING_DELETE_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let valueString = userD.string(forKey: VOTING_DELETE_OPTION_KEY) ?? "1"
//            userD.bool(forKey: VOTING_DELETE_OPTION_KEY)
        return valueString == "1" ? true : false
    }
}

let QUESTION_DELETE_OPTION_KEY = "QUESTION_DELETE_OPTION_KEY"
var QUESTION_DELETE_OPTION : Bool {
    set(value){
        let saveValue = value ? "1":"0"
        userD.set(saveValue, forKey: QUESTION_DELETE_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let valueString = userD.string(forKey: QUESTION_DELETE_OPTION_KEY) ?? "1"
//            userD.bool(forKey: QUESTION_DELETE_OPTION)
        return valueString == "1" ? true : false
    }
}

let SEND_STATE_OPTION_KEY = "SEND_STATE_OPTION_KEY"
var SEND_STATE_OPTION : Bool {
    set(value){
        let saveValue = value ? "1":"0"
        userD.set(saveValue, forKey: SEND_STATE_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let valueString = userD.string(forKey: SEND_STATE_OPTION_KEY) ?? "1"
//        let value = userD.bool(forKey: SEND_STATE_OPTION_KEY)
        return valueString == "1" ? true : false
    }
}

let IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION_KEY = "IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION_KEY"
var IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION : Bool {
    set(value){
        let saveValue = value ? "1":"0"
        userD.set(saveValue, forKey: IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION_KEY)
        userD.synchronize()
    }
    get{
        let valueString = userD.string(forKey: IS_SHOW_CORRECT_NUMBER_FROM_VOTING_PREVIEW_OPTION_KEY) ?? "0"
        return valueString == "1" ? true : false
    }
}


let QUESTION_VIEW_ALIGEMENT_OPTION_KEY = "QUESTION_VIEW_ALIGEMENT_OPTION_KEY"

enum questionViewAligmentOption : Int {
    case center = 0
    case top = 1
}
var QUESTION_VIEW_ALIGEMENT_OPTION : questionViewAligmentOption {
    set(value){
        userD.set("\(value.rawValue)", forKey: QUESTION_VIEW_ALIGEMENT_OPTION_KEY)
        userD.synchronize()
    }
    get{
        if let value = userD.string(forKey: QUESTION_VIEW_ALIGEMENT_OPTION_KEY){
            let valueOfInt = value.toInt() ?? 0
            return questionViewAligmentOption(rawValue: valueOfInt) ?? questionViewAligmentOption.center
        }else{
            userD.set("0", forKey: QUESTION_VIEW_ALIGEMENT_OPTION_KEY)
            userD.synchronize()
            return questionViewAligmentOption.center
        }
    }
}

let VOTING_COUNT_OPTION_KEY = "VOTING_COUNT_OPTION_KEY"
enum votingCountOption : Int {
    case increase = 0
    case decrease = 1
}
var VOTING_COUNT_OPTION : votingCountOption {
    set(value){
        userD.set("\(value.rawValue)", forKey: VOTING_COUNT_OPTION_KEY)
        userD.synchronize()
    }
    get{
        if let value = userD.string(forKey: VOTING_COUNT_OPTION_KEY){
            let valueOfInt = value.toInt() ?? 0
            return votingCountOption(rawValue: valueOfInt) ?? votingCountOption.increase
        }else{
            userD.set("0", forKey: VOTING_COUNT_OPTION_KEY)
            userD.synchronize()
            return votingCountOption.increase
        }
    }
}
