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
    NSArray *_targetPickerData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _targetPickerData = @[@"", @"Zero", @"North", @"South", @"East", @"West"];
    self.targetPicker.dataSource = self;
    self.targetPicker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _targetPickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _targetPickerData[row];
}

@end
