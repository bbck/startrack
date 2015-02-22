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
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exposureCountAction:(id)sender {
    self.exposureCountField.placeholder = [NSString stringWithFormat:@"%.f", self.exposureCount.value];
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
    
    NSString *commandString = [NSString stringWithFormat:@"T%.f:%.1f:%.1f", self.exposureCount.value, azimuth, altitude];
    [self sendCommand:commandString];
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

@end
