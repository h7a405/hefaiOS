//
//  ViewUtil.m
//  Jnrlink
//
//  Created by apple on 14-4-21.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import "ViewUtil.h"

#define color(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]

@implementation ViewUtil

//根据颜色返回图片
+(UIImage*) imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)targetSize{
    CGSize sourceSize = img.size;
    float widthScale = (float)(targetSize.width/sourceSize.width);
    float heightScale = (float)(targetSize.height/sourceSize.height);
    
    float scale = MAX(widthScale, heightScale);
    scale = scale > 1 ? 1 : scale ;
    
    UIImage *newImage = [UIImage imageWithCGImage:[img CGImage] scale:scale orientation:UIImageOrientationUp];
    
    return newImage;
}

+(UIColor *) string2Color : (NSString *) color{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 charactersß®
    if ([cString length] < 6)
        return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6 && [cString length] != 8)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    int rgbOffset = 0;
    
    NSString *aString = nil;
    //a
    if (cString.length == 6)
        aString = @"FF";
    else{
        aString =  [cString substringWithRange:range];
        rgbOffset = 2;
    }
    
    
    
    //r
    range.location = rgbOffset;
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2+rgbOffset;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4+rgbOffset;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int a,r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a/ 255.0f)] ;
};

+(void) logRect : (CGRect) rect{
    NSLog(@"x= %f , y= %f , w= %f , h= %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
};

+(void) logPoint:(CGPoint) point{
    NSLog(@"x= %f , y= %f",point.x,point.y);
}

+(void) logTramform : (CGAffineTransform) transform{
    NSLog(@"a= %f , b= %f , c= %f , d= %f , tx= %f , ty= %f",transform.a,transform.b,transform.c,transform.d,transform.tx,transform.ty);
};

+(void) logSize : (CGSize) size {
    NSLog(@"width= %f , height= %f",size.width,size.height);
};

+(void) logFontNames {
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames){
        NSLog(@"%@", familyName);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames){
            NSLog(@"\t\t%@", fontName);
        }
    }
};

+(BOOL) isFontExists : (NSString *) fn {
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames){
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames){
            if([fontName isEqualToString:fn])
                return true;
        }
    }
    return false;
};

+ (UIImage*)imageFromView:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+(BOOL) containsPoint:(CGPoint) point vertex: (CGPoint[]) vertexPointFs lenght : (int) length{
    int nCross = 0;
    for (int i = 0; i < length; i++) {
        CGPoint p1 = vertexPointFs[i];
        
        CGPoint p2 = vertexPointFs[(i + 1) % length];
        if (p1.y == p2.y)
            continue;
        if (point.y < MIN(p1.y, p2.y))
            continue;
        if (point.y >= MAX(p1.y, p2.y))
            continue;
        double x = (double) (point.y - p1.y) * (double) (p2.x - p1.x)
        / (double) (p2.y - p1.y) + p1.x;
        if (x > point.x)
            nCross++;
    }
    
    return (nCross % 2 == 1);
}

+(BOOL) containsPoint:(CGPoint)point vertex:(CGRect) rect{
    CGPoint points[4];
    points[0] = CGPointMake(rect.origin.x, rect.origin.y);
    points[1] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    points[2] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    points[3] = CGPointMake(rect.origin.x , rect.origin.y + rect.size.height);
    
    return [self containsPoint:point vertex:points lenght:4];
};

//获得某个范围内的屏幕图像
+(UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

+(float) distanceBetweenPoint : (CGPoint )point1 point2 : (CGPoint ) point2{
    float xOffset = point1.x - point2.x;
    float yOffset = point2.y - point1.y;
    
    float  distance = sqrtf(xOffset*xOffset+yOffset*yOffset);
    return distance;
};

+(UIView *)xibView:(NSString *)name{
    return [[NSBundle mainBundle]loadNibNamed:name owner:nil options:nil][0];
}

+(NSAttributedString *)content:(NSString *)content colorString:(NSString *)search{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:[UIColor redColor] range:[content rangeOfString:search]];
    return attString;
}

+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        scaleFactor = MIN(widthFactor, heightFactor);
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    UIGraphicsBeginImageContext(thumbnailRect.size);
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
