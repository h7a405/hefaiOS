//
//  Images.m
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HouseInfoImageBean.h"
#import "NSObject+Json.h"

NSString *const kImagesImageType = @"imageType";
NSString *const kImagesDefaulted = @"defaulted";
NSString *const kImagesImageId = @"imageId";
NSString *const kImagesImagePath = @"imagePath";



@implementation HouseInfoImageBean

@synthesize imageType = _imageType;
@synthesize defaulted = _defaulted;
@synthesize imageId = _imageId;
@synthesize imagePath = _imagePath;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.imageType =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kImagesImageType fromDictionary:dict]];
        self.defaulted = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kImagesDefaulted fromDictionary:dict]];
        self.imageId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kImagesImageId fromDictionary:dict]];
        
        self.imagePath =[NSString stringWithFormat:@"%@",[Tool imageUrlWithPath:[self objectOrNilForKey:kImagesImagePath fromDictionary:dict] andTypeString:@"B01"]];
    }
    
    return self;
    
}

@end
