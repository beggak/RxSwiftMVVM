import Alamofire

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
