//
//  XSSelectDistanceView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSSelectDistanceView.h"
@interface XSSelectDistanceView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation XSSelectDistanceView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(XSSelectDistanceView *)[ViewUtil xibView:@"XSSelectDistanceView"];
        _data=[NSMutableArray array];
        [_data addObjectsFromArray:@[@"不限",@"1000米",@"2000米",@"3000米"]];
        [[KAPPDelegate window]addSubview:self];
        self.hidden=YES;
    }
    return self;
}
#pragma mark - tableview delegate and data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        cell.selectedBackgroundView=view;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    cell.textLabel.text=_data[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate&&[_delegate respondsToSelector:@selector(selectDistanceView:didSelectDistance:)]) {
        [_delegate selectDistanceView:self didSelectDistance:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    self.hidden=YES;
}
#pragma mark - 显示隐藏
-(void)show
{
    self.hidden=NO;
}
- (IBAction)clickOtherView:(id)sender
{
    self.hidden=YES;
}
@end
