#import "NativeGlassButtonView.h"

#import <react/renderer/components/NativeGlassButtonSpec/ComponentDescriptors.h>
#import <react/renderer/components/NativeGlassButtonSpec/EventEmitters.h>
#import <react/renderer/components/NativeGlassButtonSpec/Props.h>
#import <react/renderer/components/NativeGlassButtonSpec/RCTComponentViewHelpers.h>

#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>

using namespace facebook::react;

@interface NativeGlassButtonView () <RCTNativeGlassButtonViewProtocol>
@end

@implementation NativeGlassButtonView {
  UIButton *_button;
  CGSize _reportedSize;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<NativeGlassButtonComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const NativeGlassButtonProps>();
    _props = defaultProps;

    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
    self.contentView = _button;
  }
  return self;
}

/// The iOS 26 glass configuration (UIButton.Configuration.glass() / .prominentGlass()),
/// looked up by name so this still compiles and runs where it doesn't exist; there it
/// falls back to the plain / filled configuration.
static UIButtonConfiguration *GlassConfiguration(BOOL prominent)
{
  SEL selector = NSSelectorFromString(prominent ? @"prominentGlassButtonConfiguration" : @"glassButtonConfiguration");
  if ([UIButtonConfiguration respondsToSelector:selector]) {
    UIButtonConfiguration *(*make)(id, SEL) = (UIButtonConfiguration * (*)(id, SEL))
        [UIButtonConfiguration methodForSelector:selector];
    return make([UIButtonConfiguration class], selector);
  }
  return prominent ? [UIButtonConfiguration filledButtonConfiguration] : [UIButtonConfiguration plainButtonConfiguration];
}

static NSString *ToNSString(const std::string &value)
{
  return value.empty() ? nil : [NSString stringWithUTF8String:value.c_str()];
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &p = *std::static_pointer_cast<NativeGlassButtonProps const>(props);
  BOOL prominent = p.variant == NativeGlassButtonVariant::Prominent;

  UIButtonConfiguration *config = GlassConfiguration(prominent);
  NSString *symbol = ToNSString(p.systemImage);
  if (symbol) {
    config.image = [UIImage systemImageNamed:symbol];
    config.preferredSymbolConfigurationForImage =
        [UIImageSymbolConfiguration configurationWithPointSize:17 weight:UIImageSymbolWeightSemibold];
  }
  config.title = ToNSString(p.title);

  UIColor *tint = RCTUIColorFromSharedColor(p.tintColor);
  UIColor *foreground = RCTUIColorFromSharedColor(p.foregroundColor);
  if (prominent) {
    if (tint) {
      config.baseBackgroundColor = tint;
    }
    if (foreground) {
      config.baseForegroundColor = foreground;
    }
  } else if (tint) {
    config.baseForegroundColor = tint;
  }
  config.showsActivityIndicator = p.loading;
  _button.configuration = config;
  _button.enabled = !p.disabled;

  if (p.menuItems.empty()) {
    _button.menu = nil;
    _button.showsMenuAsPrimaryAction = NO;
  } else {
    NSMutableArray<UIMenuElement *> *actions = [NSMutableArray new];
    __weak NativeGlassButtonView *weakSelf = self;
    for (const auto &item : p.menuItems) {
      NSString *itemId = ToNSString(item.id) ?: @"";
      NSString *symbol = ToNSString(item.systemImage);
      UIAction *action = [UIAction actionWithTitle:ToNSString(item.title) ?: @""
                                             image:symbol ? [UIImage systemImageNamed:symbol] : nil
                                        identifier:nil
                                           handler:^(__kindof UIAction *_Nonnull a) {
                                             [weakSelf menuSelected:itemId];
                                           }];
      if (item.destructive) {
        action.attributes = UIMenuElementAttributesDestructive;
      }
      [actions addObject:action];
    }
    _button.menu = [UIMenu menuWithChildren:actions];
    _button.showsMenuAsPrimaryAction = YES;
  }

  NSString *label = ToNSString(p.label);
  _button.accessibilityLabel = label ?: config.title;

  switch (p.colorScheme) {
    case NativeGlassButtonColorScheme::Light:
      _button.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
      break;
    case NativeGlassButtonColorScheme::Dark:
      _button.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
      break;
    case NativeGlassButtonColorScheme::System:
      _button.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
      break;
  }

  [super updateProps:props oldProps:oldProps];
  [self setNeedsLayout];
}

- (void)updateEventEmitter:(const EventEmitter::Shared &)eventEmitter
{
  [super updateEventEmitter:eventEmitter];
  _reportedSize = CGSizeZero;
  [self setNeedsLayout];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  // Report the size the content needs, so JS can size the button to its label.
  CGSize fit = [_button sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height ?: 44)];
  fit = CGSizeMake(ceil(fit.width), ceil(fit.height));
  if (!CGSizeEqualToSize(fit, _reportedSize) && _eventEmitter) {
    _reportedSize = fit;
    std::static_pointer_cast<const NativeGlassButtonEventEmitter>(_eventEmitter)
        ->onGlassContentSize(NativeGlassButtonEventEmitter::OnGlassContentSize{.width = fit.width, .height = fit.height});
  }
}

- (void)menuSelected:(NSString *)itemId
{
  if (!_eventEmitter) {
    return;
  }
  std::static_pointer_cast<const NativeGlassButtonEventEmitter>(_eventEmitter)
      ->onGlassMenuSelect(NativeGlassButtonEventEmitter::OnGlassMenuSelect{.id = std::string([itemId UTF8String])});
}

- (void)pressed
{
  if (!_eventEmitter) {
    return;
  }
  std::static_pointer_cast<const NativeGlassButtonEventEmitter>(_eventEmitter)
      ->onGlassPress(NativeGlassButtonEventEmitter::OnGlassPress{});
}

@end
