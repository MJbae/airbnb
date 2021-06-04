//
//  PersonFilteringViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import UIKit

struct PersonFilteringViewControllerAction {
    let showSearchResultView: () -> Void
}

class PersonFilteringViewController: UIViewController, ViewControllerIdentifierable {
    static func create(_ action: PersonFilteringViewControllerAction, _ filerlingDataSource: FilteringTableViewDataSource) -> PersonFilteringViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? PersonFilteringViewController else {
            return PersonFilteringViewController()
        }
        vc.action = action
        vc.filteringTableViewDataSource = filerlingDataSource
        return vc
    }
    
    private lazy var filteringStackView = UIStackView()
    private lazy var personFilteringTableView = UITableView()
    private lazy var filteringTableView = UITableView()
    private lazy var flowView = SearchFlowView()
    
    private var searchResultManager = SearchResultManager.shared
    private var action: PersonFilteringViewControllerAction?
    private var personFilteringDataSource = PersonFilteringDataSource()
    private var filteringTableViewDataSource = FilteringTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        configureStackView()
        addSubViews()
        configurePersonFilteringTableView()
        configureTableView()
        addObservers()
    }
    
    private func configureBackButton() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9367293119, green: 0.3948215544, blue: 0.4507040977, alpha: 1)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(_:)))
        navigationItem.leftBarButtonItem = backButton
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
    }
    
    private func configureTableView() {
        filteringTableView.dataSource = filteringTableViewDataSource
        filteringTableView.delegate = self
        filteringTableView.configureFilteringTableView()
    }
    
    private func addObservers() {
      
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonDidTap(_:)), name: .moveSearchFlowNextStep, object: flowView)
        NotificationCenter.default.addObserver(self, selector: #selector(eraseButtonDidTap(_:)), name: .resetFiltering, object: flowView)
        NotificationCenter.default.addObserver(self, selector: #selector(personFilteringPlusButtonDidTap(_:)), name: .personPlustButtonDidTap, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(personFilteringMinusButtonDidTap(_:)), name: .personMinusButtonDidTap, object: nil
        )
    }
    
    private func addSubViews() {
        filteringStackView.addArrangedSubview(personFilteringTableView)
        personFilteringTableView.configureFilteringViewLayout()
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

extension PersonFilteringViewController {
    @objc func back(_ sender: UIBarButtonItem) {
        filteringTableViewDataSource.numberOfPeopleChange("")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonDidTap(_ notification: Notification) {
        searchResultManager.setGuest(personFilteringDataSource.countOfAdult(), personFilteringDataSource.countOfChildren(), personFilteringDataSource.countOfInfant())
        
        action?.showSearchResultView()
    }
    
    @objc func eraseButtonDidTap(_ notification: Notification) {
        personFilteringDataSource.reset()
        personFilteringTableView.reloadData()
        filteringTableViewDataSource.numberOfPeopleChange("")
        filteringTableView.reloadData()
        flowView.doNotMeetTheConditions()
        
        searchResultManager.clearGuest()        
    }
    
    @objc func personFilteringPlusButtonDidTap(_ notification: Notification) {
        let personSection = notification.userInfo?[UserInfoKey.personSection] as? Int ?? 0
        personFilteringDataSource.plus(personSection)
        personFilteringTableView.reloadData()
        flowView.meetTheConditions()
        filteringTableViewDataSource.numberOfPeopleChange(personFilteringDataSource.totalPeopleToString())
        filteringTableView.reloadData()
    }
    
    @objc func personFilteringMinusButtonDidTap(_ notification: Notification) {
        let personSection = notification.userInfo?[UserInfoKey.personSection] as? Int ?? 0
        personFilteringDataSource.minus(personSection)
        if personFilteringDataSource.isDefaultValues() {
            flowView.doNotMeetTheConditions()
        }
        personFilteringTableView.reloadData()
        filteringTableViewDataSource.numberOfPeopleChange(personFilteringDataSource.totalPeopleToString())
        filteringTableView.reloadData()
    }
}

//MARK: - Delegate

extension PersonFilteringViewController: UITableViewDelegate {
    
}
