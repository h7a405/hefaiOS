//
//  SelectTypeView.m
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SelectTypeView.h"

@interface SelectTypeView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_myData;
    NSInteger _selectIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)Finished finish;
@end
@implementation SelectTypeView

- (id)initWithFrame:(CGRect)frame
{
    // self = [super initWithFrame:frame];
    if (self) {
        
        self =[[NSBundle mainBundle]loadNibNamed:@"SelectTypeView" owner:nil options:nil][0];
        _myData=[NSMutableArray array];
        _tableView.clipsToBounds=YES;
       // _tableView.layer.cornerRadius=10;
        [_myData addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"]];
        //NSArray *array=[NSArray arrayWithContentsOfURL: [[NSBundle mainBundle]URLForResource:@"typeString" withExtension:@"plist"]];
        //[_myData addObjectsFromArray:array];
        _selectIndex=233333;
    }
    return self;
}
- (IBAction)clickOtherView:(id)sender
{
    [self removeFromSuperview];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
    }
    if (_selectIndex==indexPath.row) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text=_myData[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    _selectIndex=indexPath.row;
    NSString *string=_myData[indexPath.row];
    if (_finish) {
        _finish(string);
    }else if (_delegate&&[_delegate respondsToSelector:@selector(typeView:didSelect:selectIndex:)]){
        [_delegate typeView:self didSelect:string selectIndex:_selectIndex];
    }
    [self removeFromSuperview];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
     cell.accessoryType=UITableViewCellAccessoryNone;
}
+(void)showSelectTypeViewWithClickFrame:(CGRect)frame Finished:(Finished)finish
{
    SelectTypeView *view=[[SelectTypeView alloc]init];
    view.finish=finish;
    view.tableView.frame=CGRectMake(5, frame.origin.y+10, KWidth-10, KHeight-frame.origin.y-15-80);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
}
-(void)setData:(NSArray *)data
{
    [_myData removeAllObjects];
    [_myData addObjectsFromArray:data];
}

/**
 *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
 *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
 */
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != 320 || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}
-(void)setClickButtonFrame:(CGRect)clickButtonFrame
{
    self.title.frame=CGRectMake(_title.frame.origin.x, clickButtonFrame.origin.y+10, KWidth-10, _title.frame.size.height);
    self.tableView.frame=CGRectMake(5,CGRectGetMaxY(_title.frame), KWidth-10, KHeight-CGRectGetMaxY(_title.frame)-50);
    
    
    
}
-(void)showWithTitle:(NSString *)title
{
    _title.text=title;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}
@end
