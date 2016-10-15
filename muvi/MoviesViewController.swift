//
//  MoviesViewController.swift
//  muvi
//
//  Created by Estella Lai on 10/12/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import AFNetworking // command + B to build
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var endpoint: String!
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let movieBaseUrl = "https://api.themoviedb.org/3/movie/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpRefreshControl()
        errorLabel.hidden = true
        
        // set data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        let request = getRequest()
        let session = getSession()
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if let error = errorOrNil {
                self.errorLabel.text = error.domain
                self.errorLabel.hidden = false
            }
            
            if let data = dataOrNil {
                self.errorLabel.hidden = true
                if let responseDictionary = try!
                    NSJSONSerialization.JSONObjectWithData(data, options:[]) as?
                    NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                }
            }
            
        });
        task.resume()
    }
    
    // helper function to get session
    func getSession() -> NSURLSession {
        // Configure session so that completion handler is executed on main UI thread
        return NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue())
    }
    
    // helper function to get request
    func getRequest() -> NSURLRequest {
        let url = NSURL(string:"\(movieBaseUrl)\(endpoint)?api_key=\(self.apiKey)")
        return NSURLRequest(URL: url!)
    }
    
    // helper function to set up refresh control
    func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(_:)),
                                 forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }


    func refreshControlAction(refreshControl: UIRefreshControl) {
        let request = getRequest()
        let session = getSession()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if let error = errorOrNil {
                self.errorLabel.text = error.domain
                self.errorLabel.hidden = false
            }
            
            if let data = dataOrNil {
                self.errorLabel.hidden = true
                if let responseDictionary = try!
                    NSJSONSerialization.JSONObjectWithData(data, options:[]) as?
                    NSDictionary {
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
            
        });
        task.resume()
    }
    
    
    // function to return the number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    // function to populate each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title =  movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel!.text = title
        cell.overviewLabel!.text = overview
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: imageBaseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }

        return cell
    }
    
    // function called right before segueing into detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let destinationDetailViewController = segue.destinationViewController as! DetailViewController
        destinationDetailViewController.movie = movie
    }

}
