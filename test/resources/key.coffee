import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as ks from "@dashkite/katana/sync"
import * as m from "@dashkite/mercury"
import * as z from "../../src"
import * as s from "@dashkite/mercury-sky"

Key =

  get: m.start [
    s.discover
    _.pipe [
      s.resource "public keys"
      s.method "get"
      m.parameters type: "encryption"
      # m.cache "test"
      m.request
    ]
    m.text
    k.get
  ]

export { Key }
