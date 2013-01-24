//
//  PendingOperations.m
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations
@synthesize downloadsInProgress = _downloadsInProgress;
@synthesize downloadQueue = _downloadQueue;

@synthesize filterationInProgress = _filterationInProgress;
@synthesize filterQueue= _filterQueue;


- (id)init
{
    self = [super init];
    
    if(self)
    {
        if(!_downloadsInProgress)
            _downloadsInProgress = [[NSMutableDictionary alloc]init];
        
        if(!_filterationInProgress)
            _filterationInProgress = [[NSMutableDictionary alloc]init];
        
        _downloadQueue = [[NSOperationQueue alloc]init];
        _downloadQueue.name = @"Download_Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
        
        _filterQueue = [[NSOperationQueue alloc]init];
        _filterQueue.name = @"Download_Queue";
        _filterQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}


- (NSMutableDictionary *)downloadsInProgress
{
    if(!_downloadsInProgress)
        _downloadsInProgress = [[NSMutableDictionary alloc]init];
    
    return _downloadsInProgress;
}

- (NSMutableDictionary *)filterationInProgress
{
    if(!_filterationInProgress)
        _filterationInProgress = [[NSMutableDictionary alloc]init];
    
    return _filterationInProgress;
}

- (NSOperationQueue *)downloadQueue
{
    if(!_downloadQueue)
    {
        _downloadQueue = [[NSOperationQueue alloc]init];
        _downloadQueue.name = @"Download_Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    
    return _downloadQueue;
}

- (NSOperationQueue *)filterQueue
{
    if(!_filterQueue)
    {
        _filterQueue = [[NSOperationQueue alloc]init];
        _filterQueue.name = @"Download_Queue";
        _filterQueue.maxConcurrentOperationCount = 1;
    }
    
    return _filterQueue;
}

@end
