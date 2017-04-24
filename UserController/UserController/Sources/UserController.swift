//
//  UserController.swift
//  UserController
//
//  Created by tran.quoc.quan on 4/20/17.
//  Copyright © 2017 tran.quoc.quan. All rights reserved.
//

import UIKit


let API_BASE_URL = "http://103.18.4.14:9001/api"

open class UserController: NSObject {
    
//    MARK: Shared Instance
//    open static let sharedInstance: UserController = UserController()
    
    var userServices: UserServices = UserServices()
    
    
    public override init() {
        super.init()
        setupInit()
    }
    
    public func setupInit() {
        userServices.setBaseURL(url: API_BASE_URL)
    }
    
    public func validateAccount(email: String, completion:@escaping ((_ isSuccessful: Bool, _ isValid: Bool,_ msgError: String) -> Void)) {
        userServices.validateAccount(email : "quantq777@gmail.com", completion:{(isSuccess, responseObject) in
            completion(isSuccess, false, "")
        })
    }
    
    public func registerAccount(parameter: NSDictionary, completion:@escaping ((_ isSuccessful: Bool, _ isCreated: Bool,_ msgError: String) -> Void)) {
        userServices.registerAccount(parameter : parameter, completion:{(isSuccess, responseObject) in
            completion(isSuccess, false, "")
        })
    }
}

extension NSDictionary {
    func dictionaryToString () -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
}
