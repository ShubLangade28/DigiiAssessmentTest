

import Foundation

protocol NetworkLayer{
    func apiCall<T: Decodable>(model: T.Type, type: EndpointType, completionHandler: @escaping complitionHandler<T>)
}
enum FetchingError: Error{
    case invalidUrl
    case invalidData
    case invalidResponse
    case decodingError(Error)
}

enum Event{
    case startLoading
    case stopLoading
    case reloadData
    case error(FetchingError)
}

typealias complitionHandler<T> = (Result<T,FetchingError>) -> ()

final class NetworkManager: NetworkLayer{
    func apiCall<T: Decodable>(model: T.Type, type: EndpointType, completionHandler: @escaping complitionHandler<T>){
        
        guard let url = type.url else{
            completionHandler(.failure(.invalidUrl))
            return
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = type.httpMethod.rawValue
        
        if let body = type.parameter{
            request.httpBody = body
            request.allHTTPHeaderFields = type.header
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                completionHandler(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else{
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            do{
                let result = try JSONDecoder().decode(model, from: data)
                completionHandler(.success(result))
            }catch let error{
                completionHandler(.failure(.decodingError(error)))
            }
        }
        .resume()
    }
    
    
}
