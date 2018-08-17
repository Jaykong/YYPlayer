//
//  VideoItemCell.swift
//  YYPlayer
//
//  Created by JayKong on 2018/8/15.
//  Copyright © 2018 EF Education. All rights reserved.
//

import UIKit

class VideoItemCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.font = UIFont.systemFont(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       
    }
    
    func configreCell(with selectedIndex:Int) {
//        if selectedIndex {
//            self.titleLbl.textColor = UIColor.orange
//        } else {
//            self.titleLbl.textColor = UIColor.black
//        }
    }

}
