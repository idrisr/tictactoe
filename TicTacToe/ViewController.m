//
//  ViewController.m
//  TicTacToe
//
//  Created by Brandon Gress on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import "ViewController.h"
#import "TicTacToeBoard.h"
#import "NSString+ConveryToArray.h"

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
@property TicTacToeBoard *gameEngine;

@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@end

@implementation ViewController

// todo - move game engine into its own class with sensible interface

//-(void) startGame {
//    NSString *startingBoardState = [@"" stringByPaddingToLength:9 withString: @" " startingAtIndex:0];
//    self.boardState = [NSMutableString stringWithString:startingBoardState];
//    self.playerTurn = @"X";
//    [self updateTurnLabel];
//    for (int i = 1; i < startingBoardState.length + 1; i++) {
//        NSUInteger tag = i * 10;
//        UIButton *button = (UIButton *) [self.view viewWithTag:tag];
//        button.layer.cornerRadius = 10;
//        button.layer.borderWidth = 2;
//        button.layer.borderColor = [UIColor blueColor].CGColor;
//        button.titleLabel.font = [UIFont systemFontOfSize:40];
//        [button setTitle:@" " forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//}
//
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self startGame];
//};
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.turnLabel.font = [UIFont systemFontOfSize:40];
//}
//
//-(void) updateTurnLabel {
//    self.turnLabel.text = self.playerTurn;
//    if ([self.playerTurn isEqualToString:@"X"]) {
//        self.turnLabel.textColor = [UIColor redColor];
//    } else {
//        self.turnLabel.textColor = [UIColor blueColor];
//    }
//}
//
//-(void) togglePlayerTurn {
//    if ([self.playerTurn isEqualToString:@"X"]) {
//        self.playerTurn = @"O";
//    } else {
//        self.playerTurn = @"X";
//    }
//    [self updateTurnLabel];
//}
//
//-(IBAction) onButtonTapped:(UIButton*)button {
//    NSUInteger tag = button.tag;
//    NSUInteger index = tag / 10 - 1;
//    NSString *currentValue = button.titleLabel.text;
//
//    if ([currentValue isEqualToString:@" "]) {
//        // update button appearance
//        [button setTitle:self.playerTurn forState:UIControlStateNormal];
//        if ([self.playerTurn isEqualToString:@"X"]) {
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        } else {
//            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        }
//
//        // update game board state
//        NSString *updatedBoardState =[self.boardState stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:self.playerTurn];
//        self.boardState = [NSMutableString stringWithString:updatedBoardState];
//        if ([self didCurrentPlayerWin]) {
//            [self playerWon];
//            return;
//        }
//        [self togglePlayerTurn];
//    } else {
//        // TODO: give user feedback
//    }
//}
//
//
//- (IBAction)panGesture:(id)sender {
//    NSLog(@"pan");
//}
//
@end