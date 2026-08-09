# SwiftUI Migration Baseline

## Product Decisions

- Minimum deployment target: iOS 18.
- Devices: universal iPhone and iPad application.
- Catalog: every `Gameboard.BoardType` appears in the game library.
- Readiness: each game explicitly reports either `ready` or `comingSoon`.
- Selection behavior:
  - Ready games open an interactive game session after their SwiftUI conversion.
  - Coming-soon games remain selectable and will open a noninteractive SwiftUI gameboard preview with a coming-soon status.
- Gameplay changes, new rules, and new games are outside the conversion scope.

## Initial Readiness Classification

| Game | Readiness | Baseline evidence |
| --- | --- | --- |
| Backgammon | Coming soon | A board definition and SwiftUI rendering exist, but there is no active move validation or interaction implementation. |
| Bombsweeper | Ready | Guessing, marking, completion, and reset paths exist. |
| Checkers | Ready | Selection, available moves, and move validation exist. |
| Chess | Ready | Selection, available moves, and move validation exist. |
| Dots | Ready | Move validation and legacy interaction exist; the SwiftUI coming-soon label is stale presentation work. |
| Doubles | Ready | Directional move validation and legacy swipe interaction exist. |
| Four | Ready | Drop validation and game-over checking exist. |
| Go | Ready | Move validation and legacy interaction exist; the SwiftUI coming-soon label is stale presentation work. |
| Mancala | Coming soon | A board definition and preview rendering exist, but move validation and interaction are unfinished. |
| Memory | Ready | Selection and matching validation exist. |
| Pegs | Ready | Selection, available moves, and move validation exist. |
| Sudoku | Ready | Guess validation, difficulty, and reset paths exist. |
| Tic Tac Toe | Ready | Move validation and game-over checking exist. |
| Words | Ready | Tile placement, rack state, and reset paths exist, although later gameplay review may identify incomplete scoring or turn rules. |

Readiness describes whether an existing gameplay path can be preserved during conversion. It does not mean that the current storyboard or SwiftUI presentation is runnable.

## Phase 0 Behavior Baseline

The migration must preserve these behaviors until the later gameplay phase intentionally changes them:

- A new game initializes the board from its board definition.
- Valid moves mutate the grid through `Gameboard` validation.
- Multiplayer games advance the current player after a valid move.
- Selection-based games expose selected squares and available-move highlights.
- Puzzle games retain their current difficulty and reset behavior.
- Reset restores board content.
- Existing game-over conditions remain unchanged.
- Invalid moves continue to produce the existing validation errors.

Known baseline behavior: `Gameboard.reset()` currently does not restore `playerTurn` to the first player. The Phase 0 test records this behavior so the conversion does not change it accidentally; whether reset should change the active player belongs to gameplay review.

## Phase 0 Exit Criteria

- The app and test target use iOS 18 as their minimum deployment target.
- The application targets both iPhone and iPad.
- The catalog and playable collections are derived from explicit readiness state.
- All board types remain discoverable through the catalog.
- Catalog and representative rule tests pass.
- The bundled Apple Symbols font and its plist registration are removed in favor of the iOS system font.
- Current build limitations and behavioral gaps are documented before the SwiftUI app lifecycle work starts.

## Verification Status

- The project and plist files pass `plutil` validation.
- The source and unit-test targets compile for a generic iOS device with an iOS 18 deployment target.
- The test bundle is produced inside the host application.
- The sandboxed build environment cannot connect to CoreSimulator or run Swift macro plugins, but normal Xcode execution succeeds.
- The complete resource build and simulator tests pass when Xcode runs with access to its standard developer services.

## Phase 1 Completion

- `GameboardApp` is the sole compiled application entry point.
- The application scene is a SwiftUI `WindowGroup`.
- `GameboardSceneState` tracks the selected game and current `ScenePhase` using Observation.
- `GameLibraryView` uses `NavigationSplitView` to adapt between an iPhone navigation stack and an iPad list/detail layout.
- Every catalog game routes directly to its existing SwiftUI board layout without loading a storyboard or UIKit controller.
- Backgammon and Mancala destinations are noninteractive previews with a centralized coming-soon badge.
- The main storyboard, `AppDelegate`, and `MainViewController` remain in the repository for later legacy cleanup but are no longer compiled or packaged as the runtime shell.
- The main-storyboard plist key has been removed. The launch storyboard remains packaged as the system launch screen.
- The complete application and test bundle build successfully with all resources.
- Five unit tests pass on both iPhone 16 and iPad (10th generation) simulators running iOS 18.1.

## Phase 2 Completion

- The active game engine imports Foundation only; UIKit and SwiftUI types have been removed from `Gameboard`, `Grid`, validation, and the 14 catalog board definitions.
- Storyboard controller creation, presentation colors, layout padding, callback-based alerts, the placeholder UIKit visualization API, and the `UILabel` helper have been removed from the domain model.
- `GameSession` is the observable app-layer owner for a live `Gameboard`. It exposes board state, player state, reset and action methods, and converts rule errors and terminal statuses into observable session events.
- Game destinations retain one session for the lifetime of the selected destination instead of recreating `Gameboard` during every SwiftUI body evaluation.
- Grid cells use their row and column coordinates as stable SwiftUI identities. Their numeric column index remains separately available for layout calculations.
- Dormant experimental boards and all legacy `UIView` board implementations remain in the repository for historical reference but are no longer compiled into the application.
- The Words and Mancala storyboards are no longer packaged. The system launch storyboard remains the only storyboard resource.
- The heterogeneous `Grid.content` representation remains `[[Any]]` for compatibility with all existing rule engines. Replacing it requires an explicit per-game cell model and is deferred until the gameplay migration can test those types game by game.
- The active engine source set type-checks independently with `swiftc` without UIKit or SwiftUI.
- The full application and test bundle build successfully, and all seven unit tests pass on an iPhone 16 simulator running iOS 18.1.

## Phase 3 Completion

- Every ready game is interactive through SwiftUI. Direct-tap boards, selection-and-highlight boards, column drops, card matching, tile swipes, puzzle guesses, marking, and Words rack placement are connected to `GameSession`.
- `GameSceneUI` provides shared game chrome for the active player, readiness, reset, and session alerts. `BoardInteractionGrid` provides reusable coordinate-based hit targets, selection presentation, highlights, and accessibility labels.
- Tic Tac Toe, Four, and Bombsweeper publish terminal session events through the shared presentation layer. Memory preserves its delayed unmatched-pair reveal behavior.
- Words now has a SwiftUI board and rack backed by session-owned bag, rack, selection, placement, refill, and reset state.
- Backgammon and Mancala remain visible, selectable, noninteractive coming-soon previews as established in Phase 0.
- The legacy available-move scan was corrected so successful hint validation that returns no captured piece still publishes selection and legal destinations for Checkers, Chess, and Pegs.
- The full application and test bundle build successfully, and twelve catalog, session, and representative interaction tests pass on an iPhone 16 simulator running iOS 18.1.

## Phase 4 Completion

- The active presentation source now uses native SwiftUI and CoreGraphics APIs. UIKit font construction, `UIBezierPath`, platform color literals, and the custom `Apple Symbols` font lookup were removed from compiled game-board code.
- Chess and the other symbol-based boards use SwiftUI system fonts supplied by iOS. The deleted font resource is no longer referenced by the runtime UI.
- Deprecated `NavigationView`, `edgesIgnoringSafeArea`, and explicit segmented-picker style construction were replaced with their current SwiftUI equivalents.
- The selected game is stored with `@SceneStorage`, so each SwiftUI scene restores its own catalog selection while the shared scene-phase observer continues to track lifecycle changes.
- The navigation split view uses a balanced adaptive style for the universal iPhone and iPad target.
- Interactive board coordinates now expose their visible cell value to VoiceOver, distinguish covered and hidden cells, announce selection, and identify legal destinations.
- Dedicated previews cover the catalog, a ready game, a coming-soon board, and an accessibility Dynamic Type size. Existing board previews now use `NavigationStack`.
- Historical UIKit board views, storyboard files, and commented prototype implementations remain outside the active build for the final legacy-cleanup phase.
- The complete app and test bundle build successfully, and all thirteen tests pass on both iPhone 16 and iPad (10th generation) simulators running iOS 18.1.

## Phase 5 Completion

- `GameboardApp` and its SwiftUI `WindowGroup` are the only application lifecycle path. The obsolete app delegate, main view controller, generic board view controller, and UIKit bridge have been deleted.
- All fourteen legacy `UIView` board renderers and the empty touch-modifier prototype have been deleted. Their Xcode build objects, file references, and groups were removed with them.
- The main, launch, Checkers, Mancala, and Words storyboards have been deleted. The application bundle contains no storyboard, compiled storyboard, nib, or Interface Builder resource.
- The launch screen now uses the `UILaunchScreen` plist declaration. The obsolete `armv7` capability and full-screen-only requirement were removed.
- iPhone supports portrait and both landscape orientations. iPad supports all four orientations and is no longer prevented from participating in supported multitasking and window configurations.
- Commented UIKit renderers and controller fragments were removed from the active SwiftUI board files.
- Dormant game-rule experiments in the playground remain as source material for the later new-games discussion, but they have no target build entries and do not affect the application.
- The packaged application has a minimum system version of iOS 18, targets both iPhone and iPad, and contains only the asset catalog as a custom resource.
- The complete storyboard-free application and test bundle build successfully, and all thirteen tests pass on both iPhone 16 and iPad (10th generation) simulators running iOS 18.1.

The UIKit-to-SwiftUI and storyboard-to-Scene migration is complete. Gameplay changes and new games can proceed as separate product work without carrying the legacy presentation architecture forward.
