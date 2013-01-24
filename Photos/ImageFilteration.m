//
//  ImageFilteration.m
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import "ImageFilteration.h"
#import <CoreImage/CoreImage.h>

@interface ImageFilteration()

@property(nonatomic, readwrite, strong)NSIndexPath *tableIndexPath;
@property(nonatomic, readwrite, strong)PhotoRecord *record;

@end

@implementation ImageFilteration

@synthesize tableIndexPath = _tableIndexPath;
@synthesize record = _record;
@synthesize filterationDelegate = _filterationDelegate;

- (id)initWithIndexPath:(NSIndexPath *)path photoRecord:(PhotoRecord *)photoRecord andDelegate:(id<ImageFilterationDelegate>)delegate
{
    self = [super init];
    
    if(self)
    {
        self.tableIndexPath = path;
        self.record = photoRecord;
        self.filterationDelegate = delegate;
    }
    
    return self;
}

- (void)main
{
    @autoreleasepool
    {
        if(self.isCancelled || !self.record.image)
            return;
        
        UIImage *processedIamge = [self applyFilterToImage:self.record.image];
        
        if(self.isCancelled)
        {
            return;
        }
        
        if(processedIamge)
        {
            self.record.image = processedIamge;
            self.record.filtered = YES;
            [(NSObject *)self.filterationDelegate performSelectorOnMainThread:@selector(didFinishFilteringImage:) withObject:self waitUntilDone:NO];
        }
    }
}

#pragma mark - image filtering
- (UIImage *)applyFilterToImage:(UIImage *)image
{
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    UIImage *filteredImage = nil;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,inputImage,@"inputIntensity",[NSNumber numberWithFloat:0.8],nil];
    CIImage *imageOut = [filter outputImage];
    CGImageRef imageOutRef = [context createCGImage:imageOut fromRect:[imageOut extent]];
    
    filteredImage = [UIImage imageWithCGImage:imageOutRef];
    CGImageRelease(imageOutRef);
    
    return filteredImage;
    
}
@end
