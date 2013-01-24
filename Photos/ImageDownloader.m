//
//  ImageDownloader.m
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader()

@property(nonatomic, readwrite, strong)NSIndexPath *tableIndexPath;
@property(nonatomic, readwrite, strong)PhotoRecord *record;

@end

@implementation ImageDownloader

@synthesize tableIndexPath = _tableIndexPath;
@synthesize record = _record;
@synthesize downloaderDelegate = _downloaderDelegate;

- (id)initWithIndexPath:(NSIndexPath *)path photoRecord:(PhotoRecord *)photoRecord andDelegate:(id<ImageDownloaderDelegate>)delegate
{
    self = [super init];
    
    if(self)
    {
        self.tableIndexPath = path;
        self.record = photoRecord;
        self.downloaderDelegate = delegate;
    }
    
    return self;
}

#pragma mark - DownloadImage
- (void)main
{
    @autoreleasepool {
        
        if(self.isCancelled)
            return;
        
        NSData *data = [NSData dataWithContentsOfURL:self.record.url];
        
        if(self.isCancelled)
        {
            self.record.image = nil;
            return;
        }
        
        if(data)
        {
            self.record.image = [UIImage imageWithData:data];
        }
        else
        {
            self.record.failed = YES;
            self.record.image = nil;
        }
        
        data  = nil;
        
        if(self.isCancelled)
        {
            return;
        }
        
        [(NSObject *)self.downloaderDelegate performSelectorOnMainThread:@selector(didFinishDownloadingImage:) withObject:self waitUntilDone:NO];

    }

}

@end
