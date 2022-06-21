import Foundation

@testable import DeliveryAppChallenge

final class NetworkManagerProtocolSpy: NetworkManagerProtocol {


    private(set) var requestCalledCount = 0
    private(set) var requestPassed: NetworkRequest?

    var requestToBeReturned: Any?

    func request<T>(_ request: NetworkRequest, completion: @escaping NetworkResult<T>) where T : Decodable {
        self.requestCalledCount += 1
        self.requestPassed = request

        if let requestToBeReturned = requestToBeReturned,
            let expectedRequest = requestToBeReturned as? Result<T, Error> {
            completion(expectedRequest)
        }
    }
}
