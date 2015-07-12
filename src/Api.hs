{-# LANGUAGE OverloadedStrings #-}

module Api where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.ByteString.Char8 as B


apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [ ("reports",  method GET getReports)
             ,("reports/:reportId", method GET getReport)
             ,("reports", method POST createReport)
            ]

notFound :: Handler b Api ()
notFound = do
  modifyResponse . setResponseCode $ 404
  writeLBS "Not Found"

badRequest :: Handler b Api()
badRequest = do
  modifyResponse . setResponseCode $ 400
  writeLBS "Bad Request"

getReports :: Handler b Api ()
getReports = do
  reports <- query_ "SELECT id, name, description,effort FROM \"Reports\""
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS . encode $ (reports :: [Report])

getReport :: Handler b Api ()
getReport = do
  reportIdParam <- getParam "reportId"
  reports <- query "Select id, name, description, effort FROM \"Reports\" where id = ?" (Only reportIdParam)
  modifyResponse $ setHeader "Content-Type" "application/json"
  if length reports == 0
    then notFound
    else writeLBS . encode $ head (reports :: [Report])


createReport :: Handler b Api ()
createReport = do
  report <- readRequestBody 65536
  modifyResponse $ setHeader "Content-Type" "application/json"
  case (decode report :: Maybe Report) of
    Just x -> do
      execute "INSERT INTO \"Reports\" (name) VALUES (?)" [name x]
      writeLBS . encode $ x
    Nothing -> badRequest
  
  

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Api Endpoints" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes apiRoutes
  return $ Api pg

