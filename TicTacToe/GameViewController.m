//
//  ViewController.m
//  TicTacToe
//
//  Created by Brandon Gress on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import "GameViewController.h"
#import "TicTacToeBoard.h"
#import "UIColor+CustomColor.h"

typedef NS_ENUM (NSUInteger, ViewCorner){
    ViewCornerTopLeft = 0,
    ViewCornerTopRight,
    ViewCornerBottomLeft,
    ViewCornerBottomRight
};

@interface GameViewController () <UIGestureRecognizerDelegate>

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
@property UIDynamicAnimator *animator;
@property UISnapBehavior *snapBehavior;
@property CGPoint turnLabelStartPoint;
@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

-(void) layoutBoard;
@end

static void *playerTurnContext = &playerTurnContext;
static void *boardStateContext = &boardStateContext;
static void *currentGameStateContext = &currentGameStateContext;

@implementation GameViewController

#pragma mark - view life cycle

-(NSDictionary <NSNumber*, NSValue* > *)viewPositions{
    // dict of form tag#:CGPoint wrapped in NSValue
    static NSMutableDictionary *_viewPositions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // do progamatically for variable sized boards
        _viewPositions = [NSMutableDictionary new];
        for (UIView *view in self.view.subviews) {
            long tag = view.tag;
            if (tag == 0){
                continue;
            }
            [_viewPositions setObject:[NSValue valueWithCGPoint:view.center]
                               forKey:[NSNumber numberWithLong:tag]];

        }
    });
    return [NSDictionary dictionaryWithDictionary:_viewPositions];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // set up original view positions for later
    [self viewPositions];

    if (self.gameEngine.currentGameState == GameStateEmpty) {
        [self updateTurnLabel];
        [self layoutBoard];
    }

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.snapBehavior.snapPoint = self.turnLabel.center;
    self.snapBehavior.damping = 0.5f;

    [self.animator addBehavior:self.snapBehavior];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor black];

    self.buttonArray = @[self.button1, self.button2, self.button3,
                         self.button4, self.button5, self.button6,
                         self.button7, self.button8, self.button9];

    self.turnLabel.font = [UIFont systemFontOfSize:40];

    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.turnLabel snapToPoint:self.turnLabel.center];

    // set up play again button
    self.playAgainButton.layer.cornerRadius = 10;
    self.playAgainButton.layer.borderWidth = 2;
    self.playAgainButton.layer.borderColor = [UIColor lightBlue].CGColor;
    self.playAgainButton.titleLabel.textColor = [UIColor lightBlue];
    self.playAgainButton.titleLabel.font = [UIFont systemFontOfSize:30];
//    self.playAgainButton.backgroundColor = [UIColor brown];

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
                         options:NSKeyValueObservingOptionNew
                         context:currentGameStateContext];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[self navigationController] setNavigationBarHidden:NO];
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
        }
        NSArray *rowCol = [self getBoardIndexesFromButton:button];
        NSUInteger row = [[rowCol firstObject] integerValue];
        NSUInteger col = [[rowCol lastObject] integerValue];

        BOOL canMoveToSquare = [self.gameEngine canUpdateBoardAtRow:row atColumn:col];

        // if label location on one of the squares AND can update that square for current game state
        if (canMoveToSquare && tagIntersect) {
            // tell the board that a move was made on that square
            [self.gameEngine updateBoardForCurrentPlayerAtRow:row atColumn:col];
        }
        // snap it back to where it was
        [self.animator updateItemUsingCurrentState:self.turnLabel];
    // keep moving the label around the screen
    } else {
        self.turnLabel.center = [panGesture locationInView:self.turnLabel.superview];
    }
}


#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context {
    if (context == playerTurnContext){
        [self updateTurnLabel];
    } else if (context == boardStateContext) {
        [self updateBoardForChanges:change];
    } else if (context == currentGameStateContext) {
        [self checkGameStatus];
    }
}

-(void) checkGameStatus {
    switch (self.gameEngine.currentGameState) {
        case GameStateEmpty:
            break;

        case GameStateStarted:
//            [self pushTurnLabel];
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

-(void) pushTurnLabel {
    NSLog(@"in push turn label");
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.turnLabel] mode:UIPushBehaviorModeContinuous];
    [push setAngle:M_PI magnitude:10.0f];
    [self.animator addBehavior:push];
    push.active = YES;
}

-(CGSize) getStandardButtonSize {
    UIButton *button = (UIButton *)[self.view viewWithTag:10];
    return button.bounds.size;
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

    UIAlertAction *actionAlert = [UIAlertAction actionWithTitle:@"Play Again"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self.animator removeAllBehaviors];
                                                          NSArray *nonButtonItems = @[self.turnLabel, self.playAgainButton, self.helpButton];
                                                          NSArray *dynamicItems = [self.buttonArray arrayByAddingObjectsFromArray:nonButtonItems];
                                                          [self.playAgainButton setHidden:NO];

                                                          UIDynamicItemBehavior *dynamics = [[UIDynamicItemBehavior alloc] initWithItems:dynamicItems];
                                                          dynamics.elasticity = 1.0;
                                                          dynamics.allowsRotation = YES;
                                                          dynamics.charge = -1.0;

                                                          UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:dynamicItems];
                                                          UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:dynamicItems];

                                                          CGPoint topLeft = [self pointForCorner:ViewCornerTopLeft forView:self.view];
                                                          CGPoint topRight = [self pointForCorner:ViewCornerTopRight forView:self.view];
                                                          CGPoint bottomLeft = [self pointForCorner:ViewCornerBottomLeft forView:self.view];
                                                          CGPoint bottomRight = [self pointForCorner:ViewCornerBottomRight forView:self.view];

                                                          [collision addBoundaryWithIdentifier:@"left" fromPoint:topLeft toPoint:bottomLeft];
                                                          [collision addBoundaryWithIdentifier:@"bottom" fromPoint:bottomLeft toPoint:bottomRight];
                                                          [collision addBoundaryWithIdentifier:@"right" fromPoint:topRight toPoint:bottomRight];
                                                          [collision addBoundaryWithIdentifier:@"top" fromPoint:topLeft toPoint:topRight];

                                                          [self.animator addBehavior:gravity];
                                                          [self.animator addBehavior:collision];
                                                          [self.animator addBehavior:dynamics];
                                                          [self.animator addBehavior:self.snapBehavior];
                                                          [dynamicItems enumerateObjectsWithOptions:NSEnumerationConcurrent
                                                                                             usingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                                                 [self.animator updateItemUsingCurrentState:obj];
                                                                                             }];
                                                      }];

    [alert addAction:actionAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

-(CGPoint) pointForCorner:(ViewCorner)corner
                  forView:(UIView *) view {
    CGFloat x = 0;
    CGFloat y = 0;
    CGRect rect = view.frame;
    switch (corner) {
        case ViewCornerTopLeft:
            x = rect.origin.x;
            y = rect.origin.y;
            break;

        case ViewCornerTopRight:
            x = rect.origin.x + rect.size.width;
            y = rect.origin.y;
            break;

        case ViewCornerBottomLeft:
            x = rect.origin.x;
            y = rect.origin.y + rect.size.height;
            break;

        case ViewCornerBottomRight:
            x = rect.origin.x + rect.size.width;
            y = rect.origin.y + rect.size.height;
            break;

        default:
            x = 0;
            y = 0;
    }
    return CGPointMake(x, y);
}


-(void) layoutBoard {
    self.turnLabel.text = self.gameEngine.playerTurn;

    for (UIButton *button in self.buttonArray) {
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor blue].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:40];
        [button setTitle:@" " forState:UIControlStateNormal];
    }
}

-(void) updateBoardForChanges:(NSDictionary *)change {
    NSString *new = change[@"new"];
    NSString *old = change[@"old"];
    NSMutableArray *changes = [NSMutableArray new];

    for (int i = 0; i < new.length; i++) {
        if ([old characterAtIndex:i] != [new characterAtIndex:i]) {
            [changes addObject:@(i)];
        }
    }

    [changes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int i = [obj intValue];
        NSUInteger tag = (i + 1) * 10;
        UIButton *button = [self.view viewWithTag:tag];
        NSRange range = NSMakeRange(i, 1);
        [button setTitle:[self.gameEngine.boardState substringWithRange:range]
                forState:UIControlStateNormal];

        // TODO: repeated code, fix this;
        UIColor *buttonColor = ([self.gameEngine.playerTurn isEqualToString:@"O"]) ? [UIColor green] : [UIColor plum];
        [button setTitleColor:buttonColor forState:UIControlStateNormal];
        button.layer.borderColor = buttonColor.CGColor;
    }];
}

-(void) updateTurnLabel {
    self.turnLabel.text = self.gameEngine.playerTurn;
    self.turnLabel.textColor = [self.gameEngine.playerTurn isEqualToString:@"O"] ? [UIColor green] : [UIColor plum];
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

- (IBAction)playAgain:(UIButton *)sender {
    self.playAgainButton.hidden = YES;
    [self layoutBoard];
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:self.snapBehavior];

    // snap all the views back to where they originally were
    NSDictionary *origViewPositions = [self viewPositions];
    NSArray *keys = [origViewPositions allKeys];
    [keys enumerateObjectsWithOptions:NSEnumerationConcurrent
                           usingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                               NSUInteger tag = [key integerValue];
                               NSValue *obj = [origViewPositions objectForKey:key];
                               CGPoint point = [obj CGPointValue];
                               UIView *view = [self.view viewWithTag:tag];
                               UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
                               snap.damping = 0.9f;
                               [self.animator addBehavior:snap];
                               [self.animator updateItemUsingCurrentState:view];
                           }];
    [self.gameEngine restartGame];
}

-(void)dealloc {
    [self removeObserver:self.gameEngine forKeyPath:NSStringFromSelector(@selector(playerTurn)) context:playerTurnContext];
    [self removeObserver:self.gameEngine forKeyPath:NSStringFromSelector(@selector(boardState)) context:boardStateContext];
    [self removeObserver:self.gameEngine forKeyPath:NSStringFromSelector(@selector(currentGameState)) context:currentGameStateContext];
}

@end
