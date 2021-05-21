import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as ks from "@dashkite/katana/sync"
import * as m from "@dashkite/mercury"
import Profile from "@dashkite/zinc"
import * as z from "../../src"
import * as s from "@dashkite/mercury-sky"

Key =

  get:
    _.flow [
      m.request [
        s.discover
        _.pipe [
          s.resource "public keys"
          s.method "get"
          m.parameters type: "encryption"
        ]
      ]
      m.text
      k.get
    ]

export { Key }
