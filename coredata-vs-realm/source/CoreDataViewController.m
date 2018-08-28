//
//  CoreDataViewController.m
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import "CoreDataViewController.h"
#import "CoreDataStack.h"
#import "CDSwifter.h"
#import "CDProject.h"
#import "ExecutionTimeMeter.h"
#import "DummyText.h"

@interface CoreDataViewController ()
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic) CoreDataStack *coreDataStack;
@end

@implementation CoreDataViewController

-(CoreDataStack *) coreDataStack
{
    if (_coreDataStack == nil)
        _coreDataStack = [CoreDataStack new];
    
    return _coreDataStack;
}

#pragma mark - Speed tests

-(IBAction) createObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSInteger count = 50000;
            NSInteger relationships = 10;
            
            NSArray *levels = @[kCDSwifterLevelBaby, kCDSwifterLevelJunior];
            for (NSInteger i = 0; i < count; ++i)
            {
                CDSwifter *swifter = [NSEntityDescription insertNewObjectForEntityForName:@"CDSwifter" inManagedObjectContext:self.coreDataStack.managedObjectContext];
                swifter.name = [NSString stringWithFormat:@"Clone %@", [NSUUID UUID].UUIDString];
                swifter.level = levels[i / (count / 2)];
                swifter.age = 10 + i / (count / 2);
                swifter.bio = kDummyText;
                
                for (NSInteger j = 0; j < relationships; ++j)
                {
                    CDProject *project = [NSEntityDescription insertNewObjectForEntityForName:@"CDProject" inManagedObjectContext:self.coreDataStack.managedObjectContext];
                    project.name = [NSString stringWithFormat:@"Project %@", [NSUUID UUID].UUIDString];
                    project.bugs = (count - i) / 100 + arc4random_uniform(10);
                    project.swifter = swifter;
                }
            }
            [self.coreDataStack.managedObjectContext save:nil];
            blockCompletion(@"Create %@ objects", @(count * relationships));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) updateAllObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            for (CDSwifter* swifter in result)
                swifter.name = [NSString stringWithFormat:@"Clone %@", [NSUUID UUID].UUIDString];
            [self.coreDataStack.managedObjectContext save:nil];
            blockCompletion(@"Update all objects(%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchAllObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            blockCompletion(@"Fetch all objects(%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchAndAccessAllObjectsSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            for (CDSwifter *swifter in result)
            {
                [swifter name];
                [swifter level];
                [swifter bio];
                [swifter age];
            }
            blockCompletion(@"Fetch all objects(%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchObjectsWithNumberPredicateSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age > 10"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            blockCompletion(@"Fetch objects with predicate (%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchObjectsWithStringPredicateSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"level = %@", kCDSwifterLevelJunior];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            blockCompletion(@"Fetch objects with predicate (%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchObjectsWithRelationPredicateSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY failedProjects.bugs > 100"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            blockCompletion(@"Fetch objects with predicate (%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchObjectsWithShortTextSearchSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", @"oNe"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            blockCompletion(@"Fetch Swifters with short text contains substring (%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

-(IBAction) fetchObjectsWithLongTextSearchSpeedTest:(id)sender
{
    self.stateLabel.text = @"Wait...";
    [self.coreDataStack.managedObjectContext performBlock:^{
        [ExecutionTimeMeter meter:^(ExecutionTimeMeterBlockCompletion blockCompletion) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDSwifter"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"bio CONTAINS[cd] %@", @"irREgUlar"];
            NSArray *result = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            blockCompletion(@"Fetch Swifters with long text contains substring (%@)", @(result.count));
        } completion:^(NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = message;
            });
        }];
    }];
}

@end
