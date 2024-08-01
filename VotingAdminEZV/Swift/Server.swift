import UIKit
import Alamofire

class Server: NSObject {
    
    static func readFileName(urlString:String, complete:@escaping(_ fileName : String) -> Void) {
        guard let url = URL(string: urlString) else {
            complete(""); return
        }
        
        Alamofire.request(url, method: .get, parameters: [:]).responseData { (dataResponse:DataResponse) in
            if let error = dataResponse.error {
                print("error \(error.localizedDescription)")
                complete(""); return
            }else{
                print("dataResponse.response?.allHeaderFields:\(String(describing: dataResponse.response?.allHeaderFields))")
                
                if let headers = dataResponse.response?.allHeaderFields {
                    if let content_Disposition = headers["Content-Disposition"] as? String {
                        print("content_Disposition:\(content_Disposition)")
                        var fileName = content_Disposition.replacingOccurrences(of: "attachment; filename=\"", with: "")
                        fileName = fileName.replacingOccurrences(of: "\"", with: "")
                        print("fileName : \(fileName)")
                        complete(fileName); return
                    }
                }
            }
        }
        
        complete(""); return
    }
    
    @discardableResult
    static func postData(urlString:String, method : HTTPMethod = .post, otherInfo : [String:String]? = nil, completion : @escaping ( _ data  : Data? ) -> Void) -> DataRequest? {
        
        print("postData:\(urlString)")
        guard let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        
        let request = Alamofire.request(url, method: method, parameters: otherInfo).responseData { (dataResponse:DataResponse) in
            if let error = dataResponse.error {
                print("error \(error.localizedDescription)")
                completion(nil)
            }else{
                if dataResponse.response?.statusCode == 200 {
                    completion(dataResponse.data)
                }else{
                    print("httpStatusCode \(String(describing: dataResponse.response?.statusCode))")
                    completion(nil)
                }
            }
        }
        return request
    }
    
}
