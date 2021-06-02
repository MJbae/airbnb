//
//  SearchResultViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import UIKit

struct SearchResultViewControllerAction {
    
}

class SearchResultViewController: UIViewController, ViewControllerIdentifierable {
    static func create(_ action: SearchResultViewControllerAction, _ searchResult: SearchResult?) -> SearchResultViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? SearchResultViewController else {
            return SearchResultViewController()
        }
        vc.searchResult = searchResult
        vc.action = action
        return vc
    }
    
    @IBOutlet weak var FilteringLabel: UILabel!
    @IBOutlet weak var accommodationCountLabel: UILabel!
    @IBOutlet weak var accomodationCollectionView: UICollectionView!
    
    private var searchResult: SearchResult?
    private var action: SearchResultViewControllerAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accomodationCollectionView.register(FilteringResultCell.nib, forCellWithReuseIdentifier: FilteringResultCell.reuseIdentifier)
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteringResultCell.reuseIdentifier, for: indexPath) as? FilteringResultCell
        return cell ?? UICollectionViewCell()
    }
    
    
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = CGFloat(32)
        let width = view.frame.width - margin
        let height = view.frame.height / 2
        
        return CGSize(width: width, height: height)
    }
}
