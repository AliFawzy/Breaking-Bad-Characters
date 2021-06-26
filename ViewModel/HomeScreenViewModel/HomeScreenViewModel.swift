//
//  HomeScreenViewModel.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt


class HomeScreenViewModel {
    
    // Property
    var loadingBehavoir = BehaviorRelay<Bool>(value: false)
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = BehaviorRelay<Bool>(value: false)
    let arrCharacters = BehaviorRelay<[HomeCharacterModel]>(value: [])
    var pageIndex: Int = 0
    let error = PublishSubject<Swift.Error>()
    private let disposeBag = DisposeBag()
    private var isEnd = false
    
    private var sliderTimer: Timer?
    private var currentSlide = 0
    var slideToItem: PublishSubject<Int> = .init()
    var allCharacters = RxAPIProvider.shared.getAllCharacterList()
    
    
    func setupSliderTimer(){
        sliderTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
    }
    
    @objc private func scrollToNextItem(){
        guard arrCharacters.value.count > 0 else { return }
        let nextSlide = currentSlide + 1
        currentSlide = nextSlide % arrCharacters.value.count
        slideToItem.onNext(currentSlide)
    }
    
    public init() {
        
        self.loadingBehavoir.accept(true)
        let refreshRequest = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { observer in
                        self.pageIndex = 0
                        observer.onNext(0)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
        }
        
        let nextPageRequest = loading.asObservable()
            .sample(loadNextPageTrigger)
            .flatMap { loading -> Observable<Int> in
                if loading || self.isEnd {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { [unowned self] observer in
                        self.pageIndex += 1
                        print(self.pageIndex)
                        observer.onNext(self.pageIndex)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
        }
        
        let request = Observable.merge(refreshRequest, nextPageRequest)
            .share(replay: 1)
        
        let response = request.flatMapLatest { offset in
                RxAPIProvider.shared.getCharacterList(offset: offset).materialize()
            }
            .share(replay: 1)
            .elements()
        
        Observable
            .combineLatest(request, response, arrCharacters.asObservable()) { request, response, characters in
                self.loadingBehavoir.accept(false)
                self.isEnd = response.count < 20
                return self.pageIndex == 0 ? response : characters + response
            }
            .sample(response)
            .bind(to: arrCharacters)
            .disposed(by: disposeBag)
        
        Observable
            .merge(request.map{ _ in true },
                response.map { _ in false },
                error.map { _ in false })
            .bind(to: loading)
            .disposed(by: disposeBag)
       
    }
    
    
}

