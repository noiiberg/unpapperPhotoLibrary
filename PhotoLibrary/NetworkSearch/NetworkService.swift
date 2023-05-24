//
//  NetworkService.swift
//  PhotoLibrary
//
//  Created by Noi Berg on 15.05.2023.
//

import Foundation


class NetworkService {
    
    // building data request by URL
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let parameters = self.prepareParameters(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTAsk(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeader() -> [String : String]? {
        var headers = [String : String]()
        headers["Authorization"] = "Client-ID kiuhUDAii5t5F5IPEwlHkRfki8CfAZxfIRd-SCayuU4"
        return headers
    }
    
    private func prepareParameters(searchTerm: String?) -> [String : String] {
        var parameters = [String : String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        
        return parameters
    }
    
    private func url(params: [String : String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
    
    private func createDataTAsk(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
 
