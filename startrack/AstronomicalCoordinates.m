//
//  AstronomicalCoordinates.m
//  StarTrack
//
//  Created by Chris Boyle on 2/15/15.
//  Copyright (c) 2015 UMass Amherst. All rights reserved.
//

#import "AstronomicalCoordinates.h"

@interface AstronomicalCoordinates ()

@end

@implementation AstronomicalCoordinates

+ (NSNumber *)julianDayFor:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:date];
    
    long century = components.year / 100;
    long year = components.year;
    long month = components.month;
    double day = components.day + components.hour / 24.0;
    
    if (month < 3) {
        year = year - 1;
        month = month + 12;
    }

    double jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day + (2 - century + floor(century / 4)) - 1524.5;
    
    return [[NSNumber alloc] initWithDouble:jd];
}

+ (NSNumber *)localSiderealTimeForJulianDay:(NSNumber *)jd andLongitude:(NSNumber *)longitude {
    double jc = ([jd doubleValue] - 2451545.0) / 36525;
    
    double gmst = 280.46061837 + (360.9856473662 * ([jd doubleValue] - 2451545.0)) + (0.000387933 * jc * jc) - (jc * jc * jc / 38710000.0);
    
    double lmst = gmst + ([longitude doubleValue] * (24.0/360));
    lmst = fmod(lmst + 24.0, 24.0);
    
    return [[NSNumber alloc] initWithDouble:lmst];
}

@end
