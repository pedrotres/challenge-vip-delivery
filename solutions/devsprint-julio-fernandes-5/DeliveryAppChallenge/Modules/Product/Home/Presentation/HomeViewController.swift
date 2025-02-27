//
//  ViewController.swift
//  DeliveryAppChallenge
//
//  Created by Rodrigo Borges on 25/10/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    let interactor: HomeViewInteractorProtocol
    
    lazy var homeView: UIView = {
        return HomeView(delegate: self)
    }()
    
    init(interactor: HomeViewInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Delivery App"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(didTapSettings))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.fetchData()
    }
    
    override func loadView() {
        self.view = homeView
    }
}

//MARK: interface: HomeViewControllerOutput
extension HomeViewController: HomeViewControllerOutput {
    func showData(_ data: HomeViewModel) {
        (homeView as? HomeView)?.fillAddressRender(data: data)
    }
    
    func showError() {
        print(">>>> Erro ao baixar os dados")
    }
    
}

//MARK: Target/Actions
extension HomeViewController: HomeViewDelegate {
    
    func didTapCategory() {
        let controller = RestaurantListConfigurator.make(with: RestaurantListConfigurator.Dependencies())
        show(controller, sender: self)
    }
    
    func didTapEdit() {
        let controller = AddressSearchConfigurator.make(with: AddressSearchConfigurator.Dependencies())
        show(controller, sender: self)
    }
    
    func didSelectRestaurant(_ data: RestaurantListResponse) {
        let controller = RestaurantDetailsViewController()
        show(controller, sender: self)
    }
    
    @objc func didTapSettings() {
        let controller = SettingsViewConfigurator.make(with: SettingsViewConfigurator.Dependencies())
        show(controller, sender: self)
    }

}
