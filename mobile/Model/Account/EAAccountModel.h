//
//  EAAccountModel.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EABaseModel.h"
#import "IEAAccount.h"
#import "IEALogin.h"

typedef NS_ENUM(NSInteger, EALoginState) {
    EALoginStateUnkown = 0,
    EALoginStateNotLogined = 1,
    EALoginStateLogined = 2,
};

@interface EAAccountModel : EABaseModel<IEAAccount, IEALogin>

@property(nonatomic) EALoginState loginState;

@end
