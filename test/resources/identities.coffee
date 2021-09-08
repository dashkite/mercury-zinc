import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as ks from "@dashkite/katana/sync"
import * as m from "@dashkite/mercury"
import * as z from "../../src"
import * as s from "@dashkite/mercury-sky"
import { Key } from "./key"

Identities =

  post: m.start [
    s.discover "https://breeze-development-api.dashkite.com"
    _.pipe [
      s.resource "identities"
      s.method "post"
      m.parameters
      m.content
    ]
    z.claim "breeze-development-api.dashkite.com"
    m.authorize
    m.request
    m.json
    k.get
  ]


export { Identities }
