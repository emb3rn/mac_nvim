; extends

; Extends nvim-treesitter's built-in python folds.scm (which only folds the
; whole try_statement as one block). Adding except/else/finally clauses as
; their own nested folds lets `za` fold just the except body under cursor
; instead of the entire try statement.
(except_clause) @fold
(finally_clause) @fold
