//
//  TicTacToeEngine.m
//  TicTacToe
//
//  Created by id on 3/19/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import "TicTacToeBoard.h"
#import "NSString+ConveryToArray.h"


@interface TicTacToeBoard()
@property NSMutableString *boardState;       // 0 for "O", 1 for "X", " " if not yet played
@end

@implementation TicTacToeBoard

-(instancetype) initWithBoardSize:(NSUInteger)boardSize
                       boardState:(NSString *)board {
    // designated initializer
    self = [super init];
    self.boardSize = boardSize;
    self.boardState = [NSMutableString stringWithString:board];
    return self;
}

-(instancetype)initWithBoardSize:(NSUInteger)boardSize {
    NSUInteger squares = boardSize * boardSize;
    NSString *boardState = [@"" stringByPaddingToLength:squares withString: @" " startingAtIndex:0];
    return [self initWithBoardSize:boardSize boardState:boardState];
}

-(instancetype)init {
    return [self initWithBoardSize:3];
}

-(NSArray *)winningGameStates {
    static NSArray *_winningGameStates;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // do progamatically for variable sized boards
        _winningGameStates = @[@"111      ",
                               @"   111   ",
                               @"      111",
                               @"1  1  1  ",
                               @"1   1   1",
                               @"  1 1 1  "];
    });
    return _winningGameStates;
}

-(NSUInteger) getIndexFromRow:(NSUInteger) row column:(NSUInteger)column {
    return (row - 1) * self.boardSize + (column - 1);
}

-(BOOL) canUpdateBoardAtRow:(NSUInteger) row atColumn:(NSUInteger) column {
    if (row > self.boardSize || column > self.boardSize) {
        return NO;
    }
    NSUInteger index = [self getIndexFromRow:row column:column];
    BOOL isBlankAtIndex = [[self.boardState substringFromIndex:index] isEqualToString:@" "];
    return isBlankAtIndex;
}

-(void) updateBoardForCurrentPlayerAtRow:(NSUInteger) row
                                atColumn:(NSUInteger) column {

    if ([self canUpdateBoardAtRow:row atColumn:column]) {
        // takes 1-index values
        NSUInteger index = [self getIndexFromRow:row column:column];
        NSRange replacementRange = NSMakeRange(index, 1);
        [self.boardState replaceCharactersInRange:replacementRange
                                       withString:self.playerTurn];
    }

    if ([self currentGameState] == GameStateStarted) {
        [self toggleCurrentPlayer];
    }
}

-(void) toggleCurrentPlayer {
    if ([self.playerTurn isEqualToString:@"X"]) {
        self.playerTurn = @"O";
    } else {
        self.playerTurn = @"X";
    }

}

-(GameState) currentGameState {
    if ([self didCurrentPlayerWin]) {
        return GameStateWon;
    } else if ([self isGameTied]) {
        return GameStateTied;
    } else if ([self isGameEmpty]) {
        return GameStateEmpty;
    } else return GameStateStarted;
}

-(BOOL) didCurrentPlayerWin {
    NSArray *winningGameStates = [self winningGameStates];
    BOOL __block didWin = NO;
    [winningGameStates enumerateObjectsWithOptions:NSEnumerationConcurrent
                                        usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *regexError;
            NSString *tmp = [obj stringByReplacingOccurrencesOfString:@"1" withString:self.playerTurn];
            NSString *playerMatch= [tmp stringByReplacingOccurrencesOfString:@" " withString:@"."];

            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:playerMatch
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&regexError];

            if (regexError) {
                NSLog(@"Regex creation failed with error: %@", [regexError description]);
            }

            NSRange fullRange = NSMakeRange(0, self.boardState.length);
            NSUInteger matches = [regex numberOfMatchesInString:self.boardState
                                                        options:0
                                                          range:fullRange];
            if (matches > 0){
                *stop = YES;
                didWin = YES;
            }
        }];
     return didWin;
}

-(BOOL) boardFull {
    return ([[self.boardState componentsSeparatedByString:@" "] count ] - 1) == 0;
}

-(BOOL) isGameTied {
    // check count of blank spaces, if zero, board full and no win
    return ([self boardFull] && ![self didCurrentPlayerWin]);
}

-(BOOL) isGameEmpty {
    NSUInteger boxes = self.boardSize * self.boardSize;
    NSString *emptyBoard = [@"" stringByPaddingToLength:boxes withString: @" " startingAtIndex:0];
    return ([emptyBoard isEqualToString:self.boardState]);
}

@end