//
//  DirectoryRecommendedUserViewController.h
//  HouseBank
//
//  Created by SilversRayleigh on 2/7/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LISTCOUNT @"totalSize"
#define RECOMMENDLIST @"myGains"

#define RECOMMENDEDNAME @"contrName"
#define RECOMMENDEDPHONE @"contrPhone"
#define RECOMMENDEDCHARACTER @"contrRole"
#define RECOMMENDEDTYPE @"contrType"
#define RECOMMENDEDINCOME @"gainMoney"
#define RECOMMENDEDAMOUT @"contrMoney"
#define RECOMMENDEDDATE @"createDatetime"
#define RECOMMENDEDLEVEL @"gainerLevel"


typedef NS_ENUM(NSInteger, isDirectory){
    DIRECTORY = 800001,
    INDIRECTORY = 800002
};

@interface DirectoryRecommendedUserViewController : UIViewController

@property (assign, nonatomic)BOOL isDirectory;
@property (assign, nonatomic) NSInteger currentChosen;

@end
