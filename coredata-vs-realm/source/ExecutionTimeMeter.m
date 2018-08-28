//
//  ExecutionTimeMeter.m
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import "ExecutionTimeMeter.h"

@implementation ExecutionTimeMeter

+(void) meter:(ExecutionTimeMeterBlock)block completion:(ExecutionTimeMeterCompletion)completion
{
    if (!block)
    {
        NSLog(@"ExecutionTimeMeterBlock is nil");
        return;
    }
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    block(^(NSString *format, ...){
        NSTimeInterval finishTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval duration = finishTime - startTime;
        
        NSString *message = nil;
        va_list args;
        va_start(args, format);
        message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        if (completion)
            completion([NSString stringWithFormat:@"%@: %.03f sec", message, duration]);
    });
}

+(void) meterBackground:(ExecutionTimeMeterBlock)block completion:(ExecutionTimeMeterCompletion)completion
{
    if (!block)
    {
        NSLog(@"ExecutionTimeMeterBlock is nil");
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
        block(^(NSString *format, ...){
            NSTimeInterval finishTime = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval duration = finishTime - startTime;
            
            NSString *message = nil;
            va_list args;
            va_start(args, format);
            message = [[NSString alloc] initWithFormat:format arguments:args];
            va_end(args);
            
            if (completion)
            {
                NSString *result = [NSString stringWithFormat:@"%@: %.03f sec", message, duration];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(result);
                });
            }
        });
    });
}

@end
