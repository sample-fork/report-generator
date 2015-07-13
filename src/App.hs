{-# LANGUAGE OverloadedStrings #-}

module App
  ( app
  ) where

import           Data.ByteString (ByteString)
import           DataTypes
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import           Api.Core


routes :: [(ByteString, Handler App App ())]
routes = [ ("static",                 serveDirectory "static")
         ]

app :: SnapletInit App App
app = makeSnaplet "app" "Report Generator." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    a <- nestSnaplet "api" api apiInit
    addRoutes routes
    return $ App h a
