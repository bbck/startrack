//
//  AstronomicalCoordinates.h
//  StarTrack
//
//  Created by Chris Boyle on 2/15/15.
//  Copyright (c) 2015 UMass Amherst. All rights reserved.
//

#import <foundation/Foundation.h>

@interface AstronomicalCoordinates : NSObject

+ (double)julianDayFor:(NSDate *)date;
+ (double)siderealTimeForJulianDay:(double)jd;
+ (double)hourAngleForSiderealTime:(double)gmst andLongitude:(double)lon andRightAscension:(double)ra;
+ (double)altitudeForHourAngle:(double)ha andLatitude:(double)lat andRightAscension:(double)ra andDeclination:(double)dec;
+ (double)azimuthForHourAngle:(double)ha andLatitude:(double)lat andRightAscension:(double)ra andDeclination:(double)dec;

@end
