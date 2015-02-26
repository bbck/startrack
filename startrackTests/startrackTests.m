//
//  startrackTests.m
//  startrackTests
//
//  Created by Chris Boyle on 11/9/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AstronomicalCoordinates.h"

@interface startrackTests : XCTestCase

@property (nonatomic) NSDate *date;

@end

@implementation startrackTests

- (void)setUp {
    [super setUp];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year = 1987;
    components.month = 4;
    components.day = 10;
    components.hour = 19;
    components.minute = 21;
    
    self.date = [cal dateFromComponents:components];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testJulianDay {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDate *date;
    
    components.year = 2000;
    components.month = 1;
    components.day = 1;
    components.hour = 12;
    
    date = [cal dateFromComponents:components];
    
    XCTAssertEqual([AstronomicalCoordinates julianDayFor:date], 2451545.0);
    
    components.year = 1987;
    components.month = 6;
    components.day = 19;
    components.hour = 12;
    
    date = [cal dateFromComponents:components];
    
    XCTAssertEqual([AstronomicalCoordinates julianDayFor:date], 2446966.0);
    
    components.year = 1600;
    components.month = 12;
    components.day = 31;
    components.hour = 0;
    
    date = [cal dateFromComponents:components];
    
    XCTAssertEqual([AstronomicalCoordinates julianDayFor:date], 2305812.5);
    
    components.year = 2015;
    components.month = 02;
    components.day = 25;
    components.hour = 18;
    
    date = [cal dateFromComponents:components];
    
    XCTAssertEqual([AstronomicalCoordinates julianDayFor:date], 2457079.25);
    
    components.year = 2015;
    components.month = 02;
    components.day = 26;
    components.hour = 21;
    
    date = [cal dateFromComponents:components];
    
    XCTAssertEqual([AstronomicalCoordinates julianDayFor:date], 2457080.375);
}

- (void)testSiderealTime {
    double jd = [AstronomicalCoordinates julianDayFor:self.date];
    
    XCTAssertEqualWithAccuracy([AstronomicalCoordinates siderealTimeForJulianDay:jd], 128.7378733, .01);
    
    XCTAssertEqualWithAccuracy([AstronomicalCoordinates siderealTimeForJulianDay:2457080.375000], 111.38841, .01);
}

- (void)testHourAngle {
    double jd = [AstronomicalCoordinates julianDayFor:self.date];
    double gmst = [AstronomicalCoordinates siderealTimeForJulianDay:jd];
    XCTAssertEqualWithAccuracy([AstronomicalCoordinates hourAngleForSiderealTime:gmst andLongitude:77.06541667 andRightAscension:347.3193375], 64.352133, .01);
}

- (void)testAltitude {
    double jd = [AstronomicalCoordinates julianDayFor:self.date];
    double gmst = [AstronomicalCoordinates siderealTimeForJulianDay:jd];
    double ha = [AstronomicalCoordinates hourAngleForSiderealTime:gmst andLongitude:77.06541667 andRightAscension:347.3193375];
    
    XCTAssertEqualWithAccuracy([AstronomicalCoordinates altitudeForHourAngle:ha andLatitude:38.92138889 andRightAscension:347.3193375 andDeclination:-6.719891667], 15.1249, .01);
}

- (void)testAzimuth {
    double jd = [AstronomicalCoordinates julianDayFor:self.date];
    double gmst = [AstronomicalCoordinates siderealTimeForJulianDay:jd];
    double ha = [AstronomicalCoordinates hourAngleForSiderealTime:gmst andLongitude:77.06541667 andRightAscension:347.3193375];
    
    XCTAssertEqualWithAccuracy([AstronomicalCoordinates azimuthForHourAngle:ha andLatitude:38.92138889 andRightAscension:347.3193375 andDeclination:-6.719891667], 68.0337, .01);
}

@end
