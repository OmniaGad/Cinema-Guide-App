//
//  HomeCollectionViewController.m
//  MovieApp
//
//  Created by omnia on 2/28/18.
//  Copyright © 2018 omnia. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface HomeCollectionViewController (){
    NSString *url;
    NSDictionary *dict;
    NSData *mydata;
    NSMutableArray *posterImages;
    NSMutableArray *titles ;
    NSMutableArray *overviews;
    NSMutableArray *ratings;
    NSMutableArray *releaseDates;
    NSMutableArray *moviesID;
    NSString *imgpath;
    NSDictionary *dict2;
    NSData *myData;
    NSString *data;
    NSURL *moviesUrl;
    NSMutableArray *imgCollection;
    NSURLRequest *request;
    NSMutableArray *realImages;
    Boolean flag;
}
//


@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    flag = YES;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    url = @"https://api.themoviedb.org/3/movie/popular?api_key=6748bdb1361346f68eed41f39ddaecd1&language=en-US&page=1";

    moviesUrl = [NSURL URLWithString:url];
    request = [NSURLRequest requestWithURL:moviesUrl];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response , id responseObject, NSError *error){
        if(error){
            NSLog(@"Error: %@",error);
        } else {
            data =[[NSString alloc] initWithContentsOfURL:moviesUrl encoding:NSUTF8StringEncoding error:nil];
            myData = [data dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
            posterImages = [NSMutableArray new];
            
            titles = [NSMutableArray new];
            overviews = [NSMutableArray new];
            ratings = [NSMutableArray new];
            releaseDates = [NSMutableArray new];
            moviesID = [NSMutableArray new];
            imgpath = @"http://image.tmdb.org/t/p/w185";

            NSArray *arr = [dict objectForKey:@"results"];
            for (int i=0; i<[arr count]; i++) {
                  NSString *ns=[imgpath stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"poster_path"]];
                [posterImages addObject:ns];
                [titles addObject:[[arr objectAtIndex:i] objectForKey:@"original_title"]];
                [overviews addObject:[[arr objectAtIndex:i] objectForKey:@"overview"]];
                [ratings addObject:[[arr objectAtIndex:i] objectForKey:@"vote_average"]];
                [releaseDates addObject:[[arr objectAtIndex:i] objectForKey:@"release_date"]];
                [moviesID addObject:[[arr objectAtIndex:i] objectForKey:@"id"]];
            }
            [self.view reloadInputViews];
            [self.collectionView reloadData];
           // printf("%lu",(unsigned long)[arr count]);
//            printf("aaaaaa");
//            NSLog(@"%lu",(unsigned long)[titles count]);
         //   NSLog(@"%@",posterImages);
//                NSLog(@"%@",titles);
//            NSLog(@"%@",overviews);
            NSLog(@"%@",moviesID);
//            NSLog(@"%@",releaseDates);
            
            
        }
    }];
    [dataTask resume];
    
    
    }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    printf("%lu",(unsigned long)[posterImages count]);
   // NSLog(@"%lu",(unsigned long)[titles count]);

    return [posterImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    [_imgs sd_setImageWithURL:[NSURL URLWithString:@"http://image.tmdb.org/t/p/w185//coss7RgL0NH6g4fC2s5atvf3dFO.jpg"] ];
    //[cell addSubview:_imgs];    // Configure the cell
    
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
  //  NSLog([posterImages objectAtIndex:indexPath.row]);
        NSURL* imageURL = [[NSURL alloc] initWithString:[posterImages objectAtIndex:indexPath.row]];
    
     [imageView sd_setImageWithURL:imageURL];
    
//    [imageView sd_setImageWithURL:[posterImages objectAtIndex:indexPath.row]];
      //  [cell addSubview:imageView];
 
    
    
    
    return cell;
}




#pragma mark <UICollectionViewDelegate>





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    NSString *myTitle = [titles objectAtIndex:indexPath.row];
    NSString *myOverview = [overviews objectAtIndex:indexPath.row];
    
    NSNumber *movieRate = [ratings objectAtIndex:indexPath.row];
    NSString *movieRateString = [NSString stringWithFormat:@"%@",movieRate];
    NSString *releaseDate = [releaseDates objectAtIndex:indexPath.row];
    
    NSString *poster = [posterImages objectAtIndex:indexPath.row];
    NSNumber *movieID = [moviesID objectAtIndex:indexPath.row];
    [second setMovieTitle:myTitle];
    [second setOverview:myOverview];
    [second setRate:movieRateString];
    [second setReleaseDate:releaseDate];
    [second setPosterUrl:poster];
    [second setMovieId:movieID];
    
    [self.navigationController pushViewController:second animated:YES];
    


}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Top Rated"]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                url = @"https://api.themoviedb.org/3/movie/top_rated?api_key=6748bdb1361346f68eed41f39ddaecd1&language=en-US&page=1";
        moviesUrl = [NSURL URLWithString:url];
        request = [NSURLRequest requestWithURL:moviesUrl];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response , id responseObject, NSError *error){
            if(error){
                NSLog(@"Error: %@",error);
            } else {
                data =[[NSString alloc] initWithContentsOfURL:moviesUrl encoding:NSUTF8StringEncoding error:nil];
                myData = [data dataUsingEncoding:NSUTF8StringEncoding];
                dict = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
                posterImages = [NSMutableArray new];
                titles = [NSMutableArray new];
                overviews = [NSMutableArray new];
                ratings = [NSMutableArray new];
                releaseDates = [NSMutableArray new];
                imgpath = @"http://image.tmdb.org/t/p/w185";
                NSArray *arr = [dict objectForKey:@"results"];
                for (int i=0; i<[arr count]; i++) {
                    NSString *ns=[imgpath stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"poster_path"]];
                    [posterImages addObject:ns];
                    [titles addObject:[[arr objectAtIndex:i] objectForKey:@"original_title"]];
                    [overviews addObject:[[arr objectAtIndex:i] objectForKey:@"overview"]];
                    [ratings addObject:[[arr objectAtIndex:i] objectForKey:@"vote_average"]];
                    [releaseDates addObject:[[arr objectAtIndex:i] objectForKey:@"release_date"]];
                }
                [self.view reloadInputViews];
                [self.collectionView reloadData];
                NSLog(@"%@",ratings);
            }
        }];
        [dataTask resume];

    }
    if ([buttonTitle isEqualToString:@"Most Popular"]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        url = @"https://api.themoviedb.org/3/movie/popular?api_key=6748bdb1361346f68eed41f39ddaecd1&language=en-US&page=1";
        moviesUrl = [NSURL URLWithString:url];
        request = [NSURLRequest requestWithURL:moviesUrl];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response , id responseObject, NSError *error){
            if(error){
                NSLog(@"Error: %@",error);
            } else {
                data =[[NSString alloc] initWithContentsOfURL:moviesUrl encoding:NSUTF8StringEncoding error:nil];
                myData = [data dataUsingEncoding:NSUTF8StringEncoding];
                dict = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
                posterImages = [NSMutableArray new];
                titles = [NSMutableArray new];
                overviews = [NSMutableArray new];
                ratings = [NSMutableArray new];
                releaseDates = [NSMutableArray new];
                imgpath = @"http://image.tmdb.org/t/p/w185";
                NSArray *arr = [dict objectForKey:@"results"];
                for (int i=0; i<[arr count]; i++) {
                    NSString *ns=[imgpath stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"poster_path"]];
                    [posterImages addObject:ns];
                    [titles addObject:[[arr objectAtIndex:i] objectForKey:@"original_title"]];
                    [overviews addObject:[[arr objectAtIndex:i] objectForKey:@"overview"]];
                    [ratings addObject:[[arr objectAtIndex:i] objectForKey:@"vote_average"]];
                    [releaseDates addObject:[[arr objectAtIndex:i] objectForKey:@"release_date"]];
                }
                [self.view reloadInputViews];
                [self.collectionView reloadData];
                NSLog(@"%@",ratings);
            }
        }];
        [dataTask resume];
    }
}
- (IBAction)btnGetTopRated:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Top Rated",@"Most Popular", nil];
    [actionSheet showInView:self.view];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 25, 10, 25);
}

@end
