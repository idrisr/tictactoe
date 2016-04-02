//
//  UIColor+CustomColor.m
//  TicTacToe
//
//  Created by id on 3/20/16.
//  Copyright © 2016 Id Raja. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (HexValues)

+ (UIColor *)colorWithHex:(NSUInteger)hexValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0
                           alpha:1.0];
}

@end

@implementation UIColor (CustomColors)

+ (UIColor *)blue {
    static UIColor *sBlue = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSUInteger hexColor = 0x4DABAF;
        sBlue = [UIColor colorWithHex:hexColor];
    });

    return sBlue;
}

+ (UIColor *)brown {
    static UIColor *sBrown = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSUInteger hexColor = 0x716253;
        sBrown = [UIColor colorWithHex:hexColor];
    });

    return (UIColor *)sBrown;
}


+ (UIColor *)lightBlue {
    static UIColor *sLightBlue = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSUInteger hexColor = 0xCBDADB;
        sLightBlue = [UIColor colorWithHex:hexColor];
    });

    return sLightBlue;
}

+ (UIColor *)green {
    static UIColor *sGreen = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSUInteger hexColor = 0x5A8462;
        sGreen = [UIColor colorWithHex:hexColor];
    });

    return sGreen;
}

+ (UIColor *)black {
    static UIColor *sBlack = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSUInteger hexColor = 0x1D1D1D;
        sBlack = [UIColor colorWithHex:hexColor];
    });

    return sBlack;
}


+ (UIColor *)plum {
    static UIColor *sPlum = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSUInteger hexColor = 0xB472A5;
        sPlum = [UIColor colorWithHex:hexColor];
    });

    return sPlum;
}

@end
