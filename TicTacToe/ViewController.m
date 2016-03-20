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

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property NSArray<UIButton*> *buttonArray;
@property TicTacToeBoard *gameEngine;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;

-(void) restartGame;
-(void) layoutBoard;
@end

static void *playerTurnContext = &playerTurnContext;
static void *boardStateContext = &boardStateContext;
static void *currentGameStateContext = &currentGameStateContext;

@implementation ViewController

#pragma mark - view life cycle
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateTurnLabel];
    [self layoutBoard];
}

-(NSInteger) buttonThatIntersectsWithView:(UIView *) view {
    NSInteger __block buttonTag = -1;
    [self.buttonArray enumerateObjectsWithOptions:NSEnumerationConcurrent
                                       usingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                                           BOOL intersect = CGRectIntersectsRect(self.turnLabel.frame, button.frame);
                                           if (intersect) {
                                                buttonTag = button.tag;
                                                *stop = YES;
                                           }
                                       }];
    return buttonTag;
}

-(void) moveObject:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        NSInteger tagIntersect = [self buttonThatIntersectsWithView:self.turnLabel];
        BOOL doesIntersect = tagIntersect != -1;
        UIButton *button = nil;
        if (doesIntersect) {
            button = [self.view viewWithTag:tagIntersect];
        } else {
            return;
        }
        NSArray *rowCol = [self getBoardIndexesFromButton:button];
        NSUInteger row = [[rowCol firstObject] integerValue];
        NSUInteger col = [[rowCol lastObject] integerValue];

        BOOL canMoveToSquare = [self.gameEngine canUpdateBoardAtRow:row atColumn:col];

        // if label location on one of the squares AND can update that square for current game state
        if (canMoveToSquare && tagIntersect) {
            // tell the board that a move was made on that square
            [self.gameEngine updateBoardForCurrentPlayerAtRow:row atColumn:col];
        } else {
            // snap it back to where it was
            [UIView animateWithDuration:0.5
                             animations:^{
                                 CGPoint currentSpot = [panGesture translationInView:self.view];
                                 CGPoint oldPoint = CGPointMake(self.turnLabel.center.x - currentSpot.x, self.turnLabel.center.y - currentSpot.y);
                                 self.turnLabel.center = oldPoint;
                             }
                             completion:nil
             ];
        }
    // keep moving the label around the screen
    } else {
        self.turnLabel.center = [panGesture locationInView:self.turnLabel.superview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttonArray = @[self.button1, self.button2, self.button3,
                         self.button4, self.button5, self.button6,
                         self.button7, self.button8, self.button9];

    self.turnLabel.font = [UIFont systemFontOfSize:40];

    // set up pan gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveObject:)];
    [self.turnLabel addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    [self.turnLabel setUserInteractionEnabled:YES];


    self.gameEngine = [[TicTacToeBoard alloc] init];
    // setup kvo on game engine
    [self.gameEngine addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(playerTurn))
                         options:0
                         context:playerTurnContext];

    [self.gameEngine addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(boardState))
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                         context:boardStateContext];

    [self.gameEngine addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(currentGameState))
                         options:0
                         context:currentGameStateContext];
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context {
    if (context == playerTurnContext){
        [self updateTurnLabel];
    } else if (context == boardStateContext) {
        [self updateBoardForChange:change];
    } else if (context == currentGameStateContext) {
        [self checkGameStatus];
    }
}

-(void) checkGameStatus {
    switch (self.gameEngine.currentGameState) {
        case GameStateEmpty:
            break;

        case GameStateStarted:
            break;

        case GameStateWon:
            [self showAlertGameOver];
            break;

        case GameStateTied:
            [self showAlertGameOver];
            break;

        default:
            break;
    }
}

-(void) showAlertGameOver {
    NSString *title = nil;
    if (self.gameEngine.currentGameState == GameStateWon) {
        title = [NSString stringWithFormat:@"Player %@ Won!", self.gameEngine.playerTurn];
    } else if (self.gameEngine.currentGameState == GameStateTied) {
        title = @"Game Tied";
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    UIAlertAction *playAgain = [UIAlertAction actionWithTitle:@"Play Again"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self restartGame];
                                                          [self layoutBoard];
                                                      }];
    [alert addAction:cancelAction];
    [alert addAction:playAgain];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void) restartGame {
    NSUInteger squares = self.gameEngine.boardSize * self.gameEngine.boardSize;
    NSString *boardState = [@"" stringByPaddingToLength:squares withString: @" " startingAtIndex:0];
    self.gameEngine.boardState = [NSMutableString stringWithString:boardState];
}

-(void) layoutBoard {
    self.turnLabel.text = self.gameEngine.playerTurn;
    NSUInteger squares = self.gameEngine.boardSize * self.gameEngine.boardSize;
    for (int i = 1; i < squares + 1; i++) {
        NSUInteger tag = i * 10;
        UIButton *button = (UIButton *) [self.view viewWithTag:tag];
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor blueColor].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:40];
        [button setTitle:@" " forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void) updateBoardForChange:(NSDictionary *)change {
    NSString *new = change[@"new"];
    NSString *old = change[@"old"];

    int i = 0;
    for (i = 0; i < new.length; i++) {
        if ([old characterAtIndex:i] != [new characterAtIndex:i]) {
            break;
        }
    }

    NSUInteger tag = (i + 1) * 10;
    UIButton *button = [self.view viewWithTag:tag];
    NSRange range = NSMakeRange(i, 1);
    [button setTitle:[self.gameEngine.boardState substringWithRange:range]
            forState:UIControlStateNormal];

    // TODO: repeated code, fix this;
    UIColor *buttonColor = ([self.gameEngine.playerTurn isEqualToString:@"O"]) ? [UIColor redColor] : [UIColor blueColor];
    [button setTitleColor:buttonColor forState:UIControlStateNormal];
}

-(void) updateTurnLabel {
    self.turnLabel.text = self.gameEngine.playerTurn;
    self.turnLabel.textColor = [self.gameEngine.playerTurn isEqualToString:@"O"] ? [UIColor redColor] : [UIColor blueColor];
}

-(NSArray*) getBoardIndexesFromButton:(UIButton *) button {
    NSUInteger tag = button.tag;
    NSUInteger index = tag / 10;
    NSUInteger row = ((index - 1) / 3) + 1;
    NSUInteger column = ((tag - 1) % self.gameEngine.boardSize) + 1;
    return @[@(row), @(column)];
}

-(IBAction) onButtonTapped:(UIButton*)button {
    NSArray *rowCol = [self getBoardIndexesFromButton:button];
    NSUInteger row = [[rowCol firstObject]integerValue];
    NSUInteger col = [[rowCol lastObject]integerValue];
    [self.gameEngine updateBoardForCurrentPlayerAtRow:row atColumn:col];
}

-(void)dealloc {
    [self removeObserver:self.gameEngine forKeyPath:NSStringFromSelector(@selector(playerTurn))];
    [self removeObserver:self.gameEngine forKeyPath:NSStringFromSelector(@selector(boardState))];
    [self removeObserver:self.gameEngine forKeyPath:NSStringFromSelector(@selector(currentGameState))];
}

@end
