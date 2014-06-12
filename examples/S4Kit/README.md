// Returns true if testInt is even.  You must provide a testMethod
// ModuloMethod uses the % operator - the most intuitive.  The
// Bit operation is the fastest, simply doing a logical 'and' with
// the last bit.
+ (BOOL)isEven:(NSInteger)testInt testMethod:(S4EvenOddMethod)method;

// Returns the sale price, given the full price and a discount (between
// 0 and 1.
+ (float)getDiscountedPrice:(float)fullPrice atDiscount:(float)discount;

// Given a starting balance, and a desired end balance, and an interest
// rate, returns the number of years it will take to achieve the end
// balance.  If the end balance is less, then it will take 0 years.
+ (NSInteger)findYearsToInterestWithStartBalance:(float)startBalance
                                   andEndBalance:(float)endBalance
                                    withInterest:(float)interest;

// For a given year, we return the enumeration for the type of Olympic year
// This is for the modern era Olympics, and accounts for the haitus years
// and the differing winter Olympic years (starting from 1992).
+ (S4OlympicYear)getOlympicYearType:(NSInteger)year;

// Returns a non-internationalized string for the Olympic year (given the
// result of the getOlympicYearType function.
+ (NSString *)getOlympicYearString:(NSInteger)year;
