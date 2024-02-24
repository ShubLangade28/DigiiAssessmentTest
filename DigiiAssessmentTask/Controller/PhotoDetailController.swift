

import UIKit

class PhotoDetailController: UIViewController {
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var photoImaheView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var id = ""
    
    let getDetailData = GetDetailDataViewModel(networkManager: NetworkManager())
    var detailPhotoData: PhotoDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiConfiguration()
        navigationController?.navigationBar.tintColor = .black
    }
}

extension PhotoDetailController{
    func apiConfiguration(){
        fetchPhotosData()
        observEvent()
    }
    
    func fetchPhotosData(){
        getDetailData.getData(id: id)
    }
    
    func observEvent(){
        getDetailData.eventhandler = { event in
            switch event{
            case .startLoading:
                self.activityIndicator.startAnimating()
                DispatchQueue.main.async {
                    self.authorNameLabel.isHidden = true
                    self.activityIndicator.startAnimating()
                }
                print(event)
                break
            case .stopLoading:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.authorNameLabel.isHidden = false
                    self.activityIndicator.isHidden = true
                }
                print(event)
                break
            case .reloadData:
                self.detailPhotoData = self.getDetailData.photos
                guard let result = self.detailPhotoData else{return}
                print(result)
                print(event)
                DispatchQueue.main.async {
                    self.authorNameLabel.text = result.author
                    self.photoImaheView.setImage(with: result.download_url)
                    self.title = "ID - \(result.id)"
                }
                
                break
            case .error(let error):
                print(error)
            }
            
        }
    }
}
