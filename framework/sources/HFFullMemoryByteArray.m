//
//  HFFullMemoryByteArray.m
//  HexFiend_2
//
//  Created by Peter Ammon on 11/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "HFFullMemoryByteArray.h"
#import "HFFullMemoryByteSlice.h"
#import "HFByteSlice.h"

@implementation HFFullMemoryByteArray

- init {
    [super init];
    data = [[NSMutableData alloc] init];
    return self;
}

- (void)dealloc {
    [data release];
    [super dealloc];
}

- (unsigned long long)length {
    return [data length];
}

- (void)copyBytes:(unsigned char *)dst range:(HFRange)range {
    HFASSERT(range.length == 0 || dst != NULL);
    HFASSERT(HFSumDoesNotOverflow(range.location, range.length));
    HFASSERT(range.location + range.length <= [self length]);
    unsigned char* bytes = [data mutableBytes];
    memmove(dst, bytes + ll2l(range.location), ll2l(range.length));
}

- (NSArray *)byteSlices {
    return [NSArray arrayWithObject:[[[HFFullMemoryByteSlice alloc] initWithData:data] autorelease]];
}

- (void)insertByteSlice:(HFByteSlice *)slice inRange:(HFRange)lrange {
    HFASSERT([slice length] <= ULONG_MAX);
    NSUInteger length = ll2l([slice length]);
    NSRange range;
    HFASSERT(lrange.location <= ULONG_MAX);
    HFASSERT(lrange.length <= ULONG_MAX);
    HFASSERT(HFSumDoesNotOverflow(lrange.location, lrange.length));
    range.location = ll2l(lrange.location);
    range.length = ll2l(lrange.length);
    
    void* buff = check_malloc(length);
    [slice copyBytes:buff range:HFRangeMake(0, length)];
    [data replaceBytesInRange:range withBytes:buff length:length];
    free(buff);
}

@end
