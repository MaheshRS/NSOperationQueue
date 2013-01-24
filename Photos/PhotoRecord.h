//
//  PhotoRecord.h
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoRecord : NSObject

@property(nonatomic, strong)NSString *name; // name of the image
@property(nonatomic, strong)NSURL *url; // url of the image
@property(nonatomic, strong)UIImage *image; // the acatual image
@property(nonatomic, assign)BOOL hasImage;

@property(nonatomic, assign, getter = isFiltered)BOOL filtered;
@property(nonatomic, assign, getter = isFailed)BOOL failed;


@end
