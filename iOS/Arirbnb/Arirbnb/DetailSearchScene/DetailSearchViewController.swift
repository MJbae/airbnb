//
//  DetailSearchViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

struct DetailSearchViewControllerAction {
    let showCalendarFilteringView: (Destination) -> Void
}

class DetailSearchViewController: UIViewController, ViewControllerIdentifierable{
    static func create(_ action: DetailSearchViewControllerAction,_ destinations: [[Destination]] = []) -> DetailSearchViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? DetailSearchViewController else {
            return DetailSearchViewController()
        }
        vc.action = action
        vc.destinations = destinations
        return vc
    }
    
    enum Section: Int, CaseIterable {
        case adjacentDestinations, searchResultDestinations
        func sectionHeaderString() -> String? {
            switch self {
            case .adjacentDestinations: return "근처의 인기 여행지"
            case .searchResultDestinations: return "검색된 장소"
            }
        }
    }
    
    @IBOutlet private weak var destinationsCollectionView: UICollectionView!
    private lazy var searchController = UISearchController()

    private var action: DetailSearchViewControllerAction?
    private var destinations: [[Destination]] = []
    private var filteredDestinations: [Destination] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        configureNavigation()
        configureCollectionView()
    }
    
    private func configureBackButton() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9367293119, green: 0.3948215544, blue: 0.4507040977, alpha: 1)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(_:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureNavigation() {
        navigationItem.title = "숙소 찾기"
        searchController.searchResultsUpdater = self
        searchController.becomeFirstResponder()
        
        searchController.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchController.searchBar.placeholder = "어디로 여행 가세요?"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        configureNavigationItem()
    }
    private func configureCollectionView() {
        registerSubViews()
    }
    
    private func registerSubViews() {
        destinationsCollectionView.register(AdjacentDestinationsCell.nib, forCellWithReuseIdentifier: AdjacentDestinationsCell.reuseIdentifier)
        destinationsCollectionView.register(SearchResultCell.nib, forCellWithReuseIdentifier: SearchResultCell.reuseIdentifier)
        destinationsCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.popViewController(animated: true)
    }
}

extension DetailSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredDestinations = destinations[Section.searchResultDestinations.rawValue].filter { destination in
            destination.destinationName.contains(text)
        }
        destinationsCollectionView.reloadData()
    }
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isSearching() -> Bool{
        return searchController.isActive && !isSearchBarEmpty
    }
}

extension DetailSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isSearching() {
            return destinations[Section.adjacentDestinations.rawValue].count
        } else {
            return filteredDestinations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isSearching() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdjacentDestinationsCell.reuseIdentifier, for: indexPath) as? AdjacentDestinationsCell
            cell?.configure(with: destinations[Section.adjacentDestinations.rawValue][indexPath.item])
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell
            cell?.configure(with: filteredDestinations[indexPath.item])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView
            if !isSearching() {
                view?.configure(headerText: Section.adjacentDestinations.sectionHeaderString())
                return view ?? UICollectionReusableView()
            } else {
                view?.configure(headerText: Section.searchResultDestinations.sectionHeaderString())
                return view ?? UICollectionReusableView()
            }
        }
        return UICollectionViewCell()
    }
}

extension DetailSearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.6
        let height = collectionView.bounds.height * 0.125
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDestination = filteredDestinations[indexPath.item]
        action?.showCalendarFilteringView(selectedDestination)
    }
}
