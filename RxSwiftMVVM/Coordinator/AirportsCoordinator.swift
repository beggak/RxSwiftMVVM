import UIKit
import Foundation

class AirportsCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let models: Set<AirportModel>
    
    init(models: Set<AirportModel>,
         navigationController: UINavigationController) {
        self.models = models
        self.navigationController = navigationController
    }
    
    override func start() {
        let vc = AirportsViewController()
        vc.viewModelBuilder = { [models] in
            let title = models.first?.city ?? ""
            return AirportsViewModel(input: $0,
                              dependencies: (title: title, models: models))
        }
        self.navigationController.pushViewController(vc, animated: true)
    }
}
