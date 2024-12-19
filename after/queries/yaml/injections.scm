;; extends

(((string_scalar) @_val @injection.content)
(#lua-match? @_val "${%w")
(#set! injection.language "kpops"))

(([
    (double_quote_scalar)
    (single_quote_scalar)
] @_val @injection.content)
(#lua-match? @_val "${%w")
(#offset! @injection.content 0 1 0 -1)
(#set! injection.language "kpops"))
