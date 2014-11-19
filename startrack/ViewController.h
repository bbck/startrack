//
//  ViewController.h
//  startrack
//
//  Created by Chris Boyle on 11/9/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bluetooth.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) Bluetooth *bt;
@property (weak, nonatomic) IBOutlet UITextField *rightAscension;
@property (weak, nonatomic) IBOutlet UITextField *declination;
@property (weak, nonatomic) IBOutlet UITextField *exposureLength;
@property (weak, nonatomic) IBOutlet UITextField *exposureCount;

@end

