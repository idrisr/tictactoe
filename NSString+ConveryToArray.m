//
//  NSString+ConveryToArray.m
//  TicTacToe
//
//  Created by id on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import "NSString+ConveryToArray.h"

@implementation NSString (ConvertToArray)

-(NSArray *) convertToArray {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i < self.length; i++) {
        [arr addObject:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    return arr;
}

-(NSIndexSet *) toIndexSetMatchingString:(NSString *)matchString {
    NSArray *arr = [self convertToArray];
    NSIndexSet *indexSet = [arr indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isEqualToString:matchString];
    }];
    return indexSet;
}

@end
