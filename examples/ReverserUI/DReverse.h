//
//  DReverse.h
//  Dummy0
//
//  Created by Masa Jow on 7/1/14.
//  Copyright (c) 2014 Masa Jow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DReverse : NSObject

- (id)initWithString:(NSString *)val;

- (NSString *)reverse;

@property (nonatomic, strong) NSString *val;

@end
