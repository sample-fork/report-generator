{-# LANGUAGE OverloadedStrings #-}

module Api.Reports where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import           Api.Utility
import           Api.DataTypes

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