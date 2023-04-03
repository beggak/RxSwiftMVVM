import RxSwift
import RxCocoa
import RxDataSources
import Foundation

typealias AirportItemsSection = SectionModel<Int, AirportViewPresentable>

protocol AirportsViewPresentable {
    typealias Output = (
        title: Driver<String>,
        airports: Driver<[AirportItemsSection]>
    )
    typealias Input = ()
    
    typealias Dependencies = (
        title: String,
        models: Set<AirportModel>
    )
    
    typealias ViewModelBuilder = (AirportsViewPresentable.Input) -> AirportsViewPresentable
    
    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

struct AirportsViewModel: AirportsViewPresentable {
    var input: AirportsViewPresentable.Input
    var output: AirportsViewPresentable.Output
    
    init(input: AirportsViewPresentable.Input,
         dependencies: AirportsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportsViewModel.output(dependencies: dependencies)
    }
}

extension AirportsViewModel {
    static func output(dependencies: AirportsViewPresentable.Dependencies) -> AirportsViewPresentable.Output {
        let sections = Driver.just(dependencies.models)
            .map({ models in
                models.compactMap({ AirportViewModel(usingModel: $0) })
            })
            .map({ [AirportItemsSection(model: 0, items: $0)] })
        return (
            title: Driver.just(dependencies.title),
            airports: sections
        )
    }
}
