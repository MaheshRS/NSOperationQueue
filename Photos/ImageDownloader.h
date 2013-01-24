//
//  ImageDownloader.h
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoRecord.h"

@protocol  ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation

@property(nonatomic, assign)id<ImageDownloaderDelegate>downloaderDelegate;
@property(nonatomic, readonly, strong)NSIndexPath *tableIndexPath;
@property(nonatomic, readonly, strong)PhotoRecord *record;

- (id)initWithIndexPath:(NSIndexPath *)path photoRecord:(PhotoRecord *)photoRecord andDelegate:(id<ImageDownloaderDelegate>)delegate;

@end

@protocol ImageDownloaderDelegate <NSObject>

- (void)didFinishDownloadingImage:(ImageDownloader *)downloader;

@end
