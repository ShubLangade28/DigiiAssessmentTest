

import Foundation

final class GetDetailDataViewModel{
    let networkManager: NetworkLayer
    
    init(networkManager: NetworkLayer){
        self.networkManager = networkManager
    }
    
    var photos : PhotoDetails?
    var eventhandler: ((_ event: Event) -> ())?
    
    func getData(id: String){
        DispatchQueue.main.async {
            self.eventhandler?(.startLoading)
        }
        networkManager.apiCall(model: PhotoDetails.self, type: .getDetailData(id: id)) { result in
            self.eventhandler?(.stopLoading)
            switch result{
            case .success(let photos):
                self.photos = photos
                self.eventhandler?(.reloadData)
            case .failure(let error):
                self.eventhandler?(.error(error))
            }
        }
    }
}
