//
//  ReleseBaseView.m
//  HouseBank
//
//  Created by CSC on 15/1/26.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "ReleseBaseView.h"
#import "FYUploadImgTask.h"
#import "MBProgressHUD+Add.h"

@interface ReleseBaseView (){
    MBProgressHUD *_mbp ;
}

@end

@implementation ReleseBaseView

-(id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KColorFromRGB(0xfefefef);
    }
    return self;
}

-(void) startUpImage : (NSArray *) imgs{
    [self onUpImageBegan];
    FYUploadImgTask *task = [FYUploadImgTask new];
    [task upimg:imgs result:^(NSString *result) {
        _houseImages = result;
        [self onUpImageComplete:result];
    }];
}

-(void) onUpImageBegan {
    _mbp = [MBProgressHUD showHUDAddedTo:_vc.view animated:YES];
};

-(void) onUpImageComplete : (NSString *) result {
    [_mbp hide:YES];
};

- (void)dealloc{
    _vc = nil;
    _mbp = nil;
    _doorModelFigure = nil;
    _housePropertyCardFigure = nil;
    _delegateFigure = nil;
}

@end
