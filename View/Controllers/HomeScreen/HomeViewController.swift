//
//  HomeViewController.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var postersCollectionView: UICollectionView!
    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var posterImage: UIImageView!
    
    
    // MARK: - Properties
    private let homeViewModel = HomeScreenViewModel()
    private let postersCollectionCell = "HomePostersCollectionCell"
    private let charactersTableCell = "HomeCharactersTableCell"
    private let disposeBage = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCharacters()
        subscribeResponse()
        subscribeLoading()
        setupTableView()
        subscibeTableCellSelection()
        scrollToBottom()
        setupCollectionView()
        homeViewModel.setupSliderTimer()
        bindSliders()
        
    }
}

// MARK: - Functions
extension HomeViewController{
    
    private func getCharacters() {
        if self.isConnectedToNetwork(){
            self.homeViewModel.getCharactersData()
        }else{
            ProgressHUD.showError("please check Your internet")
        }
    }
    
    private func subscribeResponse(){
        homeViewModel.arrCharactersObserver.bind(to: self.charactersTableView.rx.items(cellIdentifier: self.charactersTableCell, cellType: HomeCharactersTableCell.self)){ (row, result, cell) in
            cell.selectionStyle = .none
            cell.configure(with: result)
            
        }.disposed(by: disposeBage)
        
        
        homeViewModel.arrCharactersObserver.bind(to: self.postersCollectionView.rx.items(cellIdentifier: self.postersCollectionCell, cellType: HomePostersCollectionCell.self)){ (row, result, cell) in
            cell.configure(with: result)
            
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
    
    private func bindSliders() {
        homeViewModel.slideToItem.subscribe(onNext:  { [weak self] (index) in
            self?.postersCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
        }).disposed(by: disposeBage)
        
        homeViewModel.slides.subscribe { [weak self] (_) in
            self?.postersCollectionView.reloadData()
        }.disposed(by: disposeBage)
        
    }
    
    
    
    
    
}

// MARK: - Setup Table view
extension HomeViewController: UITableViewDelegate{
    private func setupTableView()  {
        charactersTableView.register(UINib(nibName: self.charactersTableCell, bundle: nil), forCellReuseIdentifier: charactersTableCell)
        charactersTableView.rx.setDelegate(self).disposed(by: disposeBage)
    }
    private func subscibeTableCellSelection(){
        Observable.zip(charactersTableView.rx.itemSelected, charactersTableView.rx.modelSelected(HomeCharacterModel.self)).bind {  selectedIndex, character in
            let vc = CharacterViewController.init()
            vc.indexId = (character.charID ?? 1) - 1
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            
        }.disposed(by: disposeBage)
    }
    private func scrollToBottom(){
        self.charactersTableView.rx_reachedBottom
            .map { _ in () }
            .bind(to: self.homeViewModel.loadNextPageTrigger)
            .disposed(by: disposeBage)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Setup collection view
extension HomeViewController:  UICollectionViewDelegateFlowLayout {
    private func setupCollectionView()  {
        postersCollectionView.register(UINib(nibName: self.postersCollectionCell , bundle: nil), forCellWithReuseIdentifier:  self.postersCollectionCell)
        postersCollectionView.rx.setDelegate(self).disposed(by: disposeBage)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = CGSize(width:collectionView.frame.width-40, height: collectionView.frame.height )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left:20, bottom: 0.0, right: 20)
    }
}

