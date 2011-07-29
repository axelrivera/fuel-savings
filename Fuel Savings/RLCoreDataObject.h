//
//  RLCoreDataObject.h
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLCoreDataObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)initWithName:(NSString *)name;

- (void)saveContext;

@end
