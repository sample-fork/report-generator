{-# LANGUAGE OverloadedStrings #-}

module Api.Utility where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.ByteString.Char8 as B

notFound :: Handler b Api ()
notFound = do
  modifyResponse . setResponseCode $ 404
  writeLBS "Not Found"

badRequest :: Handler b Api()
badRequest = do
  modifyResponse . setResponseCode $ 400
  writeLBS "Bad Request"