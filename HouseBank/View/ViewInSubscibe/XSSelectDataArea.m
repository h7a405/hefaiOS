//
//  XSSelectAreaForSubscibe.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSSelectDataArea.h"
@interface XSSelectDataArea()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;

@end
@implementation XSSelectDataArea
- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data
{
    
    if (self) {
        self=(XSSelectDataArea *)[ViewUtil xibView:@"XSSelectDataArea"];
        _data=[NSMutableArray arrayWithArray:data];
        [[KAPPDelegate window]addSubview:self];
        self.hidden=YES;
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"Area";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
       // cell.selectedBackgroundView=view;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    cell.textLabel.text=[_data[indexPath.row] objectForKey:@"name"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
    
}
#pragma mark - 点击 选择后回调
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=_data[indexPath.row];
    if (_delegate&&[_delegate respondsToSelector:@selector(selectDataArea:didSelectRoomAreaWithBegin:andEnd:)]) {
        [_delegate selectDataArea:self didSelectRoomAreaWithBegin:dict[@"begin"] andEnd:dict[@"end"]];
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(selectDataArea:didSelectRoomAreaWithBegin:andEnd:name:)]) {
        [_delegate selectDataArea:self didSelectRoomAreaWithBegin:dict[@"begin"] andEnd:dict[@"end"] name:dict[@"name"]];
    }
    self.hidden=YES;
}
-(void)show
{
    self.hidden=NO;
}
- (IBAction)touchOtherView:(UITapGestureRecognizer *)sender
{
    self.hidden=YES;
}
@end
