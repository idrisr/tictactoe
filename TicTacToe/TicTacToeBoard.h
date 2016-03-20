//
//  TicTacToeEngine.h
//  TicTacToe
//
//  Created by id on 3/19/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GameState) {
    GameStateEmpty = 0,
    GameStateStarted,
    GameStateWon,
    GameStateTied
};

@interface TicTacToeBoard : NSObject

@property NSString *playerTurn;
@property NSUInteger boardSize;

-(GameState) currentGameState;

-(void) updateBoardForCurrentPlayerAtRow:(NSUInteger) row atColumn:(NSUInteger)column; // 1 indexed for human brains
-(instancetype) initWithBoardSize:(NSUInteger)boardSize boardState:(NSString *)board;
-(instancetype) initWithBoardSize:(NSUInteger)boardSize;

@end
