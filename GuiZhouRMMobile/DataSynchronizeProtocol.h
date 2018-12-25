//
//  DataSynchronizeProtocol.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-8-13.
//
//

#import <Foundation/Foundation.h>

@protocol DataSynchronizeProtocol <NSObject>
@required
+ (void)synchronizeDataWithObject:(id)object modified:(BOOL *)modified;
@end
