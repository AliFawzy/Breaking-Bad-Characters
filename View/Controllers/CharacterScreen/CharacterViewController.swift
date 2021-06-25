//
//  CharacterViewController.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CharacterViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    // MARK: - Properties
    private let homeViewModel = HomeScreenViewModel()
    private let characterCollectionCell = "CharacterCollectionViewCell"
    private let disposeBage = DisposeBag()
    var indexId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCharacters()
        subscribeResponse()
        subscribeLoading()
        setupCollectionView()
        homeViewModel.setupSliderTimer()
        subscribeBackBtn()
        subscribeNextBtn()
        subscribePreviousBtn()
    }
    
}

// MARK: - Functions
extension CharacterViewController{
    
    
    private func getCharacters() {
        if self.isConnectedToNetwork(){
            self.homeViewModel.getCharactersData()
        }else{
            ProgressHUD.showError("please check Your internet")
        }
    }
    
    private func subscribeResponse(){
        
        homeViewModel.arrCharactersObserver.bind(to: self.charactersCollectionView.rx.items(cellIdentifier: self.characterCollectionCell, cellType: CharacterCollectionViewCell.self)){ (row, result, cell) in
            cell.configure(with: result)
            
            self.charactersCollectionView.scrollToItem(at: IndexPath(row: self.indexId, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
            
        }.disposed(by: disposeBage)
        
        
    }
    private func subscribeLoading(){
        homeViewModel.loadingBehavoir.subscribe(onNext: {  (isLoading) in
            
            if isLoading{
                ProgressHUD.show()
            }else{
                ProgressHUD.dismiss()
            }
        }).disposed(by: disposeBage)
    }
    
    private func subscribeBackBtn(){
        backBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return}
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBage)
    }
    
    private func subscribeNextBtn() {
        nextBtn.rx.tap.subscribe(onNext: { [weak self](_) in
            guard let self = self else { return }
            self.indexId += 1
            self.charactersCollectionView.scrollToItem(at: IndexPath(row: self.indexId, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
        }).disposed(by: disposeBage)
    }
    
    private func subscribePreviousBtn() {
        previousBtn.rx.tap.subscribe(onNext: { [weak self](_) in
            guard let self = self else { return }
            if self.indexId > 0{
                self.indexId -= 1
            }
            self.charactersCollectionView.scrollToItem(at: IndexPath(row: self.indexId, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
        }).disposed(by: disposeBage)
    }
}
// MARK: - Setup collection view
extension CharacterViewController:  UICollectionViewDelegateFlowLayout {
    private func setupCollectionView()  {
        charactersCollectionView.register(UINib(nibName: self.characterCollectionCell , bundle: nil), forCellWithReuseIdentifier:  self.characterCollectionCell)
        charactersCollectionView.rx.setDelegate(self).disposed(by: disposeBage)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = CGSize(width:collectionView.frame.width, height: collectionView.frame.height )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    }
    
    
}
