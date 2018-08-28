//
//  RealmViewController.m
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import "RealmViewController.h"
#import <Realm/Realm.h>
#import "RMSwifter.h"
#import "RMProject.h"
#import "DummyText.h"
#import "ExecutionTimeMeter.h"

@interface RealmViewController ()
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@end

@implementation RealmViewController

#pragma mark - Speed tests

-(IBAction) createObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        NSInteger count = 50000;
        NSInteger relationships = 10;
        
        NSMutableArray* swifters = [NSMutableArray arrayWithCapacity:count];
        NSArray* levels = @[kRMSwifterLevelBaby, kRMSwifterLevelJunior];
        for (NSInteger i = 0; i < count; ++i)
        {
            RMSwifter* swifter = [RMSwifter new];
            swifter.name = [NSString stringWithFormat:@"Clone %@", [NSUUID UUID].UUIDString];
            swifter.level = levels[i / (count / 2)];
            swifter.age = 10 + i / (count / 2);
            swifter.bio = kDummyText;
            [swifters addObject:swifter];
            
            for (NSInteger j = 0; j < relationships; ++j)
            {
                RMProject* project = [RMProject new];
                project.name = [NSString stringWithFormat:@"Project %@", [NSUUID UUID].UUIDString];
                project.bugs = (count - i) / 100 + arc4random_uniform(10);
                [swifter.failedProjects addObject:project];
            }
        }
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObjects:swifters];
        }];
        
        blockCompletion(@"Create %@ objects", @(count * relationships));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) updateAllObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter allObjects];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            for (RMSwifter *swifter in result)
                swifter.name = [NSString stringWithFormat:@"Clone %@", [NSUUID UUID].UUIDString];
        }];
        blockCompletion(@"Update all objects(%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchAllObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter allObjects];
        blockCompletion(@"Fetch all objects(%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchAndAccessAllObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter allObjects];
        for (RMSwifter *swifter in result)
        {
            [swifter name];
            [swifter level];
            [swifter bio];
            [swifter age];
        }
        blockCompletion(@"Fetch all objects(%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchObjectsWithNumberPredicateSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter objectsWhere:@"age > 10"];
        blockCompletion(@"Fetch objects with predicate (%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchObjectsWithStringPredicateSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter objectsWhere:@"level = %@", kRMSwifterLevelJunior];
        blockCompletion(@"Fetch objects with predicate (%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchObjectsWithRelationPredicateSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter objectsWhere:@"ANY failedProjects.bugs > 100"];
        blockCompletion(@"Fetch objects with predicate (%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchObjectsWithShortTextSearchSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter objectsWhere:@"name CONTAINS[cd] %@", @"oNe"];
        blockCompletion(@"Fetch objects with short text contains substring (%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

-(IBAction) fetchObjectsWithLongTextSearchSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [ExecutionTimeMeter meterBackground:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
        RLMResults *result = [RMSwifter objectsWhere:@"bio CONTAINS[cd] %@", @"irREgUlar"];
        blockCompletion(@"Fetch Swifters with short text contains substring (%@)", @(result.count));
    } completion:^(NSString *message) {
        self.stateLabel.text = message;
    }];
}

@end
