import { codegenNativeComponent, type CodegenTypes, type ColorValue, type ViewProps } from 'react-native'

type MenuItem = Readonly<{
  id: string
  title: string
  /** SF Symbol shown next to the title. */
  systemImage?: string
  /** Shown in red, for actions like remove / delete. */
  destructive?: boolean
}>

export interface NativeProps extends ViewProps {
  /** SF Symbol for the button, e.g. "xmark" or "chevron.left". */
  systemImage?: string
  title?: string
  /** 'glass' is the clear glass button; 'prominent' is glass filled with tintColor. */
  variant?: CodegenTypes.WithDefault<'glass' | 'prominent', 'glass'>
  /** Icon / title colour for 'glass'; the fill for 'prominent'. */
  tintColor?: ColorValue
  /** Icon / title colour on a 'prominent' button. */
  foregroundColor?: ColorValue
  /** What VoiceOver reads (an icon-only button has no title of its own). */
  label?: string
  colorScheme?: CodegenTypes.WithDefault<'light' | 'dark' | 'system', 'system'>
  disabled?: boolean
  /** Shows the system activity indicator in place of the icon. */
  loading?: boolean
  /**
   * When set, tapping the button opens Apple's menu with these items (glass on iOS 26)
   * instead of firing onPress; the chosen item comes back through onMenuSelect.
   */
  menuItems?: ReadonlyArray<MenuItem>
  // Event names are global across native components; generic ones (topPress) are
  // already registered as bubbling by other components, so ours are prefixed.
  onGlassPress?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  onGlassMenuSelect?: CodegenTypes.DirectEventHandler<Readonly<{ id: string }>>
  /** The button's natural size for its content (used to size it to its label). */
  onGlassContentSize?: CodegenTypes.DirectEventHandler<Readonly<{ width: CodegenTypes.Double; height: CodegenTypes.Double }>>
}

export default codegenNativeComponent<NativeProps>('NativeGlassButton')
