import Foundation
import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

protocol SearchCityViewPresentable {
    typealias Input = (
        searchText: Driver<String>,
        citySelect: Driver<CityViewModel>
    )
    typealias Output = (
        cities: Driver<[CityItemsSection]>, ()
    )
    typealias ViewModelBuilder = (SearchCityViewPresentable.Input) -> SearchCityViewPresentable
    
    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}

class SearchCityViewModel: SearchCityViewPresentable {
    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output
    private let airportService: AirportAPI
    
    typealias State = (airports: BehaviorRelay<Set<AirportModel>>, ())
    private let state: State = (airports: BehaviorRelay<Set<AirportModel>>(value: []), ())
    
    private typealias RoutingAction = (citySelectedRelay: PublishRelay<Set<AirportModel>>, ())
    private let routingAction: RoutingAction = (citySelectedRelay: PublishRelay(), ())
    
    typealias Routing = (citySelected: Driver<Set<AirportModel>>, ())
    lazy var router: Routing = (citySelected: routingAction.citySelectedRelay.asDriver(onErrorDriveWith: .empty()), ())

    private let dispodeBag = DisposeBag()
    
    init(input: SearchCityViewPresentable.Input,
         airportService: AirportAPI) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input,
                                                 state: self.state)
        self.airportService = airportService
        self.process()
    }
}

private extension SearchCityViewModel {
    static func output(input: SearchCityViewModel.Input,
                       state: State) -> SearchCityViewPresentable.Output {
        let searchTextObservable = input.searchText
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        let airportsObservable = state.airports
            .skip(1)
            .asObservable()
        
        let sections = Observable.combineLatest(searchTextObservable, airportsObservable)
            .map({ (searchKey, airports) in
                return airports.filter { (airport) -> Bool in
                    !searchKey.isEmpty && airport.city
                        .lowercased()
                        .replacingOccurrences(of: " ", with: "")
                        .hasPrefix(searchKey.lowercased())
                }
            })
            .map({
                SearchCityViewModel.uniqueElementsFrom(
                    array: $0.compactMap(
                        { CityViewModel(model: $0) }
                    )
                )
            })
            .map({ [CityItemsSection(model: 0, items: $0)]
                
            })
            .asDriver(onErrorJustReturn: [])
        return (
            cities: sections, ()
        )
    }
    
    func process() -> Void {
        self.airportService
            .fetchAirports()
            .map({ Set($0) })
            .map({ [state] in
                state.airports.accept($0)
            })
            .subscribe()
            .disposed(by: dispodeBag)
        self.input.citySelect
            .map { $0.city }
            .withLatestFrom(state.airports.asDriver()) { ($0, $1) }
            .map { (city, airports) in
                airports.filter({ $0.city == city })
            }
            .map({ [routingAction] in
                routingAction.citySelectedRelay.accept($0)
            })
            .drive()
            .disposed(by: dispodeBag)
    }
}

private extension SearchCityViewModel {
    static func uniqueElementsFrom(array: [CityViewModel]) -> [CityViewModel] {
        var set = Set<CityViewModel>()
        let result = array.filter {
            guard !set.contains($0) else { return false }
            set.insert($0)
            return true
        }
        return result
    }
}
