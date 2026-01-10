## 0.2.7
* feat(widget): add async widget capabilities
* feat(composables): add useListen and useModel
* feat(widget): export useInherited composable
* feat(widget): add extension for Watch widget creation
* feat(core): Add `$` alias for value getter
* refactor(asyncComputed): expose all parameters
* feat: Introduce reactive `useInherited` hook
* refactor: clean up code and update dependencies

## 0.2.6
* add `useStream`

## 0.2.5
* Add async request, pagination, load more, polling.
* Add `useDark` to reactively check for dark mode.
* Add `useTheme` to access the current theme.
* Add `useWidgetSize` to get the reactive size of a widget.
* Add `useWidgetBox` to get the reactive constraints of a widget.

## 0.2.4
* Update document

## 0.2.3
* Add new API for KaeruWidget lifecycle hooks and composables
* 
* - Introduced new lifecycle hooks in `KaeruLifeMixin`
* - Added composables for `useKeepAliveClient` and `useRestoration`...
* - Updated existing hooks to support additional parameters and functionality
* - Removed deprecated advanced widget implementations

## 0.2.2
* Add advanced widget classes for KaeruWidget library
* Compsables core flutter

## 0.2.1
* Add useContext and useWidget functions for improved context  management within the Kaeru Widget module.

## 0.2.0
* feat: add `KaeruWidget`
* break: remove `defineWidget`

## 0.1.17
* feat: add `mounted` for composible ref api
* change syntax `useRef(ref, fn)` -> `useRef(fn)`

## 0.1.16
* feat: add `defineWidget`

## 0.1.15
* feat: add `dependencies` option to `Watch` widget reactive static dependencies

## 0.1.14
* Add `onWatcherCleanup` and `nextTick`

## 0.1.13
* Add `usePick` in `Watch`

## 0.1.12
* Fix typo

## 0.1.11
* Add `KaeruBuilder`

## 0.1.9
* Remove `context` in `Watch`. Now you can use
```dart
Watch(() => Text('Hello ${name.value}'));
```

## 0.1.6
* Release stable

## 0.0.1

* TODO: Describe initial release.
