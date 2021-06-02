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
        let myreservationVC = MyReserVationViewController()
        
        tabBarController = FlowTabBarController(searachSceneNavigationController ?? UINavigationController(), wishListVC, myreservationVC)
        return tabBarController ?? UITabBarController()
    }
    
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
        let personFilteringVC = PersonFilteringViewController.create(PersonFilteringViewControllerAction(), dataSrouce)
        searachSceneNavigationController?.pushViewController(personFilteringVC, animated: true)
    }
}
