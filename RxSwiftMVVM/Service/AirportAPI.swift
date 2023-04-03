import RxSwift

protocol AirportAPI {
    func fetchAirports() -> Single<AirportsResponse>
}
