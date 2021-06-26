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
