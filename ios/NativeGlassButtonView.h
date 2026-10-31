#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef NativeGlassButtonView_h
#define NativeGlassButtonView_h

NS_ASSUME_NONNULL_BEGIN

/// A UIButton with the iOS 26 glass configuration as a Fabric component: the glass
/// material, press highlight and shape come from UIKit.
@interface NativeGlassButtonView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* NativeGlassButtonView_h */
