//
//  UIImage+Helper.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

-(UIImage*)scaleToSize:(CGSize)size;
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(UIImage *)stretchableImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width*0.5 topCapHeight:self.size.height*0.5];
}

-(UIImage *)stretchableImageForHomeButton
{
    return [self stretchableImageWithLeftCapWidth:self.size.width*0.7 topCapHeight:self.size.height*0.9];
}

-(UIImage *)stretchableImageForHome
{
    return [self stretchableImageWithLeftCapWidth:self.size.width*0.1 topCapHeight:self.size.height*0.1];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
