//
//  DetailsViewController.swift
//  dya6 movie demo
//
//  Created by MacBook on 03/05/2025.
//

import UIKit
import Kingfisher
import Cosmos

class DetailsViewController: UIViewController {

    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var runTime: UIButton!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var releaseYear: UIButton!
    @IBOutlet weak var movieImgView: UIImageView!
    
//    var movie : Movie?
    var mImage : String?
    var mTitle : String?
    var mRating : String?
    var mRunTime : String?
    var mGenre : String?
    var mReleaseYear : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = mTitle
        runTime .setTitle(mRunTime, for: .normal)
        movieGenre.text = mGenre
        releaseYear .setTitle(mReleaseYear, for: .normal)
        movieImgView.kf.setImage(with: URL(string: mImage ?? ""), placeholder: UIImage(named: "movieplaceholder.jpg"))
        
        movieImgView.contentMode = .scaleAspectFit
        movieImgView.clipsToBounds = true
        ratingBar.settings.fillMode = .precise
        ratingBar.settings.totalStars = 10
        ratingBar.settings.updateOnTouch = false
        ratingBar.settings.emptyImage = UIImage(named: "emptyRatingStar")?.withRenderingMode(.alwaysOriginal)
        ratingBar.settings.filledImage = UIImage(named: "filledRatingStar")?.withRenderingMode(.alwaysOriginal)
        ratingBar.rating = Double(mRating ?? "0") ?? 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
