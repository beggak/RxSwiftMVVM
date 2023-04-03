import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchCityCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    init(navigationControler: UINavigationController) {
        self.navigationController = navigationControler
    }
    
    override func start() {
        let vc = SearchCityViewController()
        let service = AirportService.shared
        vc.viewModelBuilder = { [disposeBag] in
            let viewModel = SearchCityViewModel(input: $0, airportService: service)
            viewModel.router.citySelected
                .map({ [weak self] in
                    guard let `self` = self else { return }
                    self.showAirports(usingModels: $0)
                })
                .drive()
                .disposed(by: disposeBag)
            return viewModel
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

private extension SearchCityCoordinator {
    func showAirports(usingModels models: Set<AirportModel>) -> Void {
        let airportsCoordinator = AirportsCoordinator(models: models,
                                                      navigationController: self.navigationController)
        self.add(coordinator: airportsCoordinator)
        airportsCoordinator.start()
    }
}
