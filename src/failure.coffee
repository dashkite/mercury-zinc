failure = do ({codes, message} = {}) ->

  codes =

    "no current profile": ->
      "Profile.current is undefined"

  (code, args...) ->
    message = codes[code] args...
    new Error "Mercury: #{message}"

export default failure
