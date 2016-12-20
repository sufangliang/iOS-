//
//  EAAssetsModel.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EABaseModel.h"
#import "IEAAssets.h"
#import "IEAWalletAssets.h"
#import "IEAYdbAssets.h"

@interface EAAssetsModel : EABaseModel<IEAAssets, IEAWalletAssets, IEAYdbAssets>

@end
