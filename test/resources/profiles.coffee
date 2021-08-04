import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as ks from "@dashkite/katana/sync"
import * as m from "@dashkite/mercury"
import * as z from "../../src"
import * as s from "@dashkite/mercury-sky"
import { Key } from "./key"

loadGrants = _.tee _.flow [
  k.push (json) -> json
  k.push -> Key.get "https://breeze-development-api.dashkite.com"
  k.mpoke (key, data) ->
    z.grants "breeze-development-api.dashkite.com", key, data
]

Profiles =

  create: m.start [
    s.discover "https://breeze-development-api.dashkite.com"
    s.resource "profiles"
    s.method "post"
    m.content
    # TODO can we avoid this?
    m.parameters {}
    z.sigil "breeze-development-api.dashkite.com"
    m.authorize
    m.request
    m.json
    loadGrants
    k.get
  ]

Profile =

  delete: m.start [
    s.discover "https://breeze-development-api.dashkite.com"
    s.resource "profile"
    s.method "delete"
    k.read "data"
    m.parameters
    z.claim "breeze-development-api.dashkite.com"
    m.authorize
    m.request
  ]



export { Profiles, Profile }
