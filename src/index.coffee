import * as _ from "@dashkite/joy"
import * as K from "@dashkite/katana/async"
import * as Ks from "@dashkite/katana/sync"
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

# this is a slightly different variation than the one in Mercury
# - it uses async katana ops because the combinators (claim and sigil)
#   are async
# - we don't use K.assign so we don't need Mercury's header combinators
#   to read from the context
# we maybe want to force them to read from the context, since Mercury
# combinators don't mess with the stack

setter = (f) ->
  (value) ->
    if K.isDaisho value
      ((K.test _.isDefined, f) value)
    else
      _.pipe [ (K.push -> value), f ]

claim = do ({profile, path, claim} = {}) ->
  setter _.flow [
    K.context
    K.push ({url, parameters, method}, host) ->
      profile = await Profile.getAdjunct host
      throw failure "no current profile" if !profile?
      # TODO consider another term for path
      path = url.pathname + url.search
      if (token = profile.exercise {path, parameters, method})?
        "Capability #{token}"
      else
        console.warn "Mercury: Zinc: claim:
          no matching grant for [#{method} #{path}]"
  ]

sigil = do ({profile, declaration} = {}) ->
  setter _.flow [
    K.context
    K.push ({url, method, body}, host) ->
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
  ]

export {
  grants
  claimP
  claim
  sigil
}
