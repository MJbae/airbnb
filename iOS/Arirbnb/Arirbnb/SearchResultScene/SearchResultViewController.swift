//
//  SearchResultViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import UIKit

struct SearchResultViewControllerAction {
    
}

class SearchResultViewController: UIViewController, ViewControllerIdentifierable, Alertable {
    static func create(_ action: SearchResultViewControllerAction) -> SearchResultViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? SearchResultViewController else {
            return SearchResultViewController()
        }
        vc.action = action
        return vc
    }
    
    @IBOutlet weak var FilteringLabel: UILabel!
    @IBOutlet weak var accommodationCountLabel: UILabel!
    @IBOutlet weak var accomodationCollectionView: UICollectionView!
    
    private var action: SearchResultViewControllerAction?
    private var network = NetworkService.shared
    private var searchResultManager = SearchResultManager.shared
    
    private var accommodations: [Accommodation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        configureRightBarItem()
        accomodationCollectionView.register(FilteringResultCell.nib, forCellWithReuseIdentifier: FilteringResultCell.reuseIdentifier)
    }
    
    private func load() {
        let parameters = searchResultManager.parameter()
        let endPoint = EndPoint(path: "accommodations", httpMethod: .get, parameter: parameters)

        network.requestAccomodations(with: endPoint) { result in
            switch result {
            case .success(let accommodations):
                self.accommodations = accommodations
                self.reload()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func reload() {
        FilteringLabel.text = searchResultManager.filterDescript
        accommodationCountLabel.text = "\(accommodations.count)개의 숙소"
        accomodationCollectionView.reloadData()
    }
    
    private func configureRightBarItem() {
        let eraseButton = UIBarButtonItem(title: "지우기", style: UIBarButtonItem.Style.done, target: self, action: #selector(erase(_:)))
        navigationItem.rightBarButtonItem = eraseButton
    }
    
    @objc private func erase(_ sender: UIBarButtonItem) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        accommodations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteringResultCell.reuseIdentifier, for: indexPath) as? FilteringResultCell
        let totalPrice = (searchResultManager.selectedTotalDate() ?? 1) * (accommodations[indexPath.item].price ?? 1)
        cell?.configure(accommodation: accommodations[indexPath.item], totalPrice: totalPrice)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailAccommodationViewController.create()
        navigationController?.pushViewController(vc, animated: true)
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
