# File Structure Changes in Spotly

This document summarizes the file structure changes made to improve organization and maintainability of the Spotly app.

## Directory Structure Changes

### Widgets Organization

Event-related widgets are now organized in a dedicated folder:

```
lib/presentation/widgets/event/
├── event_card.dart
├── event_card_shimmer.dart
└── event_edit_sheet.dart
```

Common widgets remain in their original location:
```
lib/presentation/widgets/
├── common/
├── explore/
└── shimmer_loading.dart
```

### Screens Organization

Screen files are now organized in a dedicated folder within pages:

```
lib/presentation/pages/screens/
├── add_event_screen.dart
├── event_details_screen.dart
├── home_screen.dart
├── list_screen.dart
├── map_screen.dart
├── profile_screen.dart
└── splash_screen.dart
```

Feature-specific pages remain in their dedicated folders:
```
lib/presentation/pages/
├── events/
├── explore/
├── home/
├── inbox/
├── main/
├── map/
└── search/
```

### Backup Implementation

Original files have been preserved in a backup folder structure to ensure we can revert changes if needed:

```
lib/presentation/widgets/backup/event/
├── event_card.dart
├── event_card_shimmer.dart
└── event_edit_sheet.dart
```

```
lib/presentation/pages/backup/
├── add_event_screen.dart
├── event_details_screen.dart
├── home_screen.dart
└── ...
```

## Import Path Updates

All imports in the moved files have been updated to reflect their new locations:

1. Updated paths in EventCard:
   - Changed `../../domain/entities/event.dart` to `../../../domain/entities/event.dart`
   - Changed `shimmer_loading.dart` to `../shimmer_loading.dart`
   - Changed `event_edit_sheet.dart` to `./event_edit_sheet.dart`

2. Updated paths in EventEditSheet:
   - Changed `../../domain/entities/event.dart` to `../../../domain/entities/event.dart`
   - Changed `../../domain/entities/event_category.dart` to `../../../domain/entities/event_category.dart`
   - Changed `../blocs/event_bloc/...` to `../../blocs/event_bloc/...`

3. Updated paths in EventDetailsScreen:
   - Changed `../../domain/entities/event.dart` to `../../../domain/entities/event.dart`
   - Changed `../blocs/event_bloc/...` to `../../blocs/event_bloc/...`
   - Changed `../widgets/event_edit_sheet.dart` to `../../widgets/event/event_edit_sheet.dart`

4. Updated paths in ListScreen:
   - Changed `../widgets/event_card.dart` to `../../widgets/event/event_card.dart`
   - Changed `../blocs/event_bloc/...` to `../../blocs/event_bloc/...`

5. Updated router files:
   - Updated `app_router.dart` and `routes/app_router.dart` to use the new screen paths

## Null Safety Fixes

We also improved null safety handling in the relevant files:

1. In EventCard:
   - Added null checks for `event.categories`
   - Used fallback with `event.address ?? event.location`
   - Removed unnecessary null checks on non-nullable fields

2. In EventEditSheet:
   - Added null checks for `widget.event.address`
   - Added default empty list for `widget.event.categories`
   - Added default values for prices and other optional fields
   - Added an extension method to make Event serializable

3. In EventDetailsScreen:
   - Fixed DeleteEventEvent instantiation to use named parameters
   - Added null checks for `event.categories`
   - Fixed optional field access

## Benefits of the New Structure

1. **Better organization:** Related files are grouped together
2. **Improved maintainability:** Clear separation of concerns
3. **Reduced code duplication:** Common components are easier to locate
4. **Enhanced scalability:** Easier to add new features without cluttering directories
5. **Better developer experience:** Easier to find files and understand the project structure 