//
//  DReverse.m
//  Dummy0
//
//  Created by Masa Jow on 7/1/14.
//  Copyright (c) 2014 Masa Jow. All rights reserved.
//

#import "DReverse.h"

#include <stdio.h>

@implementation DReverse

- (id)initWithString:(NSString *)val
{
    if ((self = [super init]) != nil) {
        self.val = val;
    }
    
    return self;
}

#define SWP(x,y) (x^=y, y^=x, x^=y)
void strrev(char *p)
{
    char *q = p;

    // set q to the end
    while (q && *q) ++q;
    for (--q ; p < q; ++p, --q)
        SWP(*p,*q);
}

- (NSString *)reverse
{
    const char *c = [self.val UTF8String];
    char *p = strdup(c);
    
    char *q = p;
    // reverse the string.  (This will do some weird stuff
    // with UTF-8
    strrev(p);

    // So, fix UTF8
    while (q && *q) ++q;
    while (p < --q) {
        switch( (*q & 0xF0) >> 4) {
            case 0xF: /* U+010000-U+10FFFF: four bytes */
                SWP(*(q-0), *(q-3));
                SWP(*(q-1), *(q-2));
                q -= 3;
                break;
            case 0xE: /* U+000800-U00FFF: three bytes */
                SWP(*(q-0), *(q-2));
                q -= 2;
                break;
            case 0xC: /* fall-through */
            case 0xD: /* U+000080-U+0007FF: two bytes */
                SWP(*(q-0), *(q-1));
                q--;
                break;
        }
    }
    
    NSString *reversed = [NSString stringWithUTF8String:q];
    free(p);
    
    return reversed;
}

@end
