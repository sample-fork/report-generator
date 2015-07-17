{-# LANGUAGE OverloadedStrings #-}

module Api.Utility where

import           Snap.Core
import qualified Data.Aeson as A
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy.Char8 as L
import           Control.Exception (SomeException, catch)

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


--catchError :: B.ByteString -> Handler a Api () -> Handler a Api ()
--catchError msg action = action `E.catch` \(e::E.SomeException) -> go
--    where go = do logError msg
--                  modifyResponse $ setResponseCode 500