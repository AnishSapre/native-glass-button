# native-glass-button

[![npm](https://img.shields.io/npm/v/native-glass-button.svg)](https://www.npmjs.com/package/native-glass-button) [![license](https://img.shields.io/npm/l/native-glass-button.svg)](https://github.com/AnishSapre/native-glass-button/blob/main/LICENSE)

**npm:** [native-glass-button](https://www.npmjs.com/package/native-glass-button) · **GitHub:** [AnishSapre/native-glass-button](https://github.com/AnishSapre/native-glass-button)

iOS 26 **liquid glass buttons** for React Native: a `UIButton` with Apple's glass
(`UIButton.Configuration.glass()`) or prominent glass configuration, with optional native
menus (`UIMenu`). On earlier iOS it falls back to the plain / filled system styles.

## Requirements

- React Native 0.76+ with the **New Architecture** (Fabric). This is a Fabric component;
  it has no old-architecture (Paper) implementation.
- **iOS only.** On Android the component renders nothing, so check `isAvailable` (or
  `Platform.OS`) and render your own fallback there.
- The liquid glass look needs **iOS 26+** (built with the iOS 26 SDK or later). On earlier
  iOS you get the classic system look. `hasLiquidGlass` tells you which one is showing.

## Install

```sh
npm install native-glass-button
cd ios && pod install
```

Then rebuild the app (a Metro reload is not enough for new native code).

## Usage

```tsx
import { GlassButton } from 'native-glass-button'

// Round icon button
<GlassButton style={{ width: 44, height: 44 }} systemImage="xmark" label="Close" onPress={close} />

// Prominent (filled) button sized to its title
<GlassButton
  autoWidth
  style={{ height: 50 }}
  variant="prominent"
  title="Next"
  tintColor="#4D2E97"
  foregroundColor="#FFFFFF"
  loading={saving}
  disabled={!valid}
  onPress={next}
/>

// Menu button
<GlassButton
  style={{ width: 44, height: 44 }}
  systemImage="ellipsis"
  label="More actions"
  menuItems={[
    { id: 'edit', title: 'Edit', systemImage: 'pencil' },
    { id: 'delete', title: 'Delete', systemImage: 'trash', destructive: true },
  ]}
  onMenuSelect={id => (id === 'edit' ? edit() : remove())}
/>
```

| Prop | Type | |
|---|---|---|
| `systemImage` | `string` | SF Symbol |
| `title` | `string` | |
| `variant` | `'glass' \| 'prominent'` | Default `'glass'` |
| `tintColor` | colour | Icon / title colour (glass); fill (prominent) |
| `foregroundColor` | colour | Icon / title colour on a prominent button |
| `label` | `string` | VoiceOver label (icon-only buttons need one) |
| `disabled` / `loading` | `boolean` | Loading shows the system activity indicator |
| `menuItems` / `onMenuSelect` | see above | Tapping opens the menu instead of `onPress` |
| `autoWidth` | `boolean` | Size to content; still give a height |
| `colorScheme` | `'light' \| 'dark' \| 'system'` | Default `'system'` |

A native view has no intrinsic size in React Native layout: give the button a size in
`style`, or `autoWidth` plus a height.

## How it works

A small Fabric component wraps Apple's own UIKit control, so iOS draws and animates it.
React Native's codegen builds the bridge from the TypeScript spec in
`src/*NativeComponent.ts` during `pod install`.

## Related packages

Native iOS controls for React Native (New Architecture), with liquid glass on iOS 26:

- [native-tab-bar](https://github.com/AnishSapre/native-tab-bar) ([npm](https://www.npmjs.com/package/native-tab-bar)): Apple's UITabBar (iOS 26 liquid glass tab bar) with a React Navigation adapter
- [native-segmented-control](https://github.com/AnishSapre/native-segmented-control) ([npm](https://www.npmjs.com/package/native-segmented-control)): Apple's UISegmentedControl
- [native-slider](https://github.com/AnishSapre/native-slider) ([npm](https://www.npmjs.com/package/native-slider)): Apple's UISlider

## License

MIT © Anish Sapre
