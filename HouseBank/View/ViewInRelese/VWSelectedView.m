//
//  VWSelectedView.m
//  KKKKKK
//
//  Created by rokect on 14-8-13.
//  Copyright (c) 2014年 rokect. All rights reserved.
//

#import "VWSelectedView.h"
#import "FullScreenPickerView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface VWSelectedView () <UITableViewDataSource,UITableViewDelegate>{
    NSInteger _currentIndex;
}

@property(nonatomic,assign) BOOL isShrink;
@property(nonatomic,assign) CGRect btnFrame;
@property(nonatomic,strong) NSMutableArray *dataMutArray;
@property(nonatomic,strong) UITableView *selectedTableView;
@property(nonatomic,strong) UIImageView *directImg;

@property(nonatomic, weak) UIButton *mainBtn;

@property (nonatomic, copy) MutipleBlock mBlock;

@end

@interface VWSelectedView (FullPickerViewDelegate)<FullScreenPickerViewDelegation>

@end

@implementation VWSelectedView

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)items{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShrink = YES;
        self.btnFrame = frame;
        _currentIndex = 0;
        self.dataMutArray = [NSMutableArray arrayWithArray:items];
        self.currentItems = [NSMutableArray arrayWithArray:items];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:3.0];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button setTag:999];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [button addTarget:self action:@selector(clickSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        if (self.placeholderText) {
            [button setTitle:self.placeholderText forState:UIControlStateNormal];
        }
        [self addSubview:button];
        self.mainBtn = button;
        
        UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 0.3, button.frame.size.width, 0.3)];
        temp.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        [button addSubview:temp];
        
        
        UIImage *image = [UIImage imageNamed:@"top_009.png"];
        self.directImg = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-5-20, (button.frame.size.height-20)/2.0, 20, 20)];
        [self.directImg setBackgroundColor:[UIColor clearColor]];
        [self.directImg setImage:image];
        [button addSubview:self.directImg];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        self.selectedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0)];
        //        [self.selectedTableView setScrollEnabled:NO];
        self.selectedTableView.delegate = self;
        self.selectedTableView.dataSource = self;
        //        self.selectedTableView.layer.cornerRadius = 3;
        [self.selectedTableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.selectedTableView.layer setBorderWidth:0.3];
        self.selectedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectedTableView.separatorColor = [UIColor clearColor];
        
        [self addSubview:self.selectedTableView];
        
        //        [self buttonSelectedTitleIndex:(items.count-1)];
    }
    
    return self;
    
}

- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    self.mainBtn.titleLabel.text = placeholderText;
}

-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withBlock:(void(^)(NSInteger index,NSString *title))block
{
    self.mBlock = block;
    return [self initWithFrame:frame withItems:items];
}

-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withBlock:(void(^)(NSInteger index,NSString *title))block withPlaceholderText:(NSString *)text{
    self.placeholderText = text;
    return [self initWithFrame:frame withItems:items withBlock:block];
}

-(void)clickSelected:(UIButton *)sender
{
    if (self.isShrink) {
        //        [self expandedTableView];
        [self openPikerView];
    }else{
        //        [self shrinkTableView];
    }
}

-(void) openPikerView{
    FullScreenPickerView *pickerView = [[FullScreenPickerView alloc] init];
    pickerView.delegation = self;
    [pickerView showWith:self.dataMutArray index:_currentIndex];
}

-(void)expandedTableView{
    self.isShrink = NO;
    self.directImg.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    CGFloat selectedViewHeight = self.btnFrame.size.height * ([self.dataMutArray count]+1);
    self.frame = CGRectMake(self.btnFrame.origin.x, self.btnFrame.origin.y, self.btnFrame.size.width, selectedViewHeight);
    //-----------
    float height;
    (selectedViewHeight-self.btnFrame.size.height > 100) ? (height = 100) : (height = selectedViewHeight-self.btnFrame.size.height);
    //-----------
    self.selectedTableView.frame = CGRectMake(0, self.btnFrame.size.height, self.btnFrame.size.width, height);
    //    self.selectedTableView.frame = CGRectMake(0, self.btnFrame.size.height, self.btnFrame.size.width, selectedViewHeight-self.btnFrame.size.height);
    [UIView commitAnimations];
    [self.selectedTableView reloadData];
}

-(void)shrinkTableView
{
    self.isShrink = YES;
    self.directImg.transform = CGAffineTransformMakeRotation(0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [self setFrame:CGRectMake(self.btnFrame.origin.x, self.btnFrame.origin.y, self.btnFrame.size.width, self.btnFrame.size.height)];
    self.selectedTableView.frame = CGRectMake(0, self.btnFrame.size.height, self.btnFrame.size.width, 0);
    [UIView commitAnimations];
}

-(void)buttonSelectedTitleIndex:(NSInteger)index{
    for (UIView *view in self.subviews) {
        if (view.tag == 999 && [view isKindOfClass:[UIButton class]]) {
            UIButton *sender = (UIButton *)[view viewWithTag:999];
            [sender setTitle:self.dataMutArray[index] forState:UIControlStateNormal];
        }
    }
}


-(void)reloadItems:(NSArray *)items
{
    if (self.currentItems) {
        [self.currentItems removeAllObjects];
    }
    [self.currentItems addObjectsFromArray:items];
    
    [self.dataMutArray removeAllObjects];
    [self.dataMutArray addObjectsFromArray:items];
    [self shrinkTableView];
    //    [self buttonSelectedTitleIndex:(items.count-1)];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.btnFrame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataMutArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.btnFrame.size.height-20)/2.0, self.btnFrame.size.width -10, 20)];
        [titleLable setFont:[UIFont systemFontOfSize:14.0]];
        titleLable.textColor = [UIColor blackColor];
        [titleLable setTag:1];
        titleLable.backgroundColor = [UIColor clearColor];
        [titleLable setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:titleLable];
        
        UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.btnFrame.size.width, 0.3)];
        [imgLine setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:imgLine];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *lable0 = (UILabel *)[cell viewWithTag:1];
    [lable0 setText:[self.dataMutArray objectAtIndex:indexPath.row]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedDelegate && [self.selectedDelegate respondsToSelector:@selector(vwSelectedView:selectedTitle:index:)]) {
        [self.selectedDelegate vwSelectedView:self selectedTitle:self.dataMutArray[indexPath.row] index:indexPath.row];
        [self shrinkTableView];
        [self buttonSelectedTitleIndex:indexPath.row];
    }
    
    if (self.mBlock) {
        self.mBlock(indexPath.row,self.dataMutArray[indexPath.row]);
    }
    [self shrinkTableView];
    [self buttonSelectedTitleIndex:indexPath.row];
}

@end

@implementation VWSelectedView(FullPickerViewDelegate)

-(void) didTappenBy : (FullScreenPickerView *) fullPickerView index : (NSInteger) index{
    if (self.mBlock) {
        self.mBlock(index,self.dataMutArray[index]);
    }
    [self buttonSelectedTitleIndex:index];
    [fullPickerView dismiss];
    _currentIndex = index;
};

@end
