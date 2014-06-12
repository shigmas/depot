//
//  S4Kit.m
//  S4Kit
//
//  Created by Masa Jow on 6/12/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "S4Kit.h"

#define OLYMPICS_START_YEAR 1896
#define WINTER_OLYMPICS_START_YEAR 1924
#define SPLIT_WINTER_OLYMPICS_START_YEAR 1994

// No olympics these years
#define WORLD_WAR_I    1916
#define WORLD_WAR_II_0 1940
#define WORLD_WAR_II_1 1944

#define WINTER_KEY @"Winter"
#define SUMMER_KEY @"Summer"
#define BOTH_KEY   @"BOTH"
#define NONE_KEY   @"None"

#define or ||
#define and &&

@implementation S4Kit

+ (BOOL)isEvenModuloMethod:(NSInteger)num
{
    return (num % 2 == 0);
}

+ (BOOL)isEvenBitOperatorMethod:(NSInteger)num
{
    // Do a bitwise AND operation with 1.  If it is
    // odd, it will be 1.  If it is even, it will be 0.
    // For example:
    // 1 in binary is 0001.
    // 3 in binary is 0011, 4 is 0100.  For even numbers,
    // the last bit is 0, for odd, the last bit is 1.
    return !(num & 1);
}

+ (BOOL)isEven:(NSInteger)testInt testMethod:(S4EvenOddMethod)method
{
    switch (method) {
        case S4EvenOddBitOperatorMethod:
            return [self isEvenModuloMethod:testInt];
            break;
        case S4EvenOddModuloMethod:
            return [self isEvenBitOperatorMethod:testInt];
            break;
    }
}

+ (float)getDiscountedPrice:(float)fullPrice atDiscount:(float)discount
{
    return fullPrice*discount;
}

+ (NSInteger)findYearsToInterestWithStartBalance:(float)startBalance
                                   andEndBalance:(float)endBalance
                                    withInterest:(float)interest
{
    float accumulated = 0.0;
    int years = 0;
    
    // very minor error checking - just make sure end is greater than start;
    if (startBalance >= endBalance)
        return years;
    // If 0 interest, it'll take too long!
    if (interest == 0)
        return 0;
    
    while ((startBalance + accumulated) < endBalance) {
        years++;
        float yearInterest = (startBalance + accumulated) * interest;
        accumulated += yearInterest;
    }
    
    return years;
}

+ (S4OlympicYear)getOlympicYearType:(NSInteger)year
{
    S4OlympicYear key = S4OlympicNoneYear;

    // Check for a summer year
    if ((year >= OLYMPICS_START_YEAR)
        and (year != WORLD_WAR_I)
        and (year != WORLD_WAR_II_0)
        and (year != WORLD_WAR_II_1)) {
        // It's after the Olympics started, and not a year that it was
        // canceled.
        NSInteger yearDiff = year - OLYMPICS_START_YEAR;
        if (yearDiff % 4 == 0) {
            // summer olympics year.  Is it also winter?  Meaning, the
            // joint years are after they started the winter olympics,
            // and before it split into different years.
            if ((year >= WINTER_OLYMPICS_START_YEAR)
                and (year <= SPLIT_WINTER_OLYMPICS_START_YEAR)) {
                key = S4OlympicCombinedYear;
            } else {
                key = S4OlympicSummerYear;
            }
        } else if (year >= SPLIT_WINTER_OLYMPICS_START_YEAR) {
            yearDiff = year - SPLIT_WINTER_OLYMPICS_START_YEAR;
            // Or, is it after the split, then it's a cycle from the
            // split year.
            if (yearDiff % 4 == 0) {
                key = S4OlympicWinterYear;
            }
        }
    }
    
    return key;
}

+ (NSString *)getOlympicYearString:(NSInteger)year
{
    S4OlympicYear key = [self getOlympicYearType:year];
    NSString *str;
    switch (key) {
        case S4OlympicWinterYear:
            str = @"Winter Olympics Year";
            break;
        case S4OlympicSummerYear:
            str = @"Summer Olympics Year";
            break;
        case S4OlympicCombinedYear:
            str = @"Summer and Winter Olympics Year";
            break;
        case S4OlympicNoneYear:
        default:
            str = @"No olympics this year";
            break;
    }
    
    return str;    
}

@end
