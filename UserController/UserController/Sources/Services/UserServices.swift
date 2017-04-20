//
//  UserService.swift
//  UserController
//
//  Created by tran.quoc.quan on 4/20/17.
//  Copyright © 2017 tran.quoc.quan. All rights reserved.
//

import UIKit
import HttpController

typealias CompleteHttpBlock = (_ isSuccess: Bool, _ data: ResponseObject) -> Void

let ValidateAccountIdentify = "ValidateAccountIdentify"

final class UserServices: HttpController, HttpControllerDelegate {
    
    var completeHandler:[String: CompleteHttpBlock] = NSMutableDictionary() as! [String : CompleteHttpBlock]
    
    
    // Can't init is singleton
    public override init() {
        super.init()
        setUpHttpService()
    }
    
    //MARK: Shared Instance
    
//    static let sharedInstance: UserServices = UserServices()
    
    //MARK: Local Variable
    
    var emptyStringArray : [String] = ["a", "b", "c"]
    
    func setUpHttpService () {
        self.setDelegate(delegate: self)
    }
    
    public func validateAccount(email: String, completion: @escaping CompleteHttpBlock) {
        completeHandler[ValidateAccountIdentify] = completion
        let parameter = NSDictionary(objects: ["email"], forKeys: [email as NSCopying])
        doRequestGETWithHttp(parameter: parameter, domain: "/validateAccount?email=quantq777@gmail.com", identify: ValidateAccountIdentify)
    }
    
    public func registerAccount(parameter: NSDictionary, completion: @escaping CompleteHttpBlock) {
        completeHandler[ValidateAccountIdentify] = completion
        doRequestGETWithHttp(parameter: parameter, domain: "/register", identify: ValidateAccountIdentify)
    }
    
    
    // MARK: HttpControllerDelegate
    
    func didDoPOSTRequestCompleted(response: String!, errorMsg: String!, identify: String) {
        
    }
    
    func didDoGETRequestCompleted(response: String!, errorMsg:String!, identify: String) {
        if let response = response {
            let dataDict = (convertToDictionary(text: response))
            if let dict = dataDict {
                print("dataDict: \n\(dict)")
                parserResponseDataWithIdentify(identify: identify, dict as NSDictionary)
            } else {
                print("Error response: \n\(response)")
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    fileprivate func parserResponseDataWithIdentify (identify: String,_ dictData: NSDictionary) {
        switch identify {
        case ValidateAccountIdentify:
            let completion = getCompletionWithIdentify(identify: identify)
            
            var isSuccessFul = true
            if let code: NSInteger = dictData["code"] as? NSInteger, code != 1 {
                isSuccessFul = false
            }
            completion(isSuccessFul, ResponseObject())
            break
            
        default:
            print("Identify is not define:\n\(identify)")
        }
    }
    
    fileprivate func getCompletionWithIdentify (identify: String) -> CompleteHttpBlock {
        var completion: CompleteHttpBlock? = nil
        for key in completeHandler.keys {
            if key == identify {
                completion = completeHandler[key]!
            }
        }
        return completion!
    }
    
}

class ResponseObject: NSObject {
    var responseList:NSMutableArray?
    var responseDict:NSDictionary?
    var responseOther:AnyObject?
    
    override init() {
        super.init()
    }
    
}

