//
//  DetailAccommodationViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/04.
//

import UIKit

class DetailAccommodationViewController: UIViewController, ViewControllerIdentifierable, Alertable {

    static func create() -> DetailAccommodationViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? DetailAccommodationViewController else {
            return DetailAccommodationViewController()
        }
        return vc
    }
    
    @IBOutlet weak var accommodationImageScrollView: UIScrollView!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var accommodationNameLabel: UILabel!
    @IBOutlet weak var accommodationTypeLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var filteringLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func addWishListButtonDidTap(_ sender: Any) {
        if !LoginManager.shared.isLoging() {
            let loginVC = LoginNavigationController()
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    
    private var accommodation: DetailAccommodation?
    private var network = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    private func load() {
        let endPoint = EndPoint(path: "accommodations/1", httpMethod: .get, parameter: [:])
        
        network.request(with: endPoint, dataType: DetailAccommodation.self) { response in
            let result = response.result
            switch result {
            case .success(let accommodation):
                self.accommodation = accommodation
                self.reload()
            case .failure(_):
                self.showAlertWithDimiss(message: "네트워크 오류")
            }
        }
    }
    
    private func reload() {
        configureThumbImage(images: accommodation?.images ?? [])
        accommodationNameLabel.text = accommodation?.name ?? ""
        accommodationTypeLabel.text = accommodation?.type ?? ""
        hostNameLabel.text = accommodation?.hostName ?? ""
        descriptionLabel.text = accommodation?.description ?? ""
    }
    
    private func configureThumbImage(images: [String]) {
        imageViews.removeAll()
        for i in 0..<images.count {
            let imageView = UIImageView()
            let xPos = self.accommodationImageScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0,
                                     width: self.accommodationImageScrollView.bounds.width,
                                     height: self.accommodationImageScrollView.bounds.height)
            imageView.load(url: images[i])
            imageViews.append(imageView)
            accommodationImageScrollView.addSubview(imageView)
            accommodationImageScrollView.contentSize.width = imageView.frame.width * CGFloat(i+1)
        }
    }
}
