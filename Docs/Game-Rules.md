# Game rules and controls

All games use a persistent result. Dismissing the result alert does not reopen
the board; Reset starts another game. Two-player games also offer resignation
and a mutually agreed draw from the Game menu.

## Chess

- Existing board orientation and player colors are retained.
- Legal moves and hints enforce king safety, including pinned pieces and
  adjacent kings. Kings cannot be captured.
- Castling requires an unmoved king and rook, an empty path, and safe king
  squares. Moving a rook back does not restore castling rights.
- En passant is available only immediately after the opposing pawn's double
  move, and cannot expose the moving player's king.
- Choose queen, rook, bishop, or knight in the promotion menu before moving
  a pawn to its final rank. Queen is the default.
- Checkmate wins; stalemate and common insufficient-material positions draw.
- Claim draw becomes available at threefold repetition or 100 half-moves
  without a pawn move or capture. Fivefold repetition and 150 such half-moves
  draw automatically, with checkmate taking precedence.
- When a selected piece can make a move establishing a threefold or 50-move
  claim, Claim draw with move lists those destinations.
- No clocks or tournament adjudication of arbitrary composed dead positions
  are included.

## Checkers

English/American movement rules apply: captures are mandatory, the capturing
piece must finish its jumps, and crowning ends the turn. Claim draw becomes
available on the third occurrence of a position with the same player to move,
or after each player has made 40 moves without advancing a man or capturing.
Losing all pieces or having no legal move loses.

## Go

- Black starts on the existing 9×9 board.
- Suicide is rejected after captures are resolved. Positional superko prevents
  recreating an earlier board arrangement; passing remains legal.
- Area scoring counts live stones and empty regions bordered exclusively by
  that color. Mixed-border regions are neutral.
- White receives 6.5 komi by default. Before placing stones, the menu offers
  0.5, 5.5, 6.5, or 7.5.
- Two passes open score review. Tap a stone to mark or unmark its entire group
  as dead. Changing dead groups clears both score approvals.
- Each player must accept the score. Resume play discards the proposed dead
  markings and restores the player who was next after the two passes.

## Words

This is a local two-player word game using the existing board, bag, and letter
values, rather than a tournament Scrabble dictionary or scoring configuration.

- Each player has a separate seven-tile rack.
- Stage tiles on one row or column. Existing tiles may bridge the new tiles,
  but gaps are not allowed. The first word covers the star; later words must
  connect to committed tiles.
- Submit checks every new main word and cross-word before committing any of
  the turn. Invalid submissions keep the staged tiles available for correction.
- English validation uses iOS's UITextChecker lexicon. Its accepted vocabulary
  can differ from a tournament word list and may reflect learned system words.
- Letter and word premiums apply only to newly placed tiles and apply to every
  word formed by those tiles. The star is a neutral starting marker. Playing
  seven tiles grants a 35-point bonus.
- Choose a blank's letter before placing it. It keeps a value of zero in all
  later words.
- Tap a staged tile to return it to its rack slot, or use Recall for all tiles.
  Submit refills the rack and changes players.
- Pass requires recalling pending tiles. Exchange swaps the selected tile and
  ends the turn; at least seven tiles must remain in the bag.
- Emptying a rack with an empty bag ends the game. Remaining rack values are
  deducted, and the player who went out receives the opponent's remaining value.
- Six consecutive scoreless turns also end the game, deducting each player's
  remaining rack value without a transfer.

## Other completed end conditions

- **Dots:** only owned box centers count toward the score. Filling the last
  segment declares the higher score the winner, or a draw.
- **Doubles:** existing spawn-before-movement behavior and timed movement are
  retained. Each merge adds its resulting value to the score. Reaching 2048
  wins; a full board without a legal merge loses.
- **Pegs:** one remaining peg anywhere wins. More than one peg with no legal
  jump loses.
- **Backgammon:** the opening rolls one die for each player. Ties require a new
  opening roll; the higher die starts using both opening values. Later doubles
  still grant four moves. This remains a single game without a doubling cube
  or a gammon/backgammon match-score system.

## Rule references

- [FIDE Laws of Chess](https://handbook.fide.com/chapter/e012023)
- [WCDF English Checkers rules](https://wcdf.net/rules/rules_of_checkers_english.pdf)
- [AGA Go rules](https://www.britgo.org/rules/agarules.html) for capture, repetition,
  passing, and scoring concepts; the app uses the explicit area-scoring variant
  above rather than the complete AGA tournament procedure.
- [Backgammon rules](https://www.bkgm.com/rules.html)
- [Apple UITextChecker documentation](https://developer.apple.com/documentation/uikit/uitextchecker)
