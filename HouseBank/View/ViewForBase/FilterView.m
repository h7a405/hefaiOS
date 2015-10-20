//
//  SelectTypeView.m
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FilterView.h"

@interface FilterView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_myData;
    NSMutableArray *_moreData;
    NSInteger _selectIndex;
    NSInteger _moreIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *moreTable;
@end
@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    // self = [super initWithFrame:frame];
    if (self) {
        
        self =[[NSBundle mainBundle]loadNibNamed:@"FilterView" owner:nil options:nil][0];
        self.backgroundColor=[UIColor clearColor];
        _myData=[NSMutableArray array];
        _moreData=[NSMutableArray array];
        _tableView.clipsToBounds=YES;
        _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _moreTable.hidden=YES;
        _moreTable.backgroundColor=[UIColor whiteColor];
        _selectIndex=233333;
        [self setupShow];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView==tableView) {
        return _myData.count;
    }
    if(_myData.count==0){
        return 0;
    }
    return [_moreData[_moreIndex] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView) {
        static NSString *ID=@"CELL";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=[UIColor clearColor];
            cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
            UIView *view=[[UIView alloc]init];
            view.backgroundColor=[UIColor whiteColor];
            cell.selectedBackgroundView=view;
            cell.layer.borderColor=[UIColor blackColor].CGColor;
            cell.layer.borderWidth=0.2;
        }
        if (_selectIndex==indexPath.row) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text=_myData[indexPath.row];
        return cell;
    }else{
        static NSString *ID=@"More";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=[UIColor clearColor];
            cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
            UIView *view=[[UIView alloc]init];
            view.backgroundColor=[UIColor lightGrayColor];
            cell.selectedBackgroundView=view;
        }
        cell.textLabel.text=_moreData[_moreIndex][indexPath.row][@"name"];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView) {
        _selectIndex=indexPath.row;
        _moreIndex=indexPath.row;
        _moreTable.hidden=NO;
        [_moreTable reloadData];
    }else{
        if (_selectIndex==0) {
            NSDictionary *dict=_moreData[_selectIndex][indexPath.row];
            if (_delegate&&[_delegate respondsToSelector:@selector(filterView:didSelectRoomNumWithBegin:andEnd:)]) {
                [_delegate filterView:self didSelectRoomNumWithBegin:dict[@"begin"] andEnd:dict[@"end"]];
            }
        }else if (_selectIndex==1){
            
            if (_delegate&&[_delegate respondsToSelector:@selector(filterView:didSelectRoomAreaWithBegin:andEnd:)]) {
                NSDictionary *dict=_moreData[_selectIndex][indexPath.row];
                [_delegate filterView:self didSelectRoomAreaWithBegin:dict[@"begin"] andEnd:dict[@"end"]];
            }else{
                NSDictionary *dict=_moreData[_selectIndex][indexPath.row];
                if (_delegate&&[_delegate respondsToSelector:@selector(filterView:didSelectSort:)]) {
                    [_delegate filterView:self didSelectSort:dict[@"sort"]];
                }
            }
           
        }else{
            NSDictionary *dict=_moreData[_selectIndex][indexPath.row];
            if (_delegate&&[_delegate respondsToSelector:@selector(filterView:didSelectSort:)]) {
                [_delegate filterView:self didSelectSort:dict[@"sort"]];
            }
        }
        self.hidden=YES;
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)setData:(NSArray *)data
{
    [_myData removeAllObjects];
    [_myData addObjectsFromArray:data[0]];
    if (data.count==2) {
        [_moreData removeAllObjects];
        [_moreData addObjectsFromArray:data[1]];
    }
}

-(void)setClickButtonFrame:(CGRect)clickButtonFrame
{
    self.tableView.frame=CGRectMake(5,clickButtonFrame.origin.y, KWidth-10, KHeight-clickButtonFrame.origin.y-10-KHeight*0.25);
    CGRect frame=_moreTable.frame;
    frame.origin.y=clickButtonFrame.origin.y;
    frame.size.height=KHeight-clickButtonFrame.origin.y-10-KHeight*0.25;
    _moreTable.frame=frame;
    
}
-(void)setupShow
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}
- (IBAction)clickOtherView:(id)sender {
    self.hidden=YES;
    
}
-(void)show
{
    self.hidden=NO;
}
@end
