//
//  DictionaryExtension.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import Foundation

extension Dictionary {
    
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            if value is String {
                let strValue = value as? String ?? ""
                output +=  "\(key)=\(strValue.addingPercentEncodingForURLQueryValue() ?? "")&"
            }else {
                output +=  "\(key)=\(value)&"
            }
            
        }
        output = String(output.dropLast())
        return output
    }

}
