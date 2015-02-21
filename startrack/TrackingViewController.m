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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSNumber *jd = [AstronomicalCoordinates julianDayFor:[[NSDate alloc] init]];
    NSNumber *lon = [[NSNumber alloc] initWithDouble:72.52313856199964];
    NSNumber *lat = [[NSNumber alloc] initWithDouble:42.380367210000486];
    NSNumber *lmst = [AstronomicalCoordinates localSiderealTimeForJulianDay:jd andLongitude:lon];
    NSNumber *azimuth = [AstronomicalCoordinates azimuthForLocalSiderealTime:lmst andLatitude:lat andRightAscension:[[NSNumber alloc] initWithDouble:self.rightAscension.text.doubleValue] andDeclination:[[NSNumber alloc] initWithDouble:self.declination.text.doubleValue]];
    NSNumber *altitude = [AstronomicalCoordinates altitudeForLocalSiderealTime:lmst andLatitude:[[NSNumber alloc] initWithDouble:38.921389] andRightAscension:[[NSNumber alloc] initWithDouble:347.3167] andDeclination:[[NSNumber alloc] initWithDouble:-6.719722]];
    NSString *commandString = [NSString stringWithFormat:@"%.f:%f:%f", self.exposureCount.value, azimuth.doubleValue, altitude.doubleValue];
    NSData* data = [commandString dataUsingEncoding:NSUTF8StringEncoding];
    [appDelegate.melody sendData:data];
}

@end
