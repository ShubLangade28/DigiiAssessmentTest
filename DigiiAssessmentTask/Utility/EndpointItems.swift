

import Foundation

enum HTTPMethods: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPointData{
    var baseUrl: String{get}
    var path: String{get}
    var url: URL?{get}
    var httpMethod: HTTPMethods{get}
    var parameter: Data?{get}
    var header: [String:String]{get}
}

enum EndpointType{
    case getData(id: String)
    case getDetailData(id: String)
}

extension EndpointType: EndPointData{
    var baseUrl: String {
        return "https://picsum.photos"
    }
    
    var path: String {
        switch self{
            
        case .getData(let id):
            return "/v2/list?page=\(id)&limit=100"
        case .getDetailData(let id):
            return "/id/\(id)/info"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseUrl)\(path)")
    }
    
    var httpMethod: HTTPMethods {
        switch self{
        case .getData:
            return .get
        case .getDetailData:
            return .get
        }
    }
    
    var parameter: Data? {
        switch self{
            
        case .getData:
            return Data()
            
        case .getDetailData:
            return Data()
        }
    }
    
    var header: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    
}
