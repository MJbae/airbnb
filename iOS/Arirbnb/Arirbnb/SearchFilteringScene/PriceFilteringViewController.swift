//
//  PriceFilteringViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import UIKit

struct PriceFilteringViewControllerAction {
    let showPersonFilteringView: (SearchResult?, FilteringTableViewDataSource) -> ()
}
class PriceFilteringViewController: UIViewController, ViewControllerIdentifierable {
    static func create(_ action: PriceFilteringViewControllerAction, _ searchResult: SearchResult, _ filerlingDataSource: FilteringTableViewDataSource) -> PriceFilteringViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? PriceFilteringViewController else {
            return PriceFilteringViewController()
        }
        vc.action = action
        vc.searchResult = searchResult
        vc.filteringTableViewDataSource = filerlingDataSource
        return vc
    }
    
    private lazy var filteringStackView = UIStackView()
    private lazy var sliderView = SliderView()
    private lazy var filteringTableView = UITableView()
    private lazy var flowView = SearchFlowView()
    
    private var searchResult: SearchResult?
    private var action: PriceFilteringViewControllerAction?
    private var filteringTableViewDataSource = FilteringTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        addSubViews()
        configureTableView()
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sliderView.configure()
    }
    
    private func configureStackView() {
        view.addSubview(filteringStackView)
        filteringStackView.translatesAutoresizingMaskIntoConstraints = false
        filteringStackView.axis = .vertical
        filteringStackView.alignment = .fill
        filteringStackView.distribution = .fill
        configureStackViewLayout()
    }

    private func configureTableView() {
        filteringTableView.dataSource = filteringTableViewDataSource
        filteringTableView.delegate = self
        filteringTableView.configureFilteringTableView()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonDidTap(_:)), name: .moveSearchFlowNextStep, object: flowView)
        NotificationCenter.default.addObserver(self, selector: #selector(eraseButtonDidTap(_:)), name: .resetFiltering, object: flowView)
    }
    
    private func addSubViews() {
        filteringStackView.addArrangedSubview(sliderView)
        sliderView.configureFilteringViewLayout()
        filteringStackView.addArrangedSubview(filteringTableView)
        filteringStackView.addArrangedSubview(flowView)
    }
    
    private func configureStackViewLayout() {
        NSLayoutConstraint.activate([
            filteringStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filteringStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filteringStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filteringStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Objc

extension PriceFilteringViewController {
    @objc func nextButtonDidTap(_ notification: Notification) {
        action?.showPersonFilteringView(searchResult, filteringTableViewDataSource)
    }
    
    @objc func eraseButtonDidTap(_ notification: Notification) {

    }
}

//MARK: - Delegate

extension PriceFilteringViewController: UITableViewDelegate {
    
}
