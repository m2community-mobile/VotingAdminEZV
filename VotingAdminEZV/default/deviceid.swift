import KeychainSwift

let DEVICE_ID  = "DEVICE_ID"
let deviceID : String = {
    print("get deviceID================================================================")
    
    if let kDeviceID = userD.string(forKey: DEVICE_ID) {
        print("userD에 DeviceID가 있으면 사용 : \(kDeviceID)")
        return kDeviceID
    }else if let kDeviceID = KeychainSwift().get(DEVICE_ID) {
        print("userD에 없으면(앱이 삭제) -> 키체인에서 조회 -> 있으면 UserD에 저장후 리턴:\(kDeviceID)")
        
        userD.set(kDeviceID, forKey: DEVICE_ID)
        userD.synchronize()
        
        return kDeviceID
    }else{
        print("userD,키체인 모두 없으면 -> 앱 처음시작 -> 새로 생성 후 키체인 및 userD에 저장후 리턴")
        
        let kDeviceID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        KeychainSwift().set(kDeviceID, forKey: DEVICE_ID, withAccess: .accessibleAlways)
        
        userD.set(kDeviceID, forKey: DEVICE_ID)
        userD.synchronize()
        
        print("kDeviceID:\(kDeviceID)")
        return kDeviceID
    }
}()
