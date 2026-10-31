import React, { useState } from 'react'
import type { StyleProp, ViewStyle } from 'react-native'
import NativeGlassButtonView, { type NativeProps } from './NativeGlassButtonNativeComponent'
import { isAvailable } from './platform'

export type GlassButtonMenuItem = {
  id: string
  title: string
  /** SF Symbol shown next to the title. */
  systemImage?: string
  /** Shown in red, for actions like delete. */
  destructive?: boolean
}

export type GlassButtonProps = Omit<
  NativeProps,
  'onGlassPress' | 'onGlassMenuSelect' | 'onGlassContentSize' | 'style' | 'menuItems'
> & {
  style?: StyleProp<ViewStyle>
  onPress?: () => void
  /** Turns the button into a menu button: tapping opens Apple's menu with these items. */
  menuItems?: GlassButtonMenuItem[]
  /** With menuItems: the id of the item the user chose. */
  onMenuSelect?: (id: string) => void
  /**
   * Size the button to its content (like width "auto"). A native view has no intrinsic
   * size in React Native layout, so the button measures its content and stays hidden
   * until that size is known, to avoid a visible jump. Give it a height in style.
   */
  autoWidth?: boolean
}

/**
 * A UIButton with the iOS 26 glass configuration ("glass", or "prominent" glass filled
 * with tintColor). Earlier iOS falls back to the plain / filled button styles. Give it a
 * size in style (e.g. 44 x 44 for an icon button) or use autoWidth. Renders nothing on
 * Android.
 */
export const GlassButton = ({ autoWidth, style, onPress, onMenuSelect, colorScheme = 'system', ...props }: GlassButtonProps) => {
  const [contentWidth, setContentWidth] = useState(0)
  if (!isAvailable) return null
  return (
    <NativeGlassButtonView
      {...props}
      colorScheme={colorScheme}
      style={[style, autoWidth ? { width: contentWidth || undefined, opacity: contentWidth ? 1 : 0 } : null]}
      onGlassPress={onPress ? () => onPress() : undefined}
      onGlassMenuSelect={onMenuSelect ? e => onMenuSelect(e.nativeEvent.id) : undefined}
      onGlassContentSize={autoWidth ? e => setContentWidth(e.nativeEvent.width) : undefined}
    />
  )
}
