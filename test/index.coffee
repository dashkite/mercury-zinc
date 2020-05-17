import "source-map-support/register"
import assert from "assert"
import {print, test, success} from "amen"

import "fake-indexeddb/auto"
import fetch from "node-fetch"
import "./custom-event"
import "./local-storage"

import faker from "faker"
import Profile from "@dashkite/zinc"

import Zinc from "../src"

{grants, claim, sigil} = Zinc

global.fetch = fetch

do ->

  Profile.current = await Profile.create
    nickname: faker.internet.userName()

  print await test "Mercury-Zinc: HTTP Combinators",  [

    test "basic test", ->
      assert grants
      assert claim
      assert sigil
  ]

  process.exit if success then 0 else 1
