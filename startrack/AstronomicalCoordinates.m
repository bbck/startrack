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
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    long century = components.year / 100;
    long year = components.year;
    long month = components.month;
    double day = components.day + components.hour / 24.0 + components.minute / 1440.0;
    
    if (month < 3) {
        year = year - 1;
        month = month + 12;
    }

    double jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day + (2 - century + floor(century / 4)) - 1524.5;
    
    return [[NSNumber alloc] initWithDouble:jd];
}

+ (NSNumber *)localSiderealTimeForJulianDay:(NSNumber *)jd andLongitude:(NSNumber *)longitude {
    double jc = ([jd doubleValue] - 2451545.0L) / 36525L;
    
    double gmst = 280.46061837 + (360.98564736629L * ([jd doubleValue] - 2451545.0L)) + (0.000387933L * jc * jc) - (jc * jc * jc / 38710000.0L);
    
    while (gmst < 0.) {
        gmst += 360.;
    }
    
    double lmst = gmst - [longitude doubleValue];
    
    return [[NSNumber alloc] initWithDouble:lmst];
}

@end
