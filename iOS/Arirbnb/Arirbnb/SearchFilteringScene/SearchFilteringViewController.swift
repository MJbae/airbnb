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
    
    private lazy var filteringStackView = UIStackView()
    private var filteringViews: [UIView] = []
    private lazy var calendar = DumbaCalendar()
    private lazy var sliderView = SliderView()
    private lazy var personFilteringTableView = UITableView()
    private lazy var filteringTableView = UITableView()
    private lazy var flowView = SearchFlowView()
    
    private var nowFilteringStep: Int = 0
    private var destination: Destination?
    private var personFilteringDataSource = PersonFilteringDataSource()
    private var filteringTableViewDataSource = FilteringTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteringViews = [calendar, sliderView, personFilteringTableView]
        configureStackView()
        addSubViews()
        configurePersonFilteringTableView()
        configureTableView()
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

    private func configurePersonFilteringTableView() {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        personFilteringTableView.tableFooterView = footerView
        personFilteringTableView.translatesAutoresizingMaskIntoConstraints = false
        personFilteringTableView.register(PersonFilteringCell.nib, forCellReuseIdentifier: PersonFilteringCell.reuseIdentifier)
        personFilteringTableView.dataSource = personFilteringDataSource
        personFilteringTableView.delegate = self
        personFilteringTableView.rowHeight = 100
        personFilteringTableView.isScrollEnabled = false
        personFilteringTableView.isUserInteractionEnabled = false
    }
    
    private func configureTableView() {
        filteringTableView.translatesAutoresizingMaskIntoConstraints = false
        filteringTableView.isScrollEnabled = false
        filteringTableView.isUserInteractionEnabled = false
        filteringTableView.dataSource = filteringTableViewDataSource
        filteringTableView.delegate = self
        filteringTableView.register(FilteringCell.nib, forCellReuseIdentifier: FilteringCell.reuseIdentifier)
        filteringTableView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        filteringTableViewDataSource.setDestination(destination?.destinationName)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setDateChange(_:)), name: .selectDateDidChange, object: calendar)
        NotificationCenter.default.addObserver(self, selector: #selector(setDateIsChanging(_:)), name: .selectDateisChanging, object: calendar)
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonDidTap(_:)), name: .moveSearchFlowNextStep, object: flowView)
    }
    
    private func addSubViews() {
        filteringStackView.addArrangedSubview(filteringViews[nowFilteringStep])
        filteringViews[nowFilteringStep].configureFilteringViewLayout()
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

extension SearchFilteringViewController {
    @objc func setDateChange(_ notification: Notification) {
        let lowerDay = notification.userInfo?[UserInfoKey.selectedLowerDay] as? Day
        let upperDay = notification.userInfo?[UserInfoKey.selectedUpperDay] as? Day
        let selectedDaysDescription = "\(lowerDay?.descriptionOnlyMonthDayForKorean ?? "") - \(upperDay?.descriptionOnlyMonthDayForKorean ?? "")"
        filteringTableViewDataSource.checkInOutChange(selectedDaysDescription)
        filteringTableView.reloadData()
        
        flowView.meetTheConditions()
    }
    
    @objc func setDateIsChanging(_ notification: Notification) {
        filteringTableViewDataSource.checkInOutChange("")
        filteringTableView.reloadData()
        
        flowView.doNotMeetTheConditions()
    }
    
    @objc func nextButtonDidTap(_ notification: Notification) {
        filteringViews[nowFilteringStep].removeFromSuperview()
        nowFilteringStep += 1
        filteringStackView.insertArrangedSubview(filteringViews[nowFilteringStep], at: 0)
        filteringViews[nowFilteringStep].configureFilteringViewLayout()
        filteringViews[nowFilteringStep].configure()
        flowView.doNotMeetTheConditions()
    }
}

//MARK: - Delegate

extension SearchFilteringViewController: UITableViewDelegate {
    
}
