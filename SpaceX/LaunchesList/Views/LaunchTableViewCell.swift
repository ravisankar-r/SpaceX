//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import UIKit

final class LaunchTableViewCell: UITableViewCell {
    
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var launchDateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        launchDateLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    func configure(with item: Launch) {
        
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        launchDateLabel.text = item.launchDate
        mainImage.sd_setImage(with: item.imageURL,
                              placeholderImage: UIImage(named: "placeholder-launch"),
                              options: [], context: nil)
        mainImage.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isSelected = false
        isHidden = false
    }
}
