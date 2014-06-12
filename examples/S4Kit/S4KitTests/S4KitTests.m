//
//  S4KitTests.m
//  S4KitTests
//
//  Created by Masa Jow on 6/12/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "S4Kit.h"

@interface S4KitTests : XCTestCase

@end

@implementation S4KitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEvenOdd
{
    NSInteger n1 = 1, n2 = 2, n3 =3, n4 = 4;
    
    XCTAssertFalse([S4Kit isEven:n1 testMethod:S4EvenOddBitOperatorMethod],
                   @"%ld unexpectedly even", (long)n1);
    XCTAssertFalse([S4Kit isEven:n1 testMethod:S4EvenOddModuloMethod],
                   @"%ld unexpectedly even", (long)n1);
    XCTAssertFalse([S4Kit isEven:n3 testMethod:S4EvenOddBitOperatorMethod],
                   @"%ld unexpectedly even", (long)n3);
    XCTAssertFalse([S4Kit isEven:n3 testMethod:S4EvenOddModuloMethod],
                   @"%ld unexpectedly even", (long)n3);
    XCTAssertTrue([S4Kit isEven:n2 testMethod:S4EvenOddBitOperatorMethod],
                   @"%ld unexpectedly even", (long)n2);
    XCTAssertTrue([S4Kit isEven:n2 testMethod:S4EvenOddModuloMethod],
                   @"%ld unexpectedly even", (long)n2);
    XCTAssertTrue([S4Kit isEven:n4 testMethod:S4EvenOddBitOperatorMethod],
                  @"%ld unexpectedly even", (long)n4);
    XCTAssertTrue([S4Kit isEven:n4 testMethod:S4EvenOddModuloMethod],
                  @"%ld unexpectedly even", (long)n4);
}

- (void)testDiscount
{
    float full1 = 100.0, full2 = 150.0, full3 = 200.0, full4 = 250.0;
    float disca = 0.80, discb = 0.75;

    float sale1a = 80.0, sale2a = 120.0, sale3a = 160.0, sale4a = 200.0;
    float sale1b = 75.0, sale2b = 90.0, sale3b = 150.0, sale4b = 187.50;

    float calc1a = [S4Kit getDiscountedPrice:full1 atDiscount:disca];
    float calc2a = [S4Kit getDiscountedPrice:full2 atDiscount:disca];
    float calc3a = [S4Kit getDiscountedPrice:full3 atDiscount:disca];
    float calc4a = [S4Kit getDiscountedPrice:full4 atDiscount:disca];
    float calc1b = [S4Kit getDiscountedPrice:full1 atDiscount:discb];
    float calc2b = [S4Kit getDiscountedPrice:full2 atDiscount:discb];
    float calc3b = [S4Kit getDiscountedPrice:full3 atDiscount:discb];
    float calc4b = [S4Kit getDiscountedPrice:full4 atDiscount:discb];
    
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc1a, sale1a);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc2a, sale2a);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc3a, sale3a);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc4a, sale4a);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc1b, sale1b);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc2b, sale2b);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc3b, sale3b);
    XCTAssertEqual(calc1a, sale1a, @"Calc price %.2f was expected to be %.2f", calc4b, sale4b);
}

- (void)testInterest
{
    float start1 = 10000.0, start2 = 30000.0,
    end1 = 15000.0, end2 = 45000.0;
    float int1 = 0.01, int2 = 0.05;
    
    NSInteger year1, year2, year3;
    NSInteger expYear1 = 41, expYear2 = 9, expYear3 = 0;
    year1 = [S4Kit findYearsToInterestWithStartBalance:start1
                                         andEndBalance:end1
                                          withInterest:int1];
    year2 = [S4Kit findYearsToInterestWithStartBalance:start2
                                         andEndBalance:end2
                                          withInterest:int2];
    year3 = [S4Kit findYearsToInterestWithStartBalance:start2
                                         andEndBalance:end1
                                          withInterest:int1];
    XCTAssertEqual(year1, expYear1, @"Calculated %ld years but expected %ld", (long)year1, (long)expYear1);
    XCTAssertEqual(year2, expYear2, @"Calculated %ld years but expected %ld", (long)year2, (long)expYear2);
    XCTAssertEqual(year3, expYear3, @"Calculated %ld years but expected %ld", (long)year3, (long)expYear3);
}

- (void)testOlympic
{
    NSInteger before = 1880, both = 1984, summerOnly = 1996, winterOnly = 1998, nonOlympic = 2013;
    S4OlympicYear y1 = [S4Kit getOlympicYearType:before];
    S4OlympicYear y2 = [S4Kit getOlympicYearType:both];
    S4OlympicYear y3 = [S4Kit getOlympicYearType:summerOnly];
    S4OlympicYear y4 = [S4Kit getOlympicYearType:winterOnly];
    S4OlympicYear y5 = [S4Kit getOlympicYearType:nonOlympic];
    
    XCTAssertEqual(y1, S4OlympicNoneYear,     @"Expected a non olympic year for %ld", (long)before);
    XCTAssertEqual(y2, S4OlympicCombinedYear, @"Expected a combination olympic year for %ld", (long)both);
    XCTAssertEqual(y3, S4OlympicSummerYear,   @"Expected a summer olympic year for %ld", (long)summerOnly);
    XCTAssertEqual(y4, S4OlympicWinterYear,   @"Expected a winter olympic year for %ld", (long)winterOnly);
    XCTAssertEqual(y5, S4OlympicNoneYear,     @"Expected a non olympic year for %ld", (long)nonOlympic);
}

@end
