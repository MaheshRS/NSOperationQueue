//
//  PendingOperations.h
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject

@property(nonatomic, strong)NSMutableDictionary *downloadsInProgress;
@property(nonatomic, strong)NSOperationQueue *downloadQueue;

@property(nonatomic, strong)NSMutableDictionary *filterationInProgress;
@property(nonatomic, strong)NSOperationQueue *filterQueue;

@end
