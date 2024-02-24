

import UIKit

class PhotoListController: UIViewController {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataNotFoundLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let getData = GetDataViewModel(networkManager: NetworkManager())
    var id = 0
    var pageNumber = 0
    var item = 0
    var photos = [Photos]()
    var searchData = [Photos]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiConfiguration()
        photoCollectionView.register(PhotoCell.nib, forCellWithReuseIdentifier: PhotoCell.identifier)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        searchBar.delegate = self
        cancelButton.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.searchBar.isHidden = true
        //        self.collectionViewTopConstraint.constant = 0
    }
    
    func fetchNextPage() {
        if self.item == 0{
            return
        }else{
            pageNumber = pageNumber + 1
            getData.getData(id: String(pageNumber))
        }
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.searchBar.isHidden = false
            self.searchBar.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.cancelButton.isHidden = false
        } completion: { done in
        }
        
        UIView.animate(withDuration: 0.3) {
            self.collectionViewTopConstraint.constant = self.view.frame.height * 0.1
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        UIView.animate(withDuration: 0.3) {
            self.searchBar.isHidden = true
            self.collectionViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        searchData = photos
        cancelButton.isHidden = true
        self.photoCollectionView.reloadData()
    }
    
}

extension PhotoListController{
    func apiConfiguration(){
        fetchPhotosData()
        observEvent()
    }
    
    func fetchPhotosData(){
        getData.getData(id: String(id))
    }
    
    func observEvent(){
        getData.eventhandler = { event in
            switch event{
            case .startLoading:
                self.activityIndicator.startAnimating()
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                print(event)
                break
            case .stopLoading:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
                print(event)
                break
            case .reloadData:
                self.photos = self.getData.photos
                self.searchData = self.photos
                self.item = self.getData.item
                //print(self.photos)
                print(event)
                DispatchQueue.main.async {
                    self.photoCollectionView.reloadData()
                }
                break
            case .error(let error):
                print(error)
            }
            
        }
    }
    
}

