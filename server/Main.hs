{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Data.String
import Data.Text (Text,pack,isPrefixOf)
import Data.Maybe (mapMaybe)
import qualified Network.WebSockets as WS
import qualified Network.Wai.Handler.WebSockets as WS
import qualified Network.Wai.Application.Static as Static
import qualified WaiAppStatic.Types as Static
import qualified Network.Wai.Handler.Warp as Warp

staticFiles =
  [ "index.html" ]

staticSettings = (Static.defaultFileServerSettings (fromString "static"))
  { Static.ssIndices = mapMaybe (Static.toPiece . pack) staticFiles
  , Static.ssListing = Nothing }

static = Static.staticApp staticSettings

socket pending = do
  conn <- WS.acceptRequest pending
  WS.forkPingThread conn 30
  handleMessage conn

handleMessage conn = do
  msg <- WS.receiveData conn
  WS.sendTextData conn ("Blub: " ++ msg::Text)
  handleMessage conn

main = Warp.run 3000 $ WS.websocketsOr WS.defaultConnectionOptions socket static