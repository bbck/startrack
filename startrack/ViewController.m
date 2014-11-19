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
    
    targetPickerData = @[@"Zero", @"North", @"South", @"East", @"West"];
    targetPlist = [[NSBundle mainBundle] pathForResource:@"Targets"
                                                  ofType:@"plist"];
    targetCoordinates = [NSDictionary dictionaryWithContentsOfFile:targetPlist];
    self.targetPicker.dataSource = self;
    self.targetPicker.delegate = self;
    
    self.bluetooth = [[Bluetooth alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return targetPickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return targetPickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Selected row: %ld", (long)row);
    NSArray *coordinates = [targetCoordinates objectForKey:targetPickerData[row]];
    NSLog(@"Right ascension = %@", coordinates[0]);
    NSLog(@"Declination = %@", coordinates[0]);
}

@end
