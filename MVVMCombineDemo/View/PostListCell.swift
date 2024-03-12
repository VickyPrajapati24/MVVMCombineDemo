//
//  PostListCell.swift
//  MVVMCombineDemo
//
//  Created by Vicky Prajapati on 09/03/24.
//

import UIKit

class PostListCell: UITableViewCell {

    @IBOutlet weak var lblPostTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
