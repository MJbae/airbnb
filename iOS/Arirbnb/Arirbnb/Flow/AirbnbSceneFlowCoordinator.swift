//
//  AirbnbSceneFlowCoordinator.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

public class AirbnbSceneFlowCoordinator {
    
    private var tabBarController: FlowTabBarController?
    private var searachSceneNavigationController: UINavigationController?

    init() {
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(userIsLogin(_:)), name: .userIsLogin, object: LoginManager.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(userIsLogout(_:)), name: .userIsLogout, object: LoginManager.shared)
    }
    
    func start() -> UITabBarController {
        let mainSearchViewControllerAction = MainSearchViewControllerAction(showDetailSearchView: showDetailSearchView)
        let mainSearchVC = MainSearchViewController.create(mainSearchViewControllerAction, [[Destination.init(destinationName: "HeroImage")],MockAdjacentDestination.mockDatas, MockThemeDestination.mockDatas])
        searachSceneNavigationController = UINavigationController(rootViewController: mainSearchVC)

        if !LoginManager.shared.isLoging() {
            let logoutWishListVC = LogoutWishListViewController.create()
            let logoutMyReserVationVC = LogoutMyReserVationViewController.create()
            tabBarController = FlowTabBarController.createLogoutedTabBarController(searachSceneNavigationController ?? UINavigationController(), logoutWishListVC, logoutMyReserVationVC)
            return tabBarController ?? UITabBarController()
        } else {
            let loginWishListVC = LoginWishListViewController.create()
            let loginMyReserVationVC = LoginMyReserVationViewController.create()
            tabBarController = FlowTabBarController.createLoginedTabBarController(searachSceneNavigationController ?? UINavigationController(), loginWishListVC, loginMyReserVationVC)
            return tabBarController ?? UITabBarController()
        }
    }
}

//MARK: - OBJC

extension AirbnbSceneFlowCoordinator {
    @objc func userIsLogin(_ notification: Notification) {
        let loginWishListVC = LoginWishListViewController.create()
        let loginMyReserVationVC = LoginMyReserVationViewController.create()
        tabBarController?.setLoginViewControllers(searachSceneNavigationController ?? UINavigationController(), loginWishListVC, loginMyReserVationVC)
    }
    
    @objc func userIsLogout(_ notification: Notification) {
        let logoutWishListVC = LogoutWishListViewController.create()
        let logoutMyReserVationVC = LogoutMyReserVationViewController.create()
        tabBarController?.setLogoutViewControllers(searachSceneNavigationController ?? UINavigationController(), logoutWishListVC, logoutMyReserVationVC)
    }
}


//MARK: - ViewControllers Actions

extension AirbnbSceneFlowCoordinator {
    func showDetailSearchView() {
        let detailSearchVCAction = DetailSearchViewControllerAction(showCalendarFilteringView: showCalendarFilteringView(destination:))
        let detailSerchVC = DetailSearchViewController.create(detailSearchVCAction, [MockAdjacentDestination.mockDatas, MockSearchedDestinaion.mockDatas])
        searachSceneNavigationController?.pushViewController(detailSerchVC, animated: true)
        searachSceneNavigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func showCalendarFilteringView(destination: Destination) {
        let calendarFilteringVCACtion = CalendarFilteringViewControllerAction(showPriceFilteringView: showPriceFilteringView(_:))
        let calendarFilteringVC = CalendarFilteringViewController.create(calendarFilteringVCACtion, destination)
        calendarFilteringVC.hidesBottomBarWhenPushed = true
        searachSceneNavigationController?.pushViewController(calendarFilteringVC, animated: true)
    }
    
    func showPriceFilteringView(_ dataSrouce: FilteringTableViewDataSource) {
        let action = PriceFilteringViewControllerAction(showPersonFilteringView: showPersonFilteringView(_:))
        let priceFilteringVC = PriceFilteringViewController.create(action, dataSrouce)
        searachSceneNavigationController?.pushViewController(priceFilteringVC, animated: true)
    }
    
    func showPersonFilteringView(_ dataSrouce: FilteringTableViewDataSource) {
        let action = PersonFilteringViewControllerAction(showSearchResultView: showSearchResultView)
        let personFilteringVC = PersonFilteringViewController.create(action, dataSrouce)
        searachSceneNavigationController?.pushViewController(personFilteringVC, animated: true)
    }
    
    func showSearchResultView() {
        let searchResultVC = SearchResultViewController.create(SearchResultViewControllerAction())
        tabBarController?.tabBar.isHidden = false
        searachSceneNavigationController?.pushViewController(searchResultVC, animated: true)
    }
}
