import {curry, rtee} from "panda-garden"
import Profile from "@dashkite/zinc"
import failure from "./failure"

{sign, hash, Message} = Profile.Confidential

Zinc =

  grants: do ({profile} = {}) ->
    curry rtee (host, key, context) ->
      profile = await Profile.getAdjunct host
      throw failure "no current profile" if !profile?
      profile.receive key, context.json.directory

  claimP: do ({profile, path, claim} = {}) ->
    curry (host, {url, parameters, method}) ->
      profile = await Profile.getAdjunct host
      return false if !profile?
      # TODO consider another term for path
      path = url.pathname + url.search
      (profile.lookup {path, parameters, method})?

  claim: do ({profile, path, claim} = {}) ->
    curry (host, {url, parameters, method}) ->
      profile = await Profile.getAdjunct host
      throw failure "no current profile" if !profile?
      # TODO consider another term for path
      path = url.pathname + url.search
      if (token = profile.exercise {path, parameters, method})?
        "X-Capability #{token}"
      else
        console.warn "Mercury: Zinc: claim:
          no matching grant for [#{method} #{path}]"

  sigil: do ({profile, declaration} = {}) ->
    curry (host, {url, method, body}) ->
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

export default Zinc
