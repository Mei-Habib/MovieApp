//
//  TableViewController.swift
//  dya6 movie demo
//
//  Created by MacBook on 06/05/2025.
//

import UIKit
import Cosmos

class TableViewController: UITableViewController {
    
//    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
//    @IBOutlet weak var runTime: UIButton!
    @IBOutlet weak var movieGenre: UILabel!
//    @IBOutlet weak var releaseYear: UIButton!
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        movieTitle.text = mTitle
//        runTime .setTitle(mRunTime, for: .normal)
        movieGenre.text = mGenre
//        releaseYear .setTitle(mReleaseYear, for: .normal)
        movieImgView.kf.setImage(with: URL(string: mImage ?? ""), placeholder: UIImage(named: "movieplaceholder.jpg"))
        
        movieImgView.contentMode = .scaleAspectFit
        movieImgView.clipsToBounds = true
//        ratingBar.settings.fillMode = .precise
//        ratingBar.settings.totalStars = 10
//        ratingBar.settings.updateOnTouch = false
//        ratingBar.settings.emptyImage = UIImage(named: "emptyRatingStar")?.withRenderingMode(.alwaysOriginal)
//        ratingBar.settings.filledImage = UIImage(named: "filledRatingStar")?.withRenderingMode(.alwaysOriginal)
//        ratingBar.rating = Double(mRating ?? "0") ?? 0
    }
        

    // MARK: - Table view data source

   

}
