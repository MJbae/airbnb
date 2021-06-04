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
        tabBar.tintColor = #colorLiteral(red: 0.9851943851, green: 0.2243180871, blue: 0.3607828617, alpha: 1)
        viewControllers = [UINavigationController()]
        viewControllers = [searchSceneNavigationController, wishListVC, myReservationVC]
    }
    
    static func createLoginedTabBarController(_ searchSceneNavigationController: UINavigationController, _ wishListVC: LoginWishListViewController, _ myReservationVC: LoginMyReserVationViewController) -> FlowTabBarController {
        
        let searchBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let wishListBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "heart"), selectedImage: nil)
        let reservationBarItem = UITabBarItem(title: "예약", image: UIImage(systemName: "person"), selectedImage: nil)

        searchSceneNavigationController.tabBarItem = searchBarItem
        wishListVC.tabBarItem = wishListBarItem
        myReservationVC.tabBarItem = reservationBarItem
        return FlowTabBarController.init(searchSceneNavigationController, wishListVC, myReservationVC)
    }
    
    static func createLogoutedTabBarController(_ searchSceneNavigationController: UINavigationController, _ wishListVC: LogoutWishListViewController, _ myReservationVC: LogoutMyReserVationViewController) -> FlowTabBarController {
        let searchBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let wishListBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "heart"), selectedImage: nil)
        let reservationBarItem = UITabBarItem(title: "로그인", image: UIImage(systemName: "person"), selectedImage: nil)

        searchSceneNavigationController.tabBarItem = searchBarItem
        wishListVC.tabBarItem = wishListBarItem
        myReservationVC.tabBarItem = reservationBarItem
        return FlowTabBarController.init(searchSceneNavigationController, wishListVC, myReservationVC)
    }
    
    func setLoginViewControllers(_ searchSceneNavigationController: UINavigationController, _ wishListVC: LoginWishListViewController, _ myReservationVC: LoginMyReserVationViewController) {
        let searchBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let wishListBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "heart"), selectedImage: nil)
        let reservationBarItem = UITabBarItem(title: "예약", image: UIImage(systemName: "person"), selectedImage: nil)

        searchSceneNavigationController.tabBarItem = searchBarItem
        wishListVC.tabBarItem = wishListBarItem
        myReservationVC.tabBarItem = reservationBarItem
        
        viewControllers = [searchSceneNavigationController, wishListVC, myReservationVC]
    }
    
    func setLogoutViewControllers(_ searchSceneNavigationController: UINavigationController, _ wishListVC: LogoutWishListViewController, _ myReservationVC: LogoutMyReserVationViewController) {
        let searchBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let wishListBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "heart"), selectedImage: nil)
        let reservationBarItem = UITabBarItem(title: "로그인", image: UIImage(systemName: "person"), selectedImage: nil)

        searchSceneNavigationController.tabBarItem = searchBarItem
        wishListVC.tabBarItem = wishListBarItem
        myReservationVC.tabBarItem = reservationBarItem
        
        viewControllers = [searchSceneNavigationController, wishListVC, myReservationVC]
    }
}
