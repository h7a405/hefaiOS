//
//  CRTableViewController.h
//  CRMultiRowSelector
//
//  Created by Christian Roman on 6/17/12.
//  Copyright (c) 2012 chroman. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MutipleBlock)(NSInteger index,NSString *title);
@interface CRTableViewController : UITableViewController
{
    NSArray *dataSource;
    NSMutableArray *selectedMarks;
}
- (id)initWithStyle:(UITableViewStyle)style withdataSource:(NSArray *)arr;
@property (nonatomic) NSArray *dataSource;

@end