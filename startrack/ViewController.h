//
//  ViewController.h
//  startrack
//
//  Created by Chris Boyle on 11/9/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bluetooth.h"

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *targetPicker;
@property (strong, nonatomic) Bluetooth *bluetooth;

@end

