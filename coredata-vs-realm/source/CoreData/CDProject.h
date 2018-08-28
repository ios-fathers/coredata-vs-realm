//
//  CDProject.h
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDSwifter;

@interface CDProject : NSManagedObject
@property (nonatomic) int16_t bugs;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) CDSwifter *swifter;
@end
