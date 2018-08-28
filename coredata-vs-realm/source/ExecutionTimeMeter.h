//
//  ExecutionTimeMeter.h
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ExecutionTimeMeterCompletion)(NSString *message);
typedef void (^ExecutionTimeMeterBlockCompletion)(NSString *format, ...);
typedef void (^ExecutionTimeMeterBlock)(ExecutionTimeMeterBlockCompletion blockCompletion);

@interface ExecutionTimeMeter : NSObject
+(void) meter:(ExecutionTimeMeterBlock)block completion:(ExecutionTimeMeterCompletion)completion;
+(void) meterBackground:(ExecutionTimeMeterBlock)block completion:(ExecutionTimeMeterCompletion)completion;
@end
