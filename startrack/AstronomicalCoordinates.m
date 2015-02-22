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

const double DEG2RAD = 0.017453292519943295474;
const double RAD2DEG = 57.295779513082322865;

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

+ (NSNumber *)siderealTimeForJulianDay:(NSNumber *)jd {
    double t = ([jd doubleValue] - 2451545.0) / 36525;
    
    double gmst = 280.46061837 + (360.98564736629 * ([jd doubleValue] - 2451545.0)) + (0.000387933 * t * t) - (t * t * t / 38710000.0);
    
    while (gmst < 0.) {
        gmst += 360.;
    }
    
    while (gmst > 360.) {
        gmst -= 360.;
    }
    
    return [[NSNumber alloc] initWithDouble:gmst];
}

+ (NSNumber *)hourAngleForSiderealTime:(NSNumber *)gmst andLongitude:(NSNumber *)lon andRightAscension:(NSNumber *)ra {
    double hourAngle = [gmst doubleValue] - [lon doubleValue] - [ra doubleValue];
    
    return [[NSNumber alloc] initWithDouble:hourAngle];
}

+ (NSNumber *)altitudeForHourAngle:(NSNumber *)ha andLatitude:(NSNumber *)lat andRightAscension:(NSNumber *)ra andDeclination:(NSNumber *)dec {
    
    double altitude = asin(sin([lat doubleValue] * DEG2RAD) * sin([dec doubleValue] * DEG2RAD) + cos([lat doubleValue] * DEG2RAD) * cos([dec doubleValue] * DEG2RAD) * cos([ha doubleValue] * DEG2RAD)) * RAD2DEG;
    
    return [[NSNumber alloc] initWithDouble:altitude];
}

+ (NSNumber *)azimuthForHourAngle:(NSNumber *)ha andLatitude:(NSNumber *)lat andRightAscension:(NSNumber *)ra andDeclination:(NSNumber *)dec {
    
    double azimuth = atan2(sin([ha doubleValue] * DEG2RAD), (cos([ha doubleValue] * DEG2RAD) * sin([lat doubleValue] * DEG2RAD) - tan([dec doubleValue] * DEG2RAD) * cos([lat doubleValue] * DEG2RAD))) * RAD2DEG;
    
    return [[NSNumber alloc] initWithDouble:azimuth];
}

@end
