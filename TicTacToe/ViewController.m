//
//  ViewController.m
//  TicTacToe
//
//  Created by Brandon Gress on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//


#import "ViewController.h"
#import "NSString+ConveryToArray.h"

typedef NS_ENUM(NSInteger, GameState) {
    GameStateEmtpy = 1,
    GameStateDraw,
    GameStateTie,
    GameStateXWin,
    GameStateOWin
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property NSMutableString *boardState;       // 0 for "O", 1 for "X", undefined if not yet played
@property NSString *playerTurn;
//@property NSArray* winningGameStates;
@end

@implementation ViewController

+ (NSArray<NSString *> *)winningGameStates {
    static NSArray *_winningGameStates;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                            //  "123456789"
        _winningGameStates = @[@"111      ",
                               @"   111   ",
                               @"      111",
                               @"1  1  1  ",
                               @" 1  1  1 ",
                               @"  1  1  1",
                               @"1   1   1",
                               @"  1 1 1  "];
    });
    return _winningGameStates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *startingBoardState = [@"" stringByPaddingToLength:9 withString: @" " startingAtIndex:0];
    self.boardState = [NSMutableString stringWithString:startingBoardState];
    self.turnLabel.font = [UIFont systemFontOfSize:25];
    self.playerTurn = @"X";
    [self updateTurnLabel];
}

-(void) updateTurnLabel {
    self.turnLabel.text = self.playerTurn;
}

-(void) togglePlayerTurn {
    if ([self.playerTurn isEqualToString:@"X"]) {
        self.playerTurn = @"O";
    } else {
        self.playerTurn = @"X";
    }
    [self updateTurnLabel];
}

-(IBAction) onButtonTapped:(UIButton*)button {
    NSUInteger tag = button.tag;
    NSUInteger index = tag / 10 - 1;
    NSString *currentValue = button.titleLabel.text;

    if (currentValue == nil) {
        // update button appearance
        [button setTitle:self.playerTurn forState:UIControlStateNormal];
        if ([self.playerTurn isEqualToString:@"X"]) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }

        // update game board state
        NSString *updatedBoardState =[self.boardState stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:self.playerTurn];
        self.boardState = [NSMutableString stringWithString:updatedBoardState];
        [self didCurrentPlayerWin];
        [self togglePlayerTurn];
    } else {
        // TODO: give user feedback
    }
}

-(BOOL) didCurrentPlayerWin {
    NSArray *winningGameStates = [ViewController winningGameStates];
    NSInteger __block winningIndex = -1;
    BOOL __block win = NO;
    [winningGameStates enumerateObjectsWithOptions:NSEnumerationConcurrent
                                        usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexSet *winIndexSet = [obj toIndexSetMatchingString:@"1"];                           // indexes of a winning game state
        NSIndexSet *playerIndexSet = [self.boardState toIndexSetMatchingString:self.playerTurn]; // indexes of current players moves

        // check if winning position is contained in current players moves
        if ([playerIndexSet containsIndexes:winIndexSet]) {
            winningIndex = idx;
            *stop = YES;
            NSLog(@"Win with index: %li", winningIndex);
            win = YES;
        } }];
    return win;
}

@end