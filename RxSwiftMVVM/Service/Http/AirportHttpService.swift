import Alamofire

class AirportHttpService: HttpService {
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: Alamofire.URLRequestConvertible) -> Alamofire.DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<300)
        
    }
}
