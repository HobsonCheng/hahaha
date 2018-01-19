//
//  InputValidator.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class InputValidator: NSObject {
    
    class func isValidPhone(phoneNum: String) -> Bool {
        
        if (!phoneNum.isEmpty){
            
            return true
        }
        
        return false
    }
    class func isValidEmail(email: String) -> Bool {
        
        let re = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$", options: .caseInsensitive)
        
        if let re = re {
            let range = NSMakeRange(0, email.lengthOfBytes(using: String.Encoding.utf8))
            let result = re.matches(in: email, options: .reportProgress, range: range)
            return result.count > 0
        }
        
        return false
    }
    
    class func isvalidationPassword(password: String) -> Bool {
        return password.count >= 8
    }
}
