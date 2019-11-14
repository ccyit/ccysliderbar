//
//  ChartConst.h
//  TradeNow
//
//  Created by fantaros on 15/10/22.
//  Copyright (c) 2015年 Shanghai Futures Information Technology  Co.,Ltd. All rights reserved.
//

#define ChartColorWithHex(hexValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0    \
blue:((float)(hexValue & 0xFF))/255.0             \
alpha:1.0]

#ifndef TradeNow_ChartConst_h
#define TradeNow_ChartConst_h

#define TNW_SLIDERBAR_INNERCYCLE_COLOR ChartColorWithHex(0x44B3FF)
#define TNW_SLIDERBAR_OUTERCYCLE_COLOR [UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:0.6]

#endif
