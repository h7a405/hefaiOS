//
//  SelectViewController.swift
//  HouseBank
//
//  Created by CSC on 15/1/18.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

import UIKit

@objc protocol SelectViewDelegation : NSObjectProtocol{
    func didSelectAddress(param : NSDictionary)
}

class SelectViewController: BaseViewController {
    
    @IBOutlet private weak var _tableView: UITableView!
    
    @IBOutlet private weak var _abcView: SelectABCView!
    
    private var _abcLabel : UILabel!
    
    private var _keys : Array<String>! //存储首字母
    private var _dataDicts : [String : NSMutableArray]! //存储数据
    
    weak var _delegation : SelectViewDelegation?
    
    var keyWord : String?
    var areaId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
        
        self.requestDataFromServer()
    }
    
    func requestDataFromServer(){
        let ws = CommunityWsImpl()
        
        let key = keyWord ?? ""
        let regionId = areaId ?? "0"
        
        let waittingView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        ws.requestCommunityList(regionId, keyWord: key) { (Bool isSuccess, result : AnyObject!,data : String!) -> Void in
            waittingView.hide(true)
            
            var success = isSuccess
            if isSuccess{
                let dict = result as! NSDictionary
                if let array: NSArray = dict["data"] as? NSArray {
                    if array.count > 0{
                        self.onDataLoad(array)
                    }else{
                        success = false
                    }
                }else{
                    success = false
                }
            }
            
            if !success{
                MBProgressHUD.showMessag("该地区没有小区可以选择", toView: self.navigationController?.view)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func onDataLoad(datas : NSArray!){
        datas.enumerateObjectsUsingBlock { (obj : AnyObject!, index : Int, isstop : UnsafeMutablePointer<ObjCBool>) -> Void in
            let dict = obj as! NSDictionary
            if let name = dict["address"] as? NSString{
                if name.length > 0{
                    let pinyin = PinyinHelper.toHanyuPinyinStringWithNSString(name as String,withHanyuPinyinOutputFormat:HanyuPinyinOutputFormat(),withNSString:"").capitalizedString
                    
                    var first = "#"
                    
                    if count(pinyin) > 0{
                        first = pinyin.substringToIndex(advance(pinyin.startIndex, 1))
                    }
                    
                    if var arrayInData : NSMutableArray = self._dataDicts[first]{
                        arrayInData.addObject(dict)
                    }else{
                        var arrayInData = NSMutableArray()
                        arrayInData.addObject(dict)
                        self._dataDicts[first] = arrayInData
                        
                        self._keys.append(first)
                    }
                }
            }
        }
        
        let compare = { (obj1 : String, obj2 : String) -> Bool in
            let com = obj1.compare(obj2, options: NSStringCompareOptions(rawValue: 0))
            switch com {
            case .OrderedAscending:
                return true
            case .OrderedSame:
                fallthrough
            case .OrderedDescending:
                return false
            default://由于已经满足所有的条件，可以不写default
                return false
            }
        }
        
        _keys.sort(compare)
        _tableView.reloadData()
    }
    
    func initialize(){
        let label = UILabel(frame: CGRectMake(0, 0, 50, 50))
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        label.font = UIFont.systemFontOfSize(45)
        
        label.center = self.view.center;
        label.hidden = true
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        self._abcLabel = label
        
        _abcView.delegate = self
        _tableView.delegate = self
        _tableView.dataSource = self
        
        _keys = []
        _dataDicts = [:]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SelectViewController: SelectABCViewDelegation{
    func didSelect(view: SelectABCView!, abcStr: String!) {
        _abcLabel.hidden = false
        
        _abcLabel.text = abcStr
        
        if "#" == abcStr{
            _tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated:false)
        }else{
            for (var i = 0 ; i < _keys.count ; i++){
                let c = _keys[i]
                
                if c == abcStr{
                    _tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: i), atScrollPosition: UITableViewScrollPosition.None, animated:false)
                    break
                }
            }
        }
    }
    
    func cancel(view: SelectABCView!) {
        _abcLabel.hidden = true
    }
}

extension SelectViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let array: NSMutableArray = _dataDicts[_keys[section]]!
        return array.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return _keys.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return _keys[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let array: NSMutableArray = _dataDicts[_keys[indexPath.section]]!
        let dict : NSDictionary = array.objectAtIndex(indexPath.row) as! NSDictionary
        
        if let delegate = _delegation{
            delegate.didSelectAddress(dict)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier = "cell"
        var returnCell : UITableViewCell!
        if let cell: AnyObject = tableView.dequeueReusableCellWithIdentifier(identifier){
            returnCell = cell as! UITableViewCell
        }else{
            returnCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        let array: NSMutableArray = _dataDicts[_keys[indexPath.section]]!
        let dict : NSDictionary = array.objectAtIndex(indexPath.row) as! NSDictionary
        returnCell.textLabel!.text = dict["address"] as? String
        
        return returnCell
    }
}

