//
//  DetailsViewController.h
//  MovieApp
//
//  Created by omnia on 3/16/18.
//  Copyright © 2018 omnia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface DetailsViewController : UIViewController
- (IBAction)displayTrailer:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *tvOverview;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewPoster;
@property (strong, nonatomic) IBOutlet UILabel *lblData;

//@property (strong, nonatomic) IBOutlet UILabel *lblOverview;
@property NSString *movieTitle;
@property NSString *releaseDate;
@property NSString *rate;
@property NSString *overview;
@property NSString *posterUrl;
@property NSNumber *movieId;

@end
