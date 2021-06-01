//
//  SearchFilteringViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit
import HorizonCalendar

class SearchFilteringViewController: UIViewController, ViewControllerIdentifierable {
    static func create(destination: Destination) -> SearchFilteringViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? SearchFilteringViewController else {
            return SearchFilteringViewController()
        }
        vc.destination = destination
        return vc
    }
    
    enum FilteringSection: Int, CaseIterable {
        case location, checkInOut, price, numberOfPeople
        
        func filteringName() -> String {
            switch self {
            case .location: return "위치"
            case .checkInOut: return "체크인/체크아웃"
            case .price: return "요금"
            case .numberOfPeople: return "인원"
            }
        }
    }
    
    private lazy var filteringStackView = UIStackView()
    private lazy var calendar = DumbaCalendar()
    private lazy var filteringTableView = UITableView()
    private lazy var flowView = SearchFlowView()
    
    private var destination: Destination?
    private var filterItems: FilterItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        addSubViews()
        configureCalendar()
        configureTableView()
        configureFilterItems()
        addObservers()
    }
    
    private func configureStackView() {
        view.addSubview(filteringStackView)
        filteringStackView.translatesAutoresizingMaskIntoConstraints = false
        filteringStackView.axis = .vertical
        filteringStackView.alignment = .fill
        filteringStackView.distribution = .fill
        configureStackViewLayout()
    }
    private func configureCalendar() {
        calendar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.725).isActive = true
    }
    
    private func configureTableView() {
        filteringTableView.translatesAutoresizingMaskIntoConstraints = false
        filteringTableView.isScrollEnabled = false
        filteringTableView.isUserInteractionEnabled = false
        filteringTableView.dataSource = self
        filteringTableView.delegate = self
        filteringTableView.register(FilteringCell.nib, forCellReuseIdentifier: FilteringCell.reuseIdentifier)
        filteringTableView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    private func configureFilterItems() {
        let items = FilteringSection.allCases.map { filterSection in
            FilterItem(filteringName: filterSection.filteringName())
        }
        filterItems = FilterItems(items: items)
        filterItems?.items[FilteringSection.location.rawValue].filteringValue = destination?.destinationName
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setDateChange(_:)), name: .selectDateDidChange, object: calendar)
        NotificationCenter.default.addObserver(self, selector: #selector(setDateIsChanging(_:)), name: .selectDateisChanging, object: calendar)
    }
    
    private func addSubViews() {
        filteringStackView.addArrangedSubview(calendar)
        filteringStackView.addArrangedSubview(filteringTableView)
        filteringStackView.addArrangedSubview(flowView)
    }
    
    private func configureStackViewLayout() {
        NSLayoutConstraint.activate([
            filteringStackView.topAnchor.constraint(equalTo: view.topAnchor),
            filteringStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filteringStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filteringStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Objc

extension SearchFilteringViewController {
    @objc func setDateChange(_ notification: Notification) {
        let lowerDay = notification.userInfo?[UserInfoKey.selectedLowerDay] as? Day
        let upperDay = notification.userInfo?[UserInfoKey.selectedUpperDay] as? Day
        let selectedDaysDescription = "\(lowerDay?.descriptionOnlyMonthDayForKorean ?? "") - \(upperDay?.descriptionOnlyMonthDayForKorean ?? "")"
        filterItems?.items[FilteringSection.checkInOut.rawValue].filteringValue = selectedDaysDescription
        filteringTableView.reloadData()
        
        flowView.meetTheConditions()
    }
    
    @objc func setDateIsChanging(_ notification: Notification) {
        filterItems?.items[FilteringSection.checkInOut.rawValue].filteringValue = ""
        filteringTableView.reloadData()
        
        flowView.doNotMeetTheConditions()
    }
}

//MARK: - Data Source

extension SearchFilteringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilteringSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilteringCell.reuseIdentifier) as? FilteringCell
        cell?.configure(item: filterItems?.items[indexPath.item])
        
        return cell ?? UITableViewCell()
    }
}

//MARK: - Delegate

extension SearchFilteringViewController: UITableViewDelegate {
    
}
