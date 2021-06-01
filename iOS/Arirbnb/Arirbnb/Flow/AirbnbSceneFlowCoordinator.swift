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
        let detailSearchVCAction = DetailSearchViewControllerAction(showSearchFilteringView: showSearchFilteringView(destination:))
        let detailSerchVC = DetailSearchViewController.create(detailSearchVCAction, [MockAdjacentDestination.mockDatas, MockSearchedDestinaion.mockDatas])
        searachSceneNavigationController?.pushViewController(detailSerchVC, animated: true)
        searachSceneNavigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func showSearchFilteringView(destination: Destination) {
        let searchFilteringVC = SearchFilteringViewController.create(destination: destination)
        searchFilteringVC.hidesBottomBarWhenPushed = true
        searachSceneNavigationController?.pushViewController(searchFilteringVC, animated: true)
    }
}
