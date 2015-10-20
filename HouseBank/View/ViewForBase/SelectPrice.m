//
//  SelectPrice.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SelectPrice.h"
@interface SelectPrice()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SelectPrice

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data
{
    
    if (self) {
        self=(SelectPrice *)[ViewUtil xibView:@"SelectPrice"];
        self.data=data;
        [[KAPPDelegate window]addSubview:self];
        self.hidden=YES;
    }
    return self;
}
- (IBAction)clickOtherView:(id)sender
{
    self.hidden=YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID=@"City";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        cell.selectedBackgroundView=view;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)show
{
    self.hidden=NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidden=YES;
    if (_delegate&&[_delegate respondsToSelector:@selector(selectPrice:didSelectBeginPrice:EndPrice:)]) {
        [_delegate selectPrice:self didSelectBeginPrice:[_data[indexPath.row] objectForKey:@"begin"] EndPrice:[_data[indexPath.row] objectForKey:@"end"]];
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(selectPrice:didSelectBeginPrice:EndPrice:name:)]) {
        [_delegate selectPrice:self didSelectBeginPrice:[_data[indexPath.row] objectForKey:@"begin"] EndPrice:[_data[indexPath.row] objectForKey:@"end"] name:[_data[indexPath.row] objectForKey:@"name"]];
    }
}
@end
