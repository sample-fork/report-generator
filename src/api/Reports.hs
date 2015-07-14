{-# LANGUAGE OverloadedStrings #-}

module Api.Reports where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import           Api.Utility
import           Api.DataTypes
import           Api.Validation
import           Text.Digestive.Aeson (digestJSON, jsonErrors)
import           Data.Attoparsec.Lazy (parse, maybeResult)
import           Data.ByteString.Char8(pack)

getReports :: Handler b Api ()
getReports = do
  reports <- query_ "SELECT id, name, description,effort FROM \"Reports\""
  writeJSON $ (reports :: [Report])

getReport :: Handler b Api ()
getReport = do
  reportIdParam <- getParam "reportId"
  reports <- query "Select id, name, description, effort FROM \"Reports\" where id = ?" (Only reportIdParam)
  if length reports == 0
    then notFound
    else writeJSON . head $ (reports :: [Report])

parseReport r =  
  case (decode r) of
    Just jsonRep ->
      fmap (\x ->  (fst x, snd x)) (digestJSON reportForm jsonRep)
    Nothing -> Nothing


createReport :: Handler b Api ()
createReport = do
  report <- readRequestBody 65536
  case (parseReport report) of
    Just (v,x) -> do
      case x of
        Just y -> do
      --err <-getErrors 
          execute "INSERT INTO \"Reports\" (name) VALUES (?)" [name y]
          writeJSON x
        Nothing -> do 
          logError . pack .show . jsonErrors $ v
          badRequest
    Nothing -> badRequest