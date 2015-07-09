{-# LANGUAGE OverloadedStrings #-}

module Api where

import           Snap.Snaplet
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Char8 as B


apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [("echo/:echoparam",  method GET respondOk)
             ,("reports",  method GET returnReports)
            ]

returnReports :: Handler b Api ()
returnReports = do
  reports <- query_ "SELECT name, description,effort FROM \"Reports\""
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS . encode $ (reports :: [Report])

respondOk :: Handler b Api ()
respondOk = do
  param <- getParam "echoparam"
  maybe (writeBS "must specify echo/param in URL")
         writeBS param
  modifyResponse . setResponseCode $ 200

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Api Endpoints" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes apiRoutes
  return $ Api pg

