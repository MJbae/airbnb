//
//  FlowTabBarController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

class FlowTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience private init(_ searchSceneNavigationController: UINavigationController, _ wishListVC: UIViewController, _ myReservationVC: UIViewController) {
        self.init()

        viewControllers = [UINavigationController()]
        viewControllers = [searchSceneNavigationController, wishListVC, myReservationVC]
    }
    
    static func createLoginedTabBarController(_ searchSceneNavigationController: UINavigationController, _ wishListVC: UIViewController, _ myReservationVC: UIViewController) -> FlowTabBarController {
        
        let searchBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let wishListBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "heart"), selectedImage: nil)
        let reservationBarItem = UITabBarItem(title: "예약", image: UIImage(systemName: "person"), selectedImage: nil)

        searchSceneNavigationController.tabBarItem = searchBarItem
        wishListVC.tabBarItem = wishListBarItem
        myReservationVC.tabBarItem = reservationBarItem
        
        return FlowTabBarController.init(searchSceneNavigationController, wishListVC, myReservationVC)
    }
    
    static func createLogoutedTabBarController(_ searchSceneNavigationController: UINavigationController, _ wishListVC: UIViewController, _ myReservationVC: LogoutMyReserVationViewController) -> FlowTabBarController {
        let searchBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let wishListBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "heart"), selectedImage: nil)
        let reservationBarItem = UITabBarItem(title: "로그인", image: UIImage(systemName: "person"), selectedImage: nil)

        searchSceneNavigationController.tabBarItem = searchBarItem
        wishListVC.tabBarItem = wishListBarItem
        myReservationVC.tabBarItem = reservationBarItem
        
        return FlowTabBarController.init(searchSceneNavigationController, wishListVC, myReservationVC)
    }
}
