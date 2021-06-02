//
//  SearchFilteringViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit
import HorizonCalendar

struct CalendarFilteringViewControllerAction {
    let showPriceFilteringView:  (SearchResult, FilteringTableViewDataSource) -> ()
}

class CalendarFilteringViewController: UIViewController, ViewControllerIdentifierable {
    static func create(_ action: CalendarFilteringViewControllerAction, _ destination: Destination) -> CalendarFilteringViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? CalendarFilteringViewController else {
            return CalendarFilteringViewController()
        }
        vc.action = action
        vc.destination = destination
        return vc
    }
    
    private lazy var filteringStackView = UIStackView()
    private lazy var calendar = DumbaCalendar()
    private lazy var filteringTableView = UITableView()
    private lazy var flowView = SearchFlowView()
    
    private var action: CalendarFilteringViewControllerAction?
    private var destination: Destination?
    private var filteringTableViewDataSource = FilteringTableViewDataSource()
    private var searchResult = SearchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        addSubViews()
        configureTableView()
        addObservers()
        configureNavigationItem()
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
        filteringTableViewDataSource.setDestination(destination?.destinationName)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setDateChange(_:)), name: .selectDateDidChange, object: calendar)
        NotificationCenter.default.addObserver(self, selector: #selector(setDateIsChanging(_:)), name: .selectDateisChanging, object: calendar)
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonDidTap(_:)), name: .moveSearchFlowNextStep, object: flowView)
        NotificationCenter.default.addObserver(self, selector: #selector(eraseButtonDidTap(_:)), name: .resetFiltering, object: flowView)
    }
    
    private func addSubViews() {
        filteringStackView.addArrangedSubview(calendar)
        calendar.configureFilteringViewLayout()
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

extension CalendarFilteringViewController {
    @objc func setDateChange(_ notification: Notification) {
        let lowerDay = notification.userInfo?[UserInfoKey.selectedLowerDay] as? Day
        let upperDay = notification.userInfo?[UserInfoKey.selectedUpperDay] as? Day
        let selectedDaysDescription = "\(lowerDay?.descriptionOnlyMonthDayForKorean ?? "") - \(upperDay?.descriptionOnlyMonthDayForKorean ?? "")"
        filteringTableViewDataSource.checkInOutChange(selectedDaysDescription)
        filteringTableView.reloadData()
        
        searchResult.lowerDay = lowerDay
        searchResult.upperDay = upperDay
        
        flowView.meetTheConditions()
    }
    
    @objc func setDateIsChanging(_ notification: Notification) {
        filteringTableViewDataSource.checkInOutChange("")
        filteringTableView.reloadData()
        flowView.doNotMeetTheConditions()
        searchResult.lowerDay = nil
        searchResult.upperDay = nil
    }
    
    @objc func nextButtonDidTap(_ notification: Notification) {
        action?.showPriceFilteringView(searchResult, filteringTableViewDataSource)
    }
    
    @objc func eraseButtonDidTap(_ notification: Notification) {
        calendar.reset()
        filteringTableView.reloadData()
    }
}

//MARK: - Delegate

extension CalendarFilteringViewController: UITableViewDelegate {
    
}
