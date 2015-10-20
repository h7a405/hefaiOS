//
//  SuiDataService.h
//  客需
//
//  Created by JunJun on 14/12/30.
//  Copyright (c) 2014年 JunJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^CompletionLoad)(id  result);
@interface SuiDataService : NSObject
///如果请求中没有请求头，使用此方法，如果需要传图片则需要将图片封装成NSDate，装到params中，url为地址，params为请求体没有传nil，get和post方法可以忽略大小写

+(AFHTTPRequestOperation *)requestWithURL:(NSString *)url  params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionLoad)block withTitle:(NSString *)title;


///url为请求地址，params是请求体，传字典进去，，httpMethod 是请求方式，block是请求完成做得工作，header是请求头，也是传字典过去（发送请求获得json数据）,如果没有则传nil,如果只有value而没有key，则key可以设置为anykey（但是此方法暂时没设置传图片）

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url

                             requestHeader:(NSDictionary *)header

                                    params:(NSMutableDictionary *)params

                                httpMethod:(NSString *)httpMethod

                                     block:(CompletionLoad)block

;


@end
