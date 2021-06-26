//
//  HomeScreenModel.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import Runes
import Argo
import Curry

public struct HomeCharacterModel {

    var charID: Int
    var name: String
    var birthday: String
    var occupation: [String]
    var img: String
    var status: String
    var nickname: String
    
}

extension HomeCharacterModel: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HomeCharacterModel> {
        return curry(HomeCharacterModel.init)
            <^> json <| "char_id"
            <*> json <| "name"
            <*> json <| "birthday"
            <*> json <|| "occupation"
            <*> json <| "img"
            <*> json <| "status"
            <*> json <| "nickname"
    }
}


//// MARK: - GetCharacter
//class HomeCharacterModel: Codable {
//    let charID: Int?
//    let name: String?
//    let birthday: String?
//    let occupation: [String]?
//    let img: String?
//    let status: String?
//    let nickname: String?
//    let appearance: [Int]?
//    let portrayed: String?
//    let category: String?
//    let betterCallSaulAppearance: [Int]?
//
//    enum CodingKeys: String, CodingKey {
//        case charID = "char_id"
//        case name, birthday, occupation, img, status, nickname, appearance, portrayed, category
//        case betterCallSaulAppearance = "better_call_saul_appearance"
//    }
//
//    init(charID: Int?, name: String?, birthday: String?, occupation: [String]?, img: String?, status: String?, nickname: String?, appearance: [Int]?, portrayed: String?, category: String?, betterCallSaulAppearance: [Int]?) {
//        self.charID = charID
//        self.name = name
//        self.birthday = birthday
//        self.occupation = occupation
//        self.img = img
//        self.status = status
//        self.nickname = nickname
//        self.appearance = appearance
//        self.portrayed = portrayed
//        self.category = category
//        self.betterCallSaulAppearance = betterCallSaulAppearance
//    }
//}
//
//
