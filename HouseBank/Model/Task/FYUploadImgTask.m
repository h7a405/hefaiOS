//
//  FYUploadImgTask.m
//  HouseBank
//
//  Created by CSC on 15/1/26.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "FYUploadImgTask.h"
#import "UpYun.h"
#import "UpImgBean.h"

@interface FYUploadImgTask (){
    NSArray *_upImages ;
    UpImgResult _result ;
}

@end

@implementation FYUploadImgTask

-(id) init{
    if(self = [super init]){
        
    }
    return self;
}

-(void) upimg:(NSArray *)imgs result:(UpImgResult)result{
    if (imgs && imgs.count) {
        _upImages = imgs ;
        _result = result ;
        [self doTask];
    }else{
        result(@"");
    }
}

-(void) doTask {
    __block NSInteger currentCompleteCount = 0;
    __block NSString *outResult = @"";
    
    for (UpImgBean *bean in _upImages) {
        __block int type = bean.type ;
        __block int mark = bean.mainMark;
        UIImage *image = bean.img ;
        
        UpYun *uy = [UpYun new] ;
        uy.successBlocker = ^(id result){
            NSString *str = [NSString stringWithFormat:@"%d,%d,/%@",mark,type,result[@"url"]];
            currentCompleteCount++ ;
            
            outResult = [outResult stringByAppendingString:str];
            
            if (currentCompleteCount == _upImages.count) {
                _result(outResult);
            }else{
                outResult = [outResult stringByAppendingString:@";"];
            }
        };
        
        uy.failBlocker = ^(NSError *error){
            currentCompleteCount++;
            if (currentCompleteCount == _upImages.count) {
                _result(outResult);
            }
        };
        
        [uy uploadImageData:UIImageJPEGRepresentation(image, 1) savekey:[NSString stringWithFormat:@"%d/%@.jpg",type,[[TextUtil stringUUID] lowercaseString]]];
    }
};

-(void) dealloc{
    _upImages = nil ;
}

@end
