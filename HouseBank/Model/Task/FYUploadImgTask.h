//
//  FYUploadImgTask.h
//  HouseBank
//
//  Created by CSC on 15/1/26.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "FYBaseTask.h"


typedef void(^UpImgResult)(NSString *result);

@interface FYUploadImgTask : FYBaseTask

-(void) upimg : (NSArray *) imgs result : (UpImgResult) result;

@end
