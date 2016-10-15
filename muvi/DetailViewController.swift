//
//  DetailViewController.swift
//  muvi
//
//  Created by Estella Lai on 10/14/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var textView: UIView!
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set up scroll view
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
                                        height: textView.frame.origin.y + textView.frame.size.height)
        
        // set up title text
        let title = movie["title"] as! String!
        titleLabel.text = title
        
        // set up overview text
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        showImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showImage() {
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: imageBaseUrl + posterPath)
            posterView.setImageWithURL(imageUrl!)
        }
    }

}
