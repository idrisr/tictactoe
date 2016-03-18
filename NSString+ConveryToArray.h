//
//  NSString+ConveryToArray.h
//  TicTacToe
//
//  Created by id on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ConveryToArray)
-(NSIndexSet *) toIndexSetMatchingString:(NSString *)matchString;
@end