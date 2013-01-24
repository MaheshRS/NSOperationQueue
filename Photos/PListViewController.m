//
//  PListViewController.m
//  Photos
//
//  Created by Mahesh on 1/24/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import "PListViewController.h"
#import "PhotoRecord.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "ImageFilteration.h"

#import "AFNetworking/AFNetworking.h"

#define kDatasourceURLString @"https://sites.google.com/site/soheilsstudio/tutorials/nsoperationsampleproject/ClassicPhotosDictionary.plist"

@interface PListViewController ()

@property (nonatomic, strong)NSMutableArray  *data;
@property (nonatomic, strong)PendingOperations *pendingOperations;

- (void)initDictionary;

@end

@implementation PListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if (!_pendingOperations) {
            _pendingOperations = [[PendingOperations alloc] init];
        }
        
        [self populatedata];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Data
- (void)initDictionary
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.accessoryView = activityIndicatorView;
    }
    
    PhotoRecord *record = self.data[[indexPath row]];
    
    if(record.hasImage)
    {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.imageView.image = record.image;
        cell.textLabel.text = record.name;
    }
    else if(record.failed)
    {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.imageView.image = [UIImage imageNamed:@"Failed.png"];
        cell.textLabel.text = @"Failed";
    }
    else
    {
        [((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        cell.textLabel.text = @"Failed";
        [self addOperations:self.data[[indexPath row]] andIndexPath:indexPath];

    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Lazy Initialization
- (void)populatedata
{
    if(!self.data)
    { 
        NSURL *listUrl = [NSURL URLWithString:kDatasourceURLString];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:listUrl]];
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        typeof(self) __weak weakself = self;
        
        [requestOperation   setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData *data = (NSData *)responseObject;
            CFPropertyListRef list = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data, kCFPropertyListImmutable, NULL);
            NSDictionary *urlList = (__bridge NSDictionary*)list;
            
            NSMutableArray *array = [NSMutableArray array];
            
            for(NSString *key in [urlList allKeys])
            {
                PhotoRecord *record = [[PhotoRecord alloc]init];
                record.url = [NSURL URLWithString:(NSString *)urlList[key]];
                record.name = key;
                
                [array addObject:record];
                record = nil;
            }
            
            weakself.data = array;
            CFRelease(list);
            
            
            [weakself.tableView reloadData];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error");
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            
        }];
        
        [self.pendingOperations.downloadQueue addOperation:requestOperation];
    }
}


#pragma mark - Add Operations
- (void)addOperations:(PhotoRecord *)record andIndexPath:(NSIndexPath *)path
{
    if (!record.hasImage) {
        [self startImageDownloadingForRecord:record atIndexPath:path];
        
    }
    
    if (!record.isFiltered) {
        [self startImageFiltrationForRecord:record atIndexPath:path];
    }
}

- (void)startImageDownloadingForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {

    if (![_pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
     
        // Start downloading
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithIndexPath:indexPath photoRecord:record andDelegate:(id)self];
        [_pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [_pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)startImageFiltrationForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {

    if (![_pendingOperations.filterationInProgress.allKeys containsObject:indexPath]) {
        

        ImageFilteration *imageFiltration = [[ImageFilteration alloc] initWithIndexPath:indexPath photoRecord:record andDelegate:(id)self];

        ImageDownloader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        
        [_pendingOperations.filterationInProgress setObject:imageFiltration forKey:indexPath];
        [_pendingOperations.filterQueue addOperation:imageFiltration];
    }
}

- (void)didFinishDownloadingImage:(ImageDownloader *)downloader {
    

    NSIndexPath *indexPath = downloader.tableIndexPath;

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

- (void)didFinishFilteringImage:(ImageFilteration *)filteration {
    NSIndexPath *indexPath = filteration.tableIndexPath;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_pendingOperations.filterationInProgress removeObjectForKey:indexPath];
}

@end
