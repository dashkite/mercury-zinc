import assert from "assert"
import {print, test, success} from "amen"

import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"

# set up db and local storage that zinc depends upon
import "fake-indexeddb/auto"
import "./local-storage"

import Profile from "@dashkite/zinc"

import fetch from "node-fetch"
globalThis.fetch ?= fetch
global.Request ?= fetch.Request

# we want to generate fake data for our test
import faker from "faker"

import * as R from "./resources"

do ({room} = {}) ->

  nickname = faker.internet.userName()
  profile = await Profile.create "breeze-development-api.dashkite.com",
    { nickname }
  Profile.current = profile

  print await test "Mercury Zinc: HTTP Combinators For Zinc",  [

    await test
      description: "create profile"
      wait: 5000
      ->
        R.Profiles.create { profile, nickname }

    await test
      description: "delete profile"
      wait: 5000
      ->
        R.Profile.delete { nickname }

  ]

  process.exit if success then 0 else 1
