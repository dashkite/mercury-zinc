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

import {
  Room
  Key
} from "./resources"

do ({room} = {})->

  Profile.current = await Profile.create "kiki-api.dashkite.com",
    nickname: faker.internet.userName()

  print await test "Mercury Zinc: HTTP Combinators For Zinc",  [

    await test
      description: "create room"
      wait: 5000
      ->
        {room} = await Room.create
          title: _.titleCase faker.lorem.words()
          blurb: faker.lorem.sentence()
        assert room.created

    await test
      description: "update room"
      wait: 5000
      ->
        response = await Room.patch
          title: _.titleCase faker.lorem.words()
          address: room.address
  ]

  process.exit if success then 0 else 1
