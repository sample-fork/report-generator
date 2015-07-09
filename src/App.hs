{-# LANGUAGE OverloadedStrings #-}

module App
  ( app
  ) where

import           Data.ByteString (ByteString)
import           DataTypes
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Heist
import           Snap.Util.FileServe


routes :: [(ByteString, Handler App App ())]
routes = [ 
			--("echo/:echoParam",   echoHandler)
			("",                 serveDirectory "static")
         ]

app :: SnapletInit App App
app = makeSnaplet "app" "Report Generator." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes routes
    return $ App h

--echoHandler :: Handler App ()
--echoHandler = do
--    param <- getParam "echoparam"
--    maybe (writeBS "must specify echo/param in URL")
--          writeBS param