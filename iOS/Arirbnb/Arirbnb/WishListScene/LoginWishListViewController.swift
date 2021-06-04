//
//  WishListViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit
import Alamofire

class LoginWishListViewController: UIViewController, ViewControllerIdentifierable, Alertable {

    static func create() -> LoginWishListViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginWishListViewController else {
            return LoginWishListViewController()
        }
        return vc
    }
    
    @IBOutlet weak var wishListHeaderLabel: UILabel!
    @IBOutlet weak var wishListCollectionView: UICollectionView!
    
    private var wishListItems: [WishListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        load()
    }
    
    private func configure() {
        wishListHeaderLabel.text = "\(LoginManager.shared.userName) 님의 위시리스트"
        wishListCollectionView.register(WishListCell.nib, forCellWithReuseIdentifier: WishListCell.reuseIdentifier)
    }
    
    private func load() {
        let httpHeader = HTTPHeader(name: "Authorization", value: "Bearer " + LoginManager.shared.jwt)
        let endPoint = EndPoint(path: "wishes", httpMethod: .get, parameter: [:], header: httpHeader)
        NetworkService.shared.requestWishList(with: endPoint) { result in
            switch result {
            case .success(let items):
                self.wishListItems = items
                self.wishListCollectionView.reloadData()
            case .failure(_):
                self.showAlert(message: "네트워크 에러")
            }
        }
    }
}

extension LoginWishListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        wishListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCell.reuseIdentifier, for: indexPath) as? WishListCell
        cell?.configure(wishListItems[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
}

extension LoginWishListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 32
        let width = view.frame.width - margin
        let height = view.frame.height / 2.5
        return CGSize(width: width, height: height)
    }
}
