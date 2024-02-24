

import Foundation

final class GetDataViewModel{
    let networkManager: NetworkLayer
    
    init(networkManager: NetworkLayer){
        self.networkManager = networkManager
    }
    
    var photos = [Photos]()
    var item = 0
    var eventhandler: ((_ event: Event) -> ())?
    
    func getData(id: String){
        DispatchQueue.main.async {
            self.eventhandler?(.startLoading)
        }
        networkManager.apiCall(model: [Photos].self, type: .getData(id: id)) { result in
            self.eventhandler?(.stopLoading)
            switch result{
            case .success(let photos):
                self.photos.append(contentsOf: photos)
                //print(photos.count)
                self.item = photos.count
                self.eventhandler?(.reloadData)
                
            case .failure(let error):
                self.eventhandler?(.error(error))
            }
        }
    }
}
