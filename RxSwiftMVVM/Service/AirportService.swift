import RxSwift
import Alamofire

class AirportService {
    private lazy var httpService = AirportHttpService()
    static let shared: AirportService = AirportService()
}

extension AirportService: AirportAPI {
    
    func fetchAirports() -> Single<AirportsResponse> {
        return Single<AirportsResponse>.create { [httpService] (single) -> Disposable in
            do {
                try AirportHttpRouter.getAirports
                    .request(usingHttpService: httpService)
                    .responseJSON { (result) in
                        do {
                            let airports = try  AirportService.parseAirports(result: result)
                            single(.success(airports))
                        } catch {
                            single(.error(error))
                        }
                    }
            } catch {
                single(.error(CustomError.error(message: "Airports fatched failed")))
            }
            return Disposables.create()
        }
    }
}

extension AirportService {
    static func parseAirports(result: AFDataResponse<Any>) throws -> AirportsResponse {
        guard let data = result.data,
              let airportsResponse = try? JSONDecoder().decode(AirportsResponse.self, from: data) else { throw CustomError.error(message: "Invalid Airports JSON")
        }
        return airportsResponse
    }
}
