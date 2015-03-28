//
//  TrackingViewController.m
//  StarTrack
//
//  Created by Chris Boyle on 2/14/15.
//  Copyright (c) 2015 UMass Amherst. All rights reserved.
//

#import "TrackingViewController.h"
#import "AppDelegate.h"
#import "AstronomicalCoordinates.h"

@interface TrackingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *rightAscension;
@property (weak, nonatomic) IBOutlet UITextField *declination;
@property (weak, nonatomic) IBOutlet UIStepper *exposureCount;
@property (weak, nonatomic) IBOutlet UITextField *exposureCountField;
@property (weak, nonatomic) IBOutlet UIStepper *exposureLength;
@property (weak, nonatomic) IBOutlet UITextField *exposureLengthField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIPickerView *targetPicker;

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.targetPicker.dataSource = self;
    self.targetPicker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exposureCountAction:(id)sender {
    self.exposureCountField.placeholder = [NSString stringWithFormat:@"%.f", self.exposureCount.value];
}

- (IBAction)exposureLengthAction:(id)sender {
    self.exposureLengthField.placeholder = [NSString stringWithFormat:@"%.f", self.exposureLength.value];
}

- (IBAction)startAction:(id)sender {
    double lon = 72.52313856199964;
    double lat = 42.380367210000486;
    double ra = self.rightAscension.text.doubleValue;
    double dec = self.declination.text.doubleValue;
    
    double jd = [AstronomicalCoordinates julianDayFor:[[NSDate alloc] init]];
    double st = [AstronomicalCoordinates siderealTimeForJulianDay:jd];
    double ha = [AstronomicalCoordinates hourAngleForSiderealTime:st andLongitude:lon andRightAscension:ra];
    double azimuth = [AstronomicalCoordinates azimuthForHourAngle:ha andLatitude:lat andRightAscension:ra andDeclination:dec];
    double altitude = [AstronomicalCoordinates altitudeForHourAngle:ha andLatitude:lat andRightAscension:ra andDeclination:dec];
    
    if (altitude < 0.) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Target is not in the visible sky." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        NSString *commandString = [NSString stringWithFormat:@"T%.f:%.f:%.1f:%.1f", self.exposureCount.value, self.exposureLength.value, azimuth, altitude];
        [self sendCommand:commandString];
    }
}

- (IBAction)alignAction:(id)sender {
    [self sendCommand:@"N"];
}

- (IBAction)trackAction:(id)sender {
    [self sendCommand:@"T3:45.0:45.0"];
}

- (IBAction)resetAction:(id)sender {
    [self sendCommand:@"D"];
}

- (IBAction)offAction:(id)sender {
    [self sendCommand:@"O"];
}

- (void)sendCommand:(NSString *)cmd {
    NSLog(@"Sending command: '%@'", cmd);
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSData* data = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    [appDelegate.melody sendData:data];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Targets" ofType:@"plist"];
    NSArray *targets = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    return targets.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Targets" ofType:@"plist"];
    NSArray *targets = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    return [targets[row] valueForKey:@"Name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row > 0) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Targets" ofType:@"plist"];
        NSArray *targets = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        double ra = [[targets[row] valueForKey:@"Right Ascension"] doubleValue];
        double dec = [[targets[row] valueForKey:@"Declination"] doubleValue];
        
        ra = ra * 15;
        
        self.rightAscension.text = [[NSString alloc] initWithFormat:@"%f", ra];
        self.declination.text = [[NSString alloc] initWithFormat:@"%f", dec];
    } else {
        self.rightAscension.text = @"";
        self.declination.text = @"";
    }
}

@end
