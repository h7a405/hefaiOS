//
//  FYBaseTask.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//任务类委托
@protocol TaskProtocol <NSObject>
//开始任务
-(void) doTask;
@end

@interface FYBaseTask : NSObject<TaskProtocol>

@end
