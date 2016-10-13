//
//  MoviesViewController.swift
//  muvi
//
//  Created by Estella Lai on 10/12/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import AFNetworking // command + B

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                            if let data = dataOrNil {
                                if let responseDictionary = try!
                                    NSJSONSerialization.JSONObjectWithData(data, options:[]) as?
                                    NSDictionary {
                                    print("response: \(responseDictionary)")
                                    self.movies = responseDictionary["results"] as? [NSDictionary]
                                    self.tableView.reloadData()
                                }
                            }
            
        });
        task.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title =  movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel!.text = title
        cell.overviewLabel!.text = overview
        
        let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? NSNull {
            return cell
        } else {
            let posterPath = movie["poster_path"]
            let imageUrl = NSURL(string: imageBaseUrl + (posterPath as! String))
            cell.posterView.setImageWithURL(imageUrl!)
        }

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
