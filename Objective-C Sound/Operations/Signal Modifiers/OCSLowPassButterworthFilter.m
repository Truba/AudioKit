//
//  OCSLowPassButterworthFilter.m
//  Objective-C Sound
//
//  Created by Adam Boulanger on 6/22/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "OCSLowPassButterworthFilter.h"

@interface OCSLowPassButterworthFilter () {
    OCSAudio *input;
    OCSControl *cutoff;
    BOOL isInitSkipped;
}
@end

@implementation OCSLowPassButterworthFilter

-(id)initWithSourceAudio:(OCSAudio *)sourceAudio
         cutoffFrequency:(OCSControl *)cutoffFrequency
{
    self = [super initWithString:[self operationName]];
    if(self) {
        input = sourceAudio;
        cutoff = cutoffFrequency;
    }
    return self;
}

-(NSString *)stringForCSD
{
    return [NSString stringWithFormat:
            @"%@ butterlp %@, %@, %d",
            self, input, cutoff, 0];
}

@end
