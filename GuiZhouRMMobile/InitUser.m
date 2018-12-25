//
//  InitUser.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitUser.h"
#import "UserInfo.h"


@implementation InitUser

-(void)downLoadUserInfo{
    WebServiceInit;
    [service getUserInfo];
 
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"UserInfo"];
    NSError *error=nil;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    
    TBXMLElement *r1=[TBXML childElementNamed:@"getUserInfoListResponse" parentElement:rf];
//    if (r1 == nil) {
//        NSDictionary *postInfo = [NSDictionary dictionaryWithObject:DownLoadErrorMessage forKey:@"message"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadError" object:postInfo];
//        return;
//    }
    
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
        
    TBXMLElement *author=[TBXML childElementNamed:@"ns1:UserInfoModel" parentElement:r2];
    if (author!=nil){
        do {
            TBXMLElement *myid=[TBXML childElementNamed:@"id" parentElement:author];
            if (myid!=nil){
                NSString *myid_string=[TBXML textForElement:myid];
                
                TBXMLElement *account=[TBXML childElementNamed:@"account" parentElement:author];
                NSString *account_string=[TBXML textForElement:account];
                
                TBXMLElement *orgID=[TBXML childElementNamed:@"orgID" parentElement:author];
                NSString *orgID_string=[TBXML textForElement:orgID];
                    
                TBXMLElement *username=[TBXML childElementNamed:@"username" parentElement:author];
                NSString *username_string=[TBXML textForElement:username];
                    
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
                UserInfo *newInfo=[[UserInfo alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                newInfo.myid=myid_string;
                newInfo.account=account_string;
                newInfo.orgid=orgID_string;
                newInfo.username=username_string;
                TBXMLElement *password=[TBXML childElementNamed:@"password" parentElement:author];
                newInfo.password=[TBXML textForElement:password];
                TBXMLElement *employee_id=[TBXML childElementNamed:@"employee_id" parentElement:author];
                newInfo.employee_id=[TBXML textForElement:employee_id];
                TBXMLElement *isadmin = [TBXML childElementNamed:@"isadmin" parentElement:author];
                newInfo.isadmin = @([TBXML textForElement:isadmin].boolValue);
                [context save:nil];
            }
        } while ((author=author->nextSibling));
    }
}
@end
