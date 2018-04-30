//
//  DetailsViewController.m
//  MovieApp
//
//  Created by omnia on 3/16/18.
//  Copyright © 2018 omnia. All rights reserved.
//

#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController (){
    NSString *apiKey;
    NSString *strMovieId;
    NSString *firstPart;
    NSString *secondPart;
    NSString *fullUrl;
    NSURL *moviesUrl;
    NSURLRequest *request;
    NSString *data;
    NSDictionary *dict;
    NSData *myData;
    NSMutableArray *trailersKey;
    NSString *str;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    apiKey = @"/videos?api_key=6748bdb1361346f68eed41f39ddaecd1";
    // Do any additional setup after loading the view.
    //NSLog(@"%@",_movieId);
    strMovieId = [NSString stringWithFormat:@"%@",_movieId];
    firstPart = @"https://api.themoviedb.org/3/movie/";
    secondPart = @"&language=en-US";
    fullUrl = [[[firstPart stringByAppendingString:strMovieId] stringByAppendingString:apiKey] stringByAppendingString:secondPart];
    NSLog(@"%@",fullUrl);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    moviesUrl = [NSURL URLWithString:fullUrl];
    request = [NSURLRequest requestWithURL:moviesUrl];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response , id responseObject, NSError *error){
        if(error){
            NSLog(@"Error: %@",error);
        } else {
            data =[[NSString alloc] initWithContentsOfURL:moviesUrl encoding:NSUTF8StringEncoding error:nil];
            myData = [data dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
            trailersKey = [NSMutableArray new];
            NSArray *arr = [dict objectForKey:@"results"];
            for (int i=0; i<[arr count]; i++) {
                [trailersKey addObject:[[arr objectAtIndex:i] objectForKey:@"key"]];
            }
            [self.view reloadInputViews];
            // printf("%lu",(unsigned long)[arr count]);
            //            printf("aaaaaa");
            //            NSLog(@"%lu",(unsigned long)[titles count]);
            //   NSLog(@"%@",posterImages);
            //                NSLog(@"%@",titles);
            //            NSLog(@"%@",overviews);
            NSLog(@"%@",trailersKey);
            //            NSLog(@"%@",releaseDates);
            str = @"http://youtube.com/watch?v=";
            str = [str stringByAppendingString:trailersKey[0]];
            NSLog(@"%@",str);
            
        }
    }];
    [dataTask resume];
    
    
    [self.view reloadInputViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   }

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [_lblTitle setText:_movieTitle];
    [_lblData setText:_releaseDate];
    [_lblRating setText:_rate];
    //[_lblOverview setText:_overview];
    [_tvOverview setText:_overview];
    NSURL* imageURL = [[NSURL alloc] initWithString:_posterUrl];
    
    [_imgViewPoster sd_setImageWithURL:imageURL];

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)displayTrailer:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
@end
