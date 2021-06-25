//
//  HomeScreenViewModel.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import Foundation
import RxSwift
import RxCocoa


class HomeScreenViewModel {
    
    
    var loadingBehavoir = BehaviorRelay<Bool>(value: false)
    private var arrCharactersSubject = PublishSubject<[HomeCharacterModel]>()
    var arrCharactersObserver: Observable<[HomeCharacterModel]> {
        return arrCharactersSubject
    }
    let loadNextPageTrigger = PublishSubject<Void>()
    private var offset = 0
    
    private var sliderTimer: Timer?
    var slides: BehaviorRelay<[HomeCharacterModel]> = .init(value: [])
    
    let disposeBag = DisposeBag()
    private var currentSlide = 0
    var slideToItem: PublishSubject<Int> = .init()
    
    
    func setupSliderTimer(){
        sliderTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        
    }
    @objc private func scrollToNextItem(){
        guard slides.value.count > 0 else { return }
        let nextSlide = currentSlide + 1
        currentSlide = nextSlide % slides.value.count
        slideToItem.onNext(currentSlide)
    }
    
    func getCharactersData()  {
        self.loadingBehavoir.accept(true)
        
        var dictParam:[String:Any] = [String:Any]()
        dictParam["limit"] = 30
        dictParam["offset"] = offset
        
        guard let  url = URL(string: Constant_URL.SERVICE_URL + METHOD_NAME.characters + "?" +  dictParam.queryString ) else { return  }
        print(" url \(url)")
        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do{
                    let arrCharacters = try JSONDecoder().decode([HomeCharacterModel].self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.loadingBehavoir.accept(false)
                        self.arrCharactersSubject.onNext(arrCharacters)
                        self.slides.accept(arrCharacters)
                        
                    }
                    
                }catch {
                    self.loadingBehavoir.accept(false)
                }
            }
        }.resume()
    }
    
}

