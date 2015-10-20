//
//  UIImage+Helper.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

/**
 *  压缩图片分辨率
 *
 *  @param image
 *  @param size
 *
 *  @return
 */
-(UIImage*) scaleToSize:(CGSize)size;

+(UIImage *)imageWithColor:(UIColor *)color;

-(UIImage *)stretchableImage;
-(UIImage *)stretchableImageForHomeButton;
-(UIImage *)stretchableImageForHome;

@end
