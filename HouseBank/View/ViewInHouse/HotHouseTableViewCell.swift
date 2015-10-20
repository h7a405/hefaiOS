//
//  HotHouseTableViewCell.swift
//  HouseBank
//
//  Created by CSC on 15/1/21.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

import UIKit

class HotHouseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var _imageView: UIImageView!
    
    @IBOutlet weak var _descritionLabel: UILabel!
    @IBOutlet weak var _addressLabel: UILabel!
    @IBOutlet weak var _countLabel: UILabel!
    @IBOutlet weak var _areaLabel: UILabel!
    @IBOutlet weak var _priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func refresh(dict : NSDictionary){
        if let address: String = dict["address"] as? String{
            _addressLabel.text = address
        }
        
        if let imagePath: AnyObject = dict["imagePath"]{
            if !(imagePath is NSNull){
                let url = URLCommon.buildImageUrl(imagePath as! String, imageSize: ImageSize.D01)
                _imageView.sd_setImageWithURL(NSURL(string : url), placeholderImage: UIImage(named: "noimg"))
            }
        }
        
        if let address : String = dict["region"] as? String{
            _addressLabel.text = address
        }
        
        if let livingRooms : NSNumber = dict["livingRooms"] as? NSNumber{
            _countLabel.text = "\(livingRooms)厅"
        }
        
        if let buildArea : NSNumber = dict["buildArea"] as? NSNumber{
            _areaLabel.text = "\(buildArea.floatValue*0.01*100)平米"
        }
        
        if let price : NSNumber = dict["price"] as? NSNumber{
            _priceLabel.text = "\(price)万元"
        }
        
        if let title : String = dict["advTitle"] as? String{
            _descritionLabel.text = title
        }
    }
}
