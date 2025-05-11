//
//  MovieCollectionViewController.swift
//  dya6 movie demo
//
//  Created by MacBook on 03/05/2025.
//

import UIKit
import Kingfisher
import ShimmerSwift
import CoreData
import Reachability

class MovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var movies = [[String:Any]]()
    private var networkIndicator:UIActivityIndicatorView?
    private var context:NSManagedObjectContext!
    private var reachability:Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        self.navigationController?.title = "Movies"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMovie))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        do {
                reachability = try Reachability()
                try reachability?.startNotifier()
            } catch {
                print("Reachability error: \(error)")
        }
        
        networkIndicator = UIActivityIndicatorView(style: .medium)
        networkIndicator?.center = view.center
        view.addSubview(networkIndicator!)
//        networkIndicator?.startAnimating()
        loadMovies()
        
    }
    
    func loadMovies(){
        do{
            let savedMovies = try self.context.fetch(Movie.fetchRequest()) 
            print("saved movies count: \(savedMovies.count)")
            
            if savedMovies.isEmpty && isNetworkAvailable(status: .unavailable) {
                fetchMoviesFromApi()
            } else{
                fetchMoviesFromCoreData()
            }
        }catch let error as NSError{
            print(error)
        }
    }
    
    @objc func addMovie(){
        let addMovieVC = self.storyboard?.instantiateViewController(withIdentifier: "add")
        self.navigationController?.pushViewController(addMovieVC!, animated: true)
    }

    func fetchMoviesFromApi(){
        let url = URL(string: "https://dummyjson.com/c/8b9b-3f93-4c8d-a8b9")
        guard let url = url else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            
            do{
                let moviesList = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                
                self.movies = moviesList
                let dict = self.movies[0]
                print(dict["Title"] as! String)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.networkIndicator?.stopAnimating()
                    self.cacheMovies()
                    
                }
                
            } catch {
                print("Response Error \(error)")
            }
        }.resume()
    }
    
    func fetchMoviesFromCoreData(){
        print("fetchMoviesFromCoreData")
        do{
            let savedMovies = try context.fetch(Movie.fetchRequest())
            self.movies = savedMovies.map {
                return [
                    "Title": $0.title ?? "",
                    "Year": $0.releaseYear ?? "",
                    "imdbRating": $0.rating ?? "",
                    "Genre": $0.genre ?? "",
                    "Poster": $0.image ?? "",
                    "Runtime": $0.runTime ?? ""
                ]
            }
            print("movies: \(movies.count)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.networkIndicator?.stopAnimating()
            }
        } catch let error as NSError{
            print("Response Error \(error)")
        }
    }

    func cacheMovies(){
        guard let movies = movies as? [[String:Any]] else { return }
    
        for movie in movies {
            let newMovie = Movie(context: context)
            newMovie.title = movie["Title"] as? String
            newMovie.releaseYear = movie["Year"] as? String
            newMovie.rating = movie["imdbRating"] as? String
            newMovie.genre = movie["Genre"] as? String
            newMovie.image = movie["Poster"] as? String
            newMovie.runTime = movie["Runtime"] as? String
            
            do{
                try context.save()
            } catch let error as NSError{
                print(error)
            }
        }
        
        do{
            let moviesList = try context.fetch(Movie.fetchRequest())
            print("movies list count: \(moviesList.count)")
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    func isNetworkAvailable(status:Reachability.Connection? = nil) -> Bool {
        guard let reachability = reachability else {
            return false
        }
        
        let connection = status ?? reachability.connection
        switch connection {
        case .wifi, .cellular:
            print("Network Available")
            return true
        case .unavailable:
            print("Network Not Available")
            return false
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        
        cell.movieImg.subviews.forEach { $0.removeFromSuperview() }
        
        if indexPath.item < movies.count,
           let posterPath = movies[indexPath.item]["Poster"] as? String,
           let url = URL(string: posterPath) {
        
            let shimmer = ShimmeringView(frame: cell.movieImg.bounds)
            let placeholder = UIView(frame: shimmer.bounds)
            placeholder.backgroundColor = .systemGray5
            shimmer.contentView = placeholder
            cell.movieImg.addSubview(shimmer)
            shimmer.isShimmering = true
            
            cell.movieImg.kf.setImage(with: url){ result in
                switch result{
                case .failure(_):
                    break
                        
                case .success(_):
                    cell.movieImg.subviews.forEach { $0.removeFromSuperview() }
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/2
        let height = UIScreen.main.bounds.height/3
        return CGSize(width: width-20, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "details") as! TableViewController
        
        detailsVC.mImage = movies[indexPath.item]["Poster"] as? String
        detailsVC.mGenre = movies[indexPath.item]["Genre"] as? String
        detailsVC.mRating = movies[indexPath.item]["imdbRating"] as? String
        detailsVC.mTitle = movies[indexPath.item]["Title"] as? String
        detailsVC.mReleaseYear = movies[indexPath.item]["Year"] as? String
        detailsVC.mRunTime = movies[indexPath.item]["Runtime"] as? String
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    

}

