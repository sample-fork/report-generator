{-# LANGUAGE OverloadedStrings #-}

module Api.Utility where

import           Snap.Core
import qualified Data.Aeson as A
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Lazy.Char8 as L

notFound :: Handler b Api ()
notFound = do
  modifyResponse . setResponseCode $ 404
  writeLBS "Not Found"

badRequest :: L.ByteString -> Handler b Api()
badRequest b = do
  modifyResponse . setResponseCode $ 400
  writeLBS b

writeJSON :: A.ToJSON v => v -> Handler a b ()
writeJSON v = do
   modifyResponse $ setContentType "application/json"
   writeLBS $ A.encode v