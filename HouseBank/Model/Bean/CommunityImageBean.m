//
//  Images.m
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CommunityImageBean.h"
#import "NSObject+Json.h"

NSString *const kImagesImageIdForCommunity = @"imageId";
NSString *const kImagesDefaultedForCommunity = @"defaulted";
NSString *const kImagesImagePathForCommunity = @"imagePath";



@implementation CommunityImageBean

@synthesize imageId = _imageId;
@synthesize defaulted = _defaulted;
@synthesize imagePath = _imagePath;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.imageId =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kImagesImageIdForCommunity fromDictionary:dict]];
        self.defaulted = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kImagesDefaultedForCommunity fromDictionary:dict]];
        self.imagePath =[NSString stringWithFormat:@"%@",[Tool imageUrlWithPath:[self objectOrNilForKey:kImagesImagePathForCommunity fromDictionary:dict] andTypeString:@"B01"]];
    }
    return self;
}




@end
