//
//  ViewController.m
//  TicTacToe
//
//  Created by Brandon Gress on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, GameState) {
    GameStateEmtpy = 1,
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
@property NSUInteger turnIndex;
@property NSMutableString *boardState;       // 0 for "O", 1 for "X", undefined if not yet played
@property NSString *playerTurn;
@property NSArray* winningGameStates;

@end

@implementation ViewController

+ (NSArray *)winningGameStates {
    static NSArray *_winningGameStates;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                            //  "123456789"
        _winningGameStates = @[@"XXX      ",
                               @"   XXX   ",
                               @"      XXX",
                               @"X  X  X  ",
                               @" X  X  X ",
                               @"  X  X  X",
                               @"X   X   X",
                               @"  X X X  "];
    });
    return _winningGameStates;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.turnIndex = 0;
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
        [self togglePlayerTurn];
        NSLog(self.boardState);


    } else {
        // TODO: give user feedback
    }
}

-(void) analyzeGameState {
    NSArray *winningGameStates = [self winningGameStates];

}

@end