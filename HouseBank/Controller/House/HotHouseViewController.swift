//
//  HotHouseViewController.swift
//  HouseBank
//
//  Created by CSC on 15/1/21.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

import UIKit

class HotHouseViewController: BaseViewController {
    
    @IBOutlet private weak var _tappedView: UIView!
    @IBOutlet private weak var _houseNameLabel: UILabel!
    @IBOutlet private weak var _countLabel: UILabel!
    @IBOutlet private weak var _firstHotImageView: UIImageView!
    @IBOutlet private weak var _priceLabel: UILabel!
    @IBOutlet private weak var _locationLabel: UILabel!
    @IBOutlet private weak var _addressLabel: UILabel!
    
    @IBOutlet weak var _tableView: UITableView!
    
    private var _datas : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.requestDatasFromServer()
    }
    
    private func initialize(){
        _tableView.delegate = self
        _tableView.dataSource = self
    }
    
    private func requestDatasFromServer(){
        if let cityId: NSString = NSUserDefaults.standardUserDefaults().objectForKey("KLocationCityId") as? NSString{
            let mbpView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            let ws = HouseWsImpl()
            ws.requestHotHouseList("", cityId: cityId as String , result: {(isSuccess : Bool, result : AnyObject!, data : String!) -> Void in
                mbpView.hide(true)
                if isSuccess{
                    self._datas = result as! NSArray
                    
                    if self._datas.count > 0{
                        self.onDataLoadWith(self._datas[0] as! NSDictionary)
                    }else{
                        self.onNoData()
                    }
                    
                    self._tableView.reloadData()
                }else{
                    self.onNoData()
                }
            })
        }else{
            self.onNoData()
        }
    }
    
    private func onNoData(){
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.whiteColor()
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        imageView.image = UIImage(named: "ic_stat_no_result")
        imageView.center = CGPointMake(view.center.x, view.center.y - 30)
        view.addSubview(imageView)
        
        let labelFrame = CGRectMake(0, view.center.y + 30,view.frame.size.width,40)
        let tipsLabel = UILabel(frame: labelFrame)
        tipsLabel.textAlignment = NSTextAlignment.Center
        tipsLabel.textColor = UIColor.blackColor()
        tipsLabel.text = "该地区没有热点房源"
        view.addSubview(tipsLabel)
        
        let button = UIButton(frame: CGRectMake((view.frame.size.width - 100)/2, view.center.y + 70, 100, 30))
        button.setBackgroundImage(ViewUtil.imageWithColor(UIColor(red: (6.0/255.0), green: (145.0/255.0), blue: (205.0/255.0), alpha: 1)), forState: UIControlState.Normal)
        button.setTitle("点击返回", forState: UIControlState.Normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.layer.masksToBounds = true
        button.addTarget(self, action: Selector("backBtnTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        self.view.addSubview(view)
    }
    
    func backBtnTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func onDataLoadWith(param : NSDictionary){
        let dict = param
        if let address: String = dict["address"] as? String{
            _addressLabel.text = address
        }
        
        if let imagePath: AnyObject = dict["imagePath"]{
            if !(imagePath is NSNull){
                let url = URLCommon.buildImageUrl(imagePath as! String, imageSize: ImageSize.D01)
                _firstHotImageView.sd_setImageWithURL(NSURL(string : url), placeholderImage: UIImage(named: "noimg"))
            }
        }
        
        if let advTitle: String = dict["advTitle"]as? String{
            _houseNameLabel.text = advTitle
        }
        
        if let region : String = dict["region"] as? String{
            _locationLabel.text = region
        }
        
        var avgPrice1 : Int! = 0
        var avgPrice2 : Int! = 0
        
        if let price1: AnyObject = dict["avgPrice1"]{
            avgPrice1 = price1.integerValue
        }
        
        if let price2: AnyObject = dict["avgPrice2"]{
            avgPrice2 = price2.integerValue
        }
        
        if avgPrice1 == avgPrice2{
            _priceLabel.text = "\(avgPrice1)"
        }else{
            _priceLabel.text = "\(avgPrice1)~\(avgPrice2)"
        }
        
        if let totalCount : AnyObject = dict["totalCount"]{
            _countLabel.text = "\(totalCount.integerValue)"
        }
    }
    
    @IBAction func tappedViewTapped(sender: UITapGestureRecognizer) {
        if self._datas.count > 0{
            self.jumpViewController(self._datas[0] as! NSDictionary)
        }
    }
    
    func jumpViewController(dict : NSDictionary){
        if let type: AnyObject = dict["type"]{
            if type.integerValue == 1{
                let vc = UIStoryboard(name: "NewHouse", bundle: nil).instantiateViewControllerWithIdentifier("XSNewHouseInfoViewController") as! XSNewHouseInfoViewController
                
                if let id: AnyObject = dict["id"]{
                    vc.projectId = "\(id)"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewControllerWithIdentifier("HouseInfoViewController") as! HouseInfoViewController
                
                if let id: AnyObject = dict["id"]{
                    vc.houseId = "\(id)"
                }
                
                if let title: AnyObject = dict["advTitle"]{
                    vc.communityString = "\(title)"
                }
                
                vc.type = (dict["tradeType"] as! NSNumber).integerValue + 1
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HotHouseViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let datas = _datas{
            return datas.count == 0 ? 0 : datas.count - 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell : HotHouseTableViewCell!
        if let reuseCell: AnyObject = tableView.dequeueReusableCellWithIdentifier("HotHouseCell"){
            cell = reuseCell as! HotHouseTableViewCell
        }else{
            cell = ViewUtil.xibView("HotHouseTableViewCell") as! HotHouseTableViewCell
        }
        cell.refresh(_datas[indexPath.row + 1] as! NSDictionary)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 88
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.jumpViewController(_datas[indexPath.row + 1] as! NSDictionary)
    }
}
