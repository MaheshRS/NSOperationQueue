//
//  ImageFilteration.h
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PhotoRecord.h"

@protocol  ImageFilterationDelegate;

@interface ImageFilteration : NSOperation

@property(nonatomic, assign)id<ImageFilterationDelegate>filterationDelegate;
@property(nonatomic, readonly, strong)NSIndexPath *tableIndexPath;
@property(nonatomic, readonly, strong)PhotoRecord *record;

- (id)initWithIndexPath:(NSIndexPath *)path photoRecord:(PhotoRecord *)photoRecord andDelegate:(id<ImageFilterationDelegate>)delegate;

@end

@protocol ImageDownloaderDelegate <NSObject>

- (void)didFinishFilteringImage:(ImageFilteration *)filteration;

@end