

import UIKit

extension PhotoListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.authorLabel.text = searchData[indexPath.row].author
        cell.dimensionLabel.text = String(searchData[indexPath.row].width) + " X " + String(searchData[indexPath.row].height)
        let photoImage = searchData[indexPath.row].download_url
        cell.photoImageView.setImage(with: photoImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = photoCollectionView.frame.width * 0.4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetSpace = photoCollectionView.frame.width * 0.06
        let inset = UIEdgeInsets(top: insetSpace, left: insetSpace, bottom: insetSpace, right: insetSpace)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return photoCollectionView.frame.width * 0.07
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailController") as! PhotoDetailController
        photoDetailVC.id = String(searchData[indexPath.row].id)
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
}

extension PhotoListController: UITextFieldDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = photos.count - 1
        if indexPath.row == lastElement {
            fetchNextPage()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (searchBar.text! as NSString).replacingCharacters(in: range, with: string)
        searchData(searchText: newText)
        return true
    }
    
    func searchData(searchText: String){
        searchData = searchText == "" ? photos : photos.filter {
            $0.author.lowercased().contains(searchText.lowercased())}
        if searchData.count == 0{
            //dataNotFoundLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse]) {
                self.dataNotFoundLabel.isHidden = false
                self.dataNotFoundLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { done in
                print("Animation Completed")
            }
            
        }else{
            dataNotFoundLabel.isHidden = true
        }
        photoCollectionView.reloadData()
    }
}
