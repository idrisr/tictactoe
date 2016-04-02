//
//  WebViewController.m
//  TicTacToe
//
//  Created by id on 3/20/16.
//  Copyright © 2016 Id Raja. All rights reserved.
//

#import "WebViewController.h"



@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

static NSString *startURLstring = @"https://en.wikipedia.org/wiki/Tic-tac-toe";

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self loadRequestWithString:startURLstring];
}

-(void)loadRequestWithString:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.spinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinner stopAnimating];
    self.spinner.hidden = true;
}

@end
