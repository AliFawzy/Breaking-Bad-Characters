
//
//  constant.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit



class Constant_URL: NSObject {

    private static let BASE_URL = "https://www.breakingbadapi.com/api/"
    public static let SERVICE_URL = "\(BASE_URL)"

}

struct METHOD_NAME {
    
    public static let characters = "characters"
    public static let episodes = "episodes"
    public static let quotes = "quotes"
    public static let deaths = "deaths"
    
}

public  let APP_NAME = "BREAKING BAD"
public  let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public  let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public  let userDefault = UserDefaults.standard

