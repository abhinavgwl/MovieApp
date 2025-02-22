//
//  MoviewDetailsViewCOntroller.swift
//  Movie
//
//  Created by Abhinav Saini on 20/02/25.
//

import UIKit

class MoviewDetailsViewCOntroller: UIViewController {
    
    @IBOutlet weak var movieImage : UIImageView!
    @IBOutlet weak var movieDescription : UILabel!
    
    var movie_Image = ""
    var movie_Description = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()

        // Do any additional setup after loading the view.
    }
    
    
    func setUpData(){
        self.movieDescription.text = movie_Description
        self.movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(movie_Image)" ))
    }
    
    @IBAction func clickOnBackBtn(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

}
