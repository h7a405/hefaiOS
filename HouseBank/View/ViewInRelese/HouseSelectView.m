//
//  HouseSelectView.m
//  HouseBank
//
//  Created by JunJun on 15/1/9.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "HouseSelectView.h"
#import "CRMBasicFactory.h"
#import "UIViewExt.h"
#import "CRTableViewCell.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface HouseSelectView () <UITableViewDataSource,UITableViewDelegate>

//@property(nonatomic,assign) BOOL isShrink;
//@property(nonatomic,assign) CGRect btnFrame;
//@property(nonatomic,strong) NSMutableArray *dataMutArray;
@property(nonatomic,strong) UITableView *selectedTableView;
//@property(nonatomic,strong) UIImageView *directImg;
//
//@property(nonatomic, weak) UIButton *mainBtn;
//
//@property (nonatomic, copy) MutipleBlock mBlock;

@end
@implementation HouseSelectView

-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withTitle:(NSString *)title withBlock:(void(^)(NSArray *titleArr,NSString *btnTitle))block withPlaceHolderText:(NSString *)themeTitle;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mBlock = block;
        
//        self.isShrink = YES;
//        self.btnFrame = frame;
//        self.dataMutArray = [NSMutableArray arrayWithArray:items];
//        self.currentItems = [NSMutableArray arrayWithArray:items];
//        
//        [self setBackgroundColor:[UIColor clearColor]];
//        [self.layer setCornerRadius:3.0];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [button setTag:999];
//        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
//        [button addTarget:self action:@selector(clickSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.layer.cornerRadius = 3;
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//        if (self.placeholderText) {
//            [button setTitle:self.placeholderText forState:UIControlStateNormal];
//        }
//        [self addSubview:button];
//        self.mainBtn = button;
//        
//        UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 0.3, button.frame.size.width, 0.3)];
//        temp.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
//        [button addSubview:temp];
//        
//        
//        UIImage *image = [UIImage imageNamed:@"top_009.png"];
//        self.directImg = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-5-20, (button.frame.size.height-20)/2.0, 20, 20)];
//        [self.directImg setBackgroundColor:[UIColor clearColor]];
//        [self.directImg setImage:image];
//        [button addSubview:self.directImg];
        self.title = themeTitle;
        dataSource = items;
         selectedMarks = [NSMutableArray new];
        //self.backgroundColor = [UIColor yellowColor];
        UILabel *_label = [CRMBasicFactory createLableWithFrame:CGRectMake(0, 0, 10, kScreenHeight/15) font:nil text:nil textColor:nil textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor blackColor]];
        [self addSubview:_label];
        UILabel *label = [CRMBasicFactory createLableWithFrame:CGRectMake(10, 0, self.frame.size.width, kScreenHeight/15) font:[UIFont systemFontOfSize:15] text:title textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor blackColor]];
        [self addSubview:label];
      //  [self setFrame:CGRectMake(0, label.bottom, frame.size.width, frame.size.height-kScreenHeight*2/15)];
        self.selectedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label.bottom, frame.size.width, self.frame.size.height-(kScreenHeight*2)/15) style:UITableViewStylePlain];
        //        [self.selectedTableView setScrollEnabled:NO];
        self.selectedTableView.delegate = self;
        self.selectedTableView.dataSource = self;
        //        self.selectedTableView.layer.cornerRadius = 3;
        [self.selectedTableView.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
        [self.selectedTableView.layer setBorderWidth:0.3];
        self.selectedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectedTableView.separatorColor = [UIColor clearColor];
        
        [self addSubview:_selectedTableView];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_selectedTableView.left, _selectedTableView.bottom, self.frame.size.width, kScreenHeight/15)];
        img.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:img];
        img.userInteractionEnabled = YES;
        UIButton *btn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake((kScreenWidth-20-kScreenWidth*1.2/3)/2, 5, (kScreenWidth*1.2)/3, kScreenHeight/15-15) title:@"确定" titleColor:[UIColor blackColor] target:self action:@selector(btnAct)];
        btn.backgroundColor = [UIColor whiteColor];
        [img addSubview:btn];
        
        //        [self buttonSelectedTitleIndex:(items.count-1)];
        
    }
    
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
    
    // init the CRTableViewCell
    CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRTableViewCellIdentifier];
    }
    
    // Check if the cell is currently selected (marked)
    NSString *text = [dataSource objectAtIndex:[indexPath row]];
    cell.isSelected = [selectedMarks containsObject:text] ? YES : NO;
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = [dataSource objectAtIndex:[indexPath row]];
    
    //数组包含了所点row的text 就移除
    if ([selectedMarks containsObject:text]){// Is selected?
        [selectedMarks removeObject:text];
    }
    else{
        [selectedMarks addObject:text];
    }
    
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    

}

- (void)btnAct
{
    self.hidden = YES;
    
    if (selectedMarks.count>0) {
           NSString *title = selectedMarks[0];
    
   // NSString *title = selectedMarks[0];
    for (int i=1; i<selectedMarks.count; i++) {
        NSString *str = selectedMarks[i];
       title = [[title stringByAppendingString:@","] stringByAppendingString:str];
    }
    if (self.mBlock) {
        self.mBlock(selectedMarks,title);
    }
    }
    if (selectedMarks.count == 0) {
       // NSString *title = @"请点击选择";
        if (self.mBlock) {
            self.mBlock(selectedMarks,_title);
        }

    }
}
@end
