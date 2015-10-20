//
//  HouseSelectView.h
//  HouseBank
//
//  Created by JunJun on 15/1/9.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBlock)(NSArray *titleArr,NSString *btnTitle);
@interface HouseSelectView : UIView
{
    NSMutableArray *selectedMarks;
    NSArray *dataSource;
    
}
-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withTitle:(NSString *)title withBlock:(void(^)(NSArray *titleArr,NSString *btnTitle))block withPlaceHolderText:(NSString *)themeTitle;
@property (nonatomic, copy) SelectBlock mBlock;
@property (nonatomic, copy) NSString *title;
@end
