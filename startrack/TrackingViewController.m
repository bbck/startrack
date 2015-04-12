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


@property (weak, nonatomic) IBOutlet UITextField *rightAscensionHours;
@property (weak, nonatomic) IBOutlet UITextField *rightAscensionMinutes;
@property (weak, nonatomic) IBOutlet UITextField *rightAscensionSeconds;
@property (weak, nonatomic) IBOutlet UITextField *declinationDegrees;
@property (weak, nonatomic) IBOutlet UITextField *declinationMinutes;
@property (weak, nonatomic) IBOutlet UITextField *declinationSeconds;
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
    double ra = (self.rightAscensionHours.text.doubleValue + self.rightAscensionMinutes.text.doubleValue / 60. + self.rightAscensionSeconds.text.doubleValue / 3600.) * 15.;
    double dec = self.declinationDegrees.text.doubleValue + self.declinationMinutes.text.doubleValue / 60 + self.declinationMinutes.text.doubleValue / 3600;
    
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
        int raHours, raMinutes, raSeconds = 0;
        double dec = [[targets[row] valueForKey:@"Declination"] doubleValue];
        int decDegrees, decMinutes, decSeconds = 0;
        
        raHours = ra;
        raMinutes = (ra - raHours) * 60;
        raSeconds = (ra - raHours - raMinutes / 60.) * 3600;
        
        decDegrees = dec;
        decMinutes = (dec - decDegrees) * 60;
        decSeconds = (dec - decDegrees - decMinutes / 60.) * 3600;
        
        self.rightAscensionHours.text = [[NSString alloc] initWithFormat:@"%d", raHours];
        self.rightAscensionMinutes.text = [[NSString alloc] initWithFormat:@"%d",  raMinutes];
        self.rightAscensionSeconds.text = [[NSString alloc] initWithFormat:@"%d",  raSeconds];
        self.declinationDegrees.text = [[NSString alloc] initWithFormat:@"%d",  decDegrees];
        self.declinationMinutes.text = [[NSString alloc] initWithFormat:@"%d",  decMinutes];
        self.declinationSeconds.text = [[NSString alloc] initWithFormat:@"%d",  decSeconds];
    } else {
        self.rightAscensionHours.text = @"";
        self.rightAscensionMinutes.text = @"";
        self.rightAscensionSeconds.text = @"";
        self.declinationDegrees.text = @"";
        self.declinationMinutes.text = @"";
        self.declinationSeconds.text = @"";
    }
}

@end
