//
//  ViewController.m
//  TicTacToe
//
//  Created by Brandon Gress on 3/17/16.
//  Copyright © 2016 Brandon Gress. All rights reserved.
//

#import "ViewController.h"

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
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property NSUInteger turnIndex;
@property NSString *boardState;       // 0 for "O", 1 for "X", undefined if not yet played
@property NSString *playerTurn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.turnIndex = 0;
    self.boardState = [@"" stringByPaddingToLength:9 withString: @" " startingAtIndex:0];
    self.whichPlayerLabel.font = [UIFont systemFontOfSize:25];
    self.playerTurn = @"X";
}

-(void) togglePlayerTurn {
    if ([self.playerTurn isEqualToString:@"X"]) {
        self.playerTurn = @"O";
    } else {
        self.playerTurn = @"X";
    }
}

-(IBAction) onButtonTapped:(UIButton*)button {
    NSInteger tag = button.tag;
    NSInteger index = tag / 10 - 1;
    NSString *currentValue = [button.titleLabel.text substringWithRange:NSMakeRange(index, 1)];

    // check if button is blank to proceed
    if (!currentValue) {
        [button setTitle:self.playerTurn forState:UIControlStateNormal];
        [self togglePlayerTurn];
    } else {
        // TODO: give user feedback
    }
}

- (IBAction)winner:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Winner!"
                                                                             message:@"Someone Won!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end