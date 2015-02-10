//
//  ViewController.m
//  startrack
//
//  Created by Chris Boyle on 11/9/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bt = [Bluetooth sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startTracking:(id)sender {
    NSDictionary *params = @{ @"rightAscension" : _rightAscension.text, @"declination" : _declination.text, @"exposureLength" : _exposureLength.text, @"exposureCount" : _exposureCount.text};
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:params];
    
    [_bt.peripheral writeValue:data forCharacteristic:_bt.characteristic type:CBCharacteristicWriteWithResponse];
}

@end
