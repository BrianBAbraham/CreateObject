//
//  Development.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/03/2023.
//

import Foundation


struct Print {
    static func this <T>(_ functionName: String, _ data: T = "", callingMethod: String = #function ){
      
       print("CALLED \(functionName) \(data) from \(callingMethod)")
    }
}

//struct PrintAll {
//    static func ofThese <Any> (_ items: (Any) ){
//        
//    }
//}
