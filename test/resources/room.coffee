import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as log from "@dashkite/kaiko"
import * as ks from "@dashkite/katana/sync"
import * as m from "@dashkite/mercury"
import Profile from "@dashkite/zinc"
import * as z from "../../src"
import * as s from "@dashkite/mercury-sky"
import { Key } from "./key"

generateRoom = ({title, blurb, host}) ->
  profile = await Profile.current
  {address, publicKeys, data: {nickname}} = profile
  {title, blurb, host: nickname, address, publicKeys}

Room =

  create:

    _.flow [
      generateRoom
      m.request [
        s.discover "https://kiki-api.dashkite.com"
        _.pipe [
          s.resource "rooms"
          m.parameters
          s.method "post"
          m.content
        ]
        k.context
        k.push z.sigil "kiki-api.dashkite.com"
        m.authorize
      ]
      m.json
      k.push -> Key.get "https://kiki-api.dashkite.com"
      k.pop z.grants "kiki-api.dashkite.com"
      k.get
    ]

  patch:

    _.flow [
      m.request [
        log.debug
        s.discover "https://kiki-api.dashkite.com"
        _.pipe [
          s.resource "room"
          s.method "patch"
          ks.assign [
            ks.read "data"
            ks.poke ({address}) -> {address}
            m.parameters
          ]
          ks.assign [
            ks.read "data"
            ks.poke ({title}) -> { title }
            m.content
          ]
        ]
        k.assign [
          k.context
          k.push z.claim "kiki-api.dashkite.com"
          m.authorize
        ]
      ]
    ]

export { Room }
