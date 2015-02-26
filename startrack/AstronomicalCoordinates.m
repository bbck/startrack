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

+ (double)julianDayFor:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    double century = components.year / 100;
    double year = components.year;
    double month = components.month;
    double day = components.day + components.hour / 24.0 + components.minute / 1440.0;
    
    if (month < 3) {
        year = year - 1;
        month = month + 12;
    }

    double jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day + (2 - century + floor(century / 4)) - 1524.5;
    
    return jd;
}

+ (double)siderealTimeForJulianDay:(double)jd {
    double t = (jd - 2451545.0) / 36525;
    
    double gmst = 280.46061837 + (360.98564736629 * (jd - 2451545.0)) + (0.000387933 * t * t) - (t * t * t / 38710000.0);
    
    while (gmst < 0.) {
        gmst += 360.;
    }
    
    while (gmst > 360.) {
        gmst -= 360.;
    }
    
    return gmst;
}

+ (double)hourAngleForSiderealTime:(double)gmst andLongitude:(double)lon andRightAscension:(double)ra {
    double hourAngle = gmst - lon - ra;
    
    while (hourAngle < 0.) {
        hourAngle += 360.;
    }
    
    return hourAngle;
}

+ (double)altitudeForHourAngle:(double)ha andLatitude:(double)lat andRightAscension:(double)ra andDeclination:(double)dec {
    ha = ha * DEG2RAD;
    lat = lat * DEG2RAD;
    ra = ra * DEG2RAD;
    dec = dec * DEG2RAD;
    
    double altitude = asin(sin(lat) * sin(dec) + cos(lat) * cos(dec) * cos(ha)) * RAD2DEG;
    
    return altitude;
}

+ (double)azimuthForHourAngle:(double)ha andLatitude:(double)lat andRightAscension:(double)ra andDeclination:(double)dec {
    ha = ha * DEG2RAD;
    lat = lat * DEG2RAD;
    ra = ra * DEG2RAD;
    dec = dec * DEG2RAD;
    
    double azimuth = atan2(sin(ha), cos(ha) * sin(lat) - tan(dec) * cos(lat)) * RAD2DEG;
    
    if (azimuth < 0.) {
        azimuth += 360.;
    }
    
    return azimuth;
}

@end
