//
//  AirbnbSceneFlowCoordinator.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

public class AirbnbSceneFlowCoordinator {
    
    private var tabBarController: UITabBarController?
    private var searachSceneNavigationController: UINavigationController?
    
    func start() -> UITabBarController {
        let mainSearchViewControllerAction = MainSearchViewControllerAction(showDetailSearchView: showDetailSearchView)
        let mainSearchVC = MainSearchViewController.create(mainSearchViewControllerAction, [[Destination.init(destinationName: "HeroImage")],MockAdjacentDestination.mockDatas, MockThemeDestination.mockDatas])
        searachSceneNavigationController = UINavigationController(rootViewController: mainSearchVC)
        let wishListVC = WishListViewController.create()

        if !LoginManager.shared.isLoging() {
            let logoutMyReserVationVC = LogoutMyReserVationViewController.create()
            tabBarController = FlowTabBarController.createLogoutedTabBarController(searachSceneNavigationController ?? UINavigationController(), wishListVC, logoutMyReserVationVC)
            return tabBarController ?? UITabBarController()
        } else {
            let loginMyReserVationVC = LoginMyReserVationViewController()
            tabBarController = FlowTabBarController.createLoginedTabBarController(searachSceneNavigationController ?? UINavigationController(), wishListVC, loginMyReserVationVC)
            return tabBarController ?? UITabBarController()
        }
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
        let calendarFilteringVCACtion = CalendarFilteringViewControllerAction(showPriceFilteringView: showPriceFilteringView(_:_:))
        let calendarFilteringVC = CalendarFilteringViewController.create(calendarFilteringVCACtion, destination)
        calendarFilteringVC.hidesBottomBarWhenPushed = true
        searachSceneNavigationController?.pushViewController(calendarFilteringVC, animated: true)
    }
    
    func showPriceFilteringView(_ searchResult: SearchResult, _ dataSrouce: FilteringTableViewDataSource) {
        let action = PriceFilteringViewControllerAction(showPersonFilteringView: showPersonFilteringView(_:_:))
        let priceFilteringVC = PriceFilteringViewController.create(action, searchResult, dataSrouce)
        searachSceneNavigationController?.pushViewController(priceFilteringVC, animated: true)
    }
    
    func showPersonFilteringView(_ searchResult: SearchResult?, _ dataSrouce: FilteringTableViewDataSource) {
        let action = PersonFilteringViewControllerAction(showSearchResultView: showSearchResultView(_:))
        let personFilteringVC = PersonFilteringViewController.create(action, searchResult, dataSrouce)
        searachSceneNavigationController?.pushViewController(personFilteringVC, animated: true)
    }
    
    func showSearchResultView(_ searchResult: SearchResult?) {
        let searchResultVC = SearchResultViewController.create(SearchResultViewControllerAction(), searchResult)
        searachSceneNavigationController?.pushViewController(searchResultVC, animated: true)
    }
}
