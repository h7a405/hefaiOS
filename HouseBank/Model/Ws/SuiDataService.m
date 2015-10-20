//
//  SuiDataService.m
//  客需
//
//  Created by JunJun on 14/12/30.
//  Copyright (c) 2014年 JunJun. All rights reserved.
//

#import "SuiDataService.h"

@implementation SuiDataService
//

+(AFHTTPRequestOperation *)requestWithURL:(NSString *)url  params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionLoad)block withTitle:(NSString *)title{
    
    //创建request请求管理对象
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation * operation = nil;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSComparisonResult comparison1 = [httpMethod caseInsensitiveCompare:@"GET"];
    
    
    
    if (comparison1 == NSOrderedSame) {
        
        operation =[manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSLog(@"请求网络成功");
            block(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求网络失败");
            block(error);
            
        }];
        
    }
    
    //POST请求
    
    NSComparisonResult comparisonResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    
    if (comparisonResult2 == NSOrderedSame)
        
    {
        
        //标示
        
        BOOL isFile = NO;
        
        for (NSString * key in params.allKeys)
            
        {
            
            id value = params[key];
            
            //判断请求参数是否是文件数据
            
            if ([value isKindOfClass:[NSData class]]) {
                
                isFile = YES;
                
                break;
                
            }
            
        }
        
        if (!isFile) {
            
            //参数中没有文件，则使用简单的post请求
            
            operation =[manager POST:url
                        
                          parameters:params
                        
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"网络请求成功");
                                 if (block != nil) {
                                     
                                     block(responseObject);
                                     NSData *doubi = responseObject;
                                     NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
                                     NSLog(@"shabi ＝%@",shabi);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                                 if (block != nil) {
                                     // NSLog(@"请求网络失败:%@", error);
                                     NSLog(@"operation.responseString = %@",operation.responseString);
                                     
                                     block(operation.responseString);
                                     ////合发房银上海iOS开发代码
                                     //                                     if([operation.responseString isEqualToString:@"0"])
                                     //                                     {
                                     //                                         //请求成功
                                     //                                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                     //                                         [alert show];
                                     //                                     }
                                     //
                                     //
                                     
                                 }
                                 
                             }];
            
        }else
            
        {
            
            operation =[manager POST:url
                        
                          parameters:params
                        
           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               
               for (NSString *key in params) {
                   
                   id value = params[key];
                   
                   if ([value isKindOfClass:[NSData class]]) {
                       
                       [formData appendPartWithFileData:value
                        
                                                   name:key
                        
                                               fileName:key
                        
                                               mimeType:@"image/jpeg"];
                       
                   }
                   
               }
               
           } success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               block(responseObject);
               
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
               NSLog(@"请求网络失败");
               
           }];
        }
        
    }
    
    //设置返回数据的解析方式
    
    operation.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    return operation;
    
}





///url为请求地址，params是请求体，传字典进去，，httpMethod 是请求方式，block是请求完成做得工作，header是请求头，也是传字典过去（发送请求获得json数据）,如果没有则传nil,如果只有value而没有key，则key可以设置为anykey
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url requestHeader:(NSDictionary *)header params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionLoad)block{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    //添加请求头
    
    for (NSString *key in header.allKeys) {
        
        [request addValue:header[key] forHTTPHeaderField:key];
        
    }
    
    
    
    //get请求
    
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];
    
    if (compResult1 == NSOrderedSame) {
        
        [request setHTTPMethod:@"GET"];
        
        if(params != nil) {
            
            //添加参数，将参数拼接在url后面
            
            NSMutableString *paramsString = [NSMutableString string];
            
            NSArray *allkeys = [params allKeys];
            
            for (NSString *key in allkeys) {
                
                NSString *value = [params objectForKey:key];
                
                [paramsString appendFormat:@"&%@=%@", key, value];
            }
            
            
            
            if (paramsString.length > 0) {
                [paramsString replaceCharactersInRange:NSMakeRange(0, 1) withString:@"?"];
                
                //重新设置url
                [request setURL:[NSURL URLWithString:[url stringByAppendingString:paramsString]]];
                
            }
            
        }
        
    }
    
    
    
    //post请求
    
    
    
    NSComparisonResult compResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    
    if (compResult2 == NSOrderedSame) {
        
        [request setHTTPMethod:@"POST"];
        
        for (NSString *key in params) {
            
            [request setHTTPBody:params[key]];
            
        }
        
    }
    
    
    
    //发送请求
    
    AFHTTPRequestOperation *requstOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //设置返回数据的解析方式(这里暂时只设置了json解析)
    
    requstOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requstOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block != nil) {
            
            block(responseObject);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        
        if (block != nil) {
            
            block(error);
        }
        
        
        
    }];
    
    
    
    [requstOperation start];
    
    
    
    return requstOperation;
    
}


@end
