//
//  ViewController.m
//  DirectionMap
//
//  Created by ViVID on 10/5/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)DirectionBUtt:(id)sender
{
    [self performSegueWithIdentifier:@"Direction" sender:self];
}

@end
