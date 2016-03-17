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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.turnIndex = 0;
    self.whichPlayerLabel.font = [UIFont systemFontOfSize:25];

    
}

-(IBAction) onButtonTapped:(UIButton*)button {
    self.turnIndex++;

    if (self.turnIndex % 2 == 0) {
        self.whichPlayerLabel.text = @"O";
        self.whichPlayerLabel.textColor = [UIColor redColor];
    } else {
        self.whichPlayerLabel.text = @"X";
        self.whichPlayerLabel.textColor = [UIColor blueColor];
    }
}

-(void) toggleTurnIndicator {
    //    NSString *currentTurnLabel = self.whichPlayerLabel.text;
}

//-(void) toggleButtonText:(UIButton*)button {
//    if ([button.titleLabel.text isEqualToString:@"X"]) {
//        // make label O
//        [button setTitle:@"O" forState:UIControlStateNormal];
//        button.textColor = [UIColor redColor];
//    } else {
//        // make label X
//        [button setTitle:@"X" forState:UIControlStateNormal];
//        button.textColor = [UIColor blueColor];
//    }
//}

@end