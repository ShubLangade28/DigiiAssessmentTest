
import UIKit
import Kingfisher

extension UIImageView{
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else{return}
        let resources = KF.ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resources)
    }
}
