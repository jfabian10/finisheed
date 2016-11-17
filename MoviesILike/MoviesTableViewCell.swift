//
//  MoviesTableViewCell.swift
//  MoviesILike
//
//  Created by CS3714 on 11/17/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet var moviePosterImageView: UIImageView?
    
    @IBOutlet var mpaaRatingRuntimeDateLabel: UILabel?
    @IBOutlet var movieTitleLabel: UILabel?
    
    @IBOutlet var imdbRatingLabel: UILabel?
    
    @IBOutlet var movieStarsLabel: UILabel?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
