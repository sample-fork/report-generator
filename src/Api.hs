{-# LANGUAGE OverloadedStrings #-}

module Api where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Char8 as B


apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [ ("echo/:echoparam",  method GET respondOk)
             ,("reports",  method GET getReports)
             ,("reports/:reportId", method GET getReport)
            ]

getReports :: Handler b Api ()
getReports = do
  reports <- query_ "SELECT id, name, description,effort FROM \"Reports\""
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS . encode $ (reports :: [Report])

notFound :: Handler b Api ()
notFound = do
  modifyResponse . setResponseCode $ 404
  writeLBS "Not Found"

getReport :: Handler b Api ()
getReport = do
  reportIdParam <- getParam "reportId"
  reports <- query "Select id, name, description, effort FROM \"Reports\" where id = ?" (Only reportIdParam)
  modifyResponse $ setHeader "Content-Type" "application/json"
  if length reports == 0
    then notFound
    else writeLBS . encode $ head (reports :: [Report])


  

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

