//
//  database.h
//  MovieApp
//
//  Created by omnia on 3/17/18.
//  Copyright © 2018 omnia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
+(Database*)sharedInstance;
@property (strong , nonatomic) NSString *posterPath;
@property (strong , nonatomic) NSString *overview;
@property (strong , nonatomic) NSString *releaseDate;
@property (strong , nonatomic) NSString *id;
@property (strong , nonatomic) NSString *title;
@property (strong , nonatomic) NSString *voteAverage;
@property (strong , nonatomic) NSString *status;



@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *movieDB;


-(void)saveData;
-(void)findContact;
-(NSMutableArray*)getAll;
-(void)deleteMovie:(NSString*)id;

@end

