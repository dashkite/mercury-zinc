import * as _ from "@dashkite/joy"
import * as K from "@dashkite/katana"
import Profile from "@dashkite/zinc"
import failure from "./failure"

{sign, hash, Message} = Profile.Confidential

grants = do ({profile} = {}) ->
  _.curry _.rtee (host, key, data) ->
    profile = await Profile.getAdjunct host
    throw failure "no current profile" if !profile?
    profile.receive key, data.directory

claimP = do ({profile, path, claim} = {}) ->
  _.curry (host, {url, parameters, method}) ->
    profile = await Profile.getAdjunct host
    return false if !profile?
    # TODO consider another term for path
    path = url.pathname + url.search
    (profile.lookup {path, parameters, method})?

claim = do ({profile, path, claim} = {}) ->
  (host) ->
    _.flow [
      K.context
      K.push ({url, parameters, method}) ->
        profile = await Profile.getAdjunct host
        throw failure "no current profile" if !profile?
        # TODO consider another term for path
        path = url.pathname + url.search
        if (token = profile.exercise {path, parameters, method})?
          "Capability #{token}"
        else
          console.warn "Mercury: Zinc: claim:
            no matching grant for [#{method} #{path}]"
      K.write "authorization"
    ]

sigil = do ({profile, declaration} = {}) ->
  (host) ->
    _.flow [
      K.context
      K.push ({url, method, body}) ->
        profile = await Profile.getAdjunct host
        throw failure "no current profile" if !profile?
        declaration = sign profile.keyPairs.signature,
          Message.from "utf8",
            JSON.stringify
              method: method.toUpperCase()
              path: url.pathname + url.search
              date: new Date().toISOString()
              hash: (hash Message.from "utf8", body).to "base64"
        token = declaration.to "base64"
        "Sigil #{token}"
      K.write "authorization"
    ]

export {
  grants
  claimP
  claim
  sigil
}
