//
//  DataBase.m
//
//
//  Created by omnia on 3/2/18.
//  Copyright © 2018 omnia. All rights reserved.
//

#import "Database.h"


@implementation Database
+(Database *)sharedInstance{
    static Database * sharedInstance=nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        sharedInstance=[[Database alloc] init];
    });
    return sharedInstance;
}
- (id)init
{
    self = [super init];
    if (self) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(
                                                       NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = dirPaths[0];
        
        // Build the path to the database file
        _databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"movies.db"]];
        
        
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_movieDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS MOVIES (ID TEXT PRIMARY KEY , posterPath TEXT, overview TEXT,releaseDate TEXT,title TEXT,voteAverage TEXT)";
            printf("1");
            
            if (sqlite3_exec(_movieDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _status = @"Failed to create table";
                printf("%s",[_status UTF8String]);
            }
            sqlite3_close(_movieDB);
        } else {
            _status = @"Failed to open/create database";
            printf("%s",[_status UTF8String]);
        }
    }
    return self;
}
-(void)saveData{
    
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_movieDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO MOVIES (id,posterPath, overview, releaseDate,title,voteAverage) VALUES (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",
                               _id,_posterPath,_overview, _releaseDate,_title,_voteAverage];
        printf("%s",[insertSQL UTF8String]);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_movieDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _status = @"Contact added";
            printf("%s",[_status UTF8String]);
        } else {
            _status = @"Failed to add contact";
            printf("%s  %s",[_status UTF8String], sqlite3_errmsg(_movieDB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_movieDB);
    }
    
    
}
-(void)findContact{
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_movieDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT title, releaseDate FROM MOVIES WHERE id=\"%@\"",
                              _id];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_movieDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *ftitle = [[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 0)];
                _title=ftitle;
                NSString *freleaseDate = [[NSString alloc]
                                          initWithUTF8String:(const char *)
                                          sqlite3_column_text(statement, 1)];
                _releaseDate=freleaseDate;
                
                _status = @"Match found";
            } else {
                _status = @"Match not found";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_movieDB);
    }
    
    
    
}
-(void)deleteMovie:(NSString*)id{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &_movieDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM MOVIES WHERE id=\"%@\"",
                              id];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_movieDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_movieDB);
    }
}
-(NSMutableArray *)getAll{
    NSMutableArray *allRows = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_movieDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT id,posterPath,overview, releaseDate,title,voteAverage FROM MOVIES"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_movieDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statement) == SQLITE_ROW){
                NSString *fid = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 0)];
                NSString *posterPath = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 1)];
                
                NSString *overview = [[NSString alloc]
                                      initWithUTF8String:(const char *)
                                      sqlite3_column_text(statement, 2)];
                NSString *releaseDate = [[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement, 3)];
                
                NSString *title = [[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement,4)];
                NSString *voteAverage = [[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement, 5)];
//                [movie setPoster_path:posterPath];
//                [movie setOverview:overview];
//                [movie setId:fid];
//                [movie setTitle:title];
//                [movie setVote_average:voteAverage];
//                [allRows addObject:movie];
                printf("%s","done");
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_movieDB);
    }
    
    
    return allRows;
}

@end
