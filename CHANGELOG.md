## 0.2.2
* Add advanced widget classes for KaeruWidget library
* Compsables core flutter

## 0.2.1
* Add useContext and useWidget functions for improved context 
management within the Kaeru Widget module.

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
