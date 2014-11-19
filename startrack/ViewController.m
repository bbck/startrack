//
//  ViewController.m
//  startrack
//
//  Created by Chris Boyle on 11/9/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *targetPickerData;
    NSString *targetPlist;
    NSDictionary *targetCoordinates;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bluetooth = [[Bluetooth alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTracking:(id)sender {
    
}

@end
