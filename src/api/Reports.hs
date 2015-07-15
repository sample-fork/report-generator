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
import           Text.Digestive.View (View)
import           Data.Text.Internal (Text)
import qualified Data.ByteString.Lazy.Char8 as L
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

parseReport :: L.ByteString ->  Maybe (View Text, Maybe Report)
parseReport r =  
  case (decode r) of
    Just jsonRep ->
      fmap (\x ->  (fst x, snd x)) (digestJSON reportForm jsonRep)
    Nothing -> Nothing


createReport :: Handler b Api ()
createReport = do
  reportBody <- readRequestBody 65536
  case (parseReport reportBody) of
    Just (view ,mReport) -> do
      case mReport of
        Just report -> do
          execute "INSERT INTO \"Reports\" (name, effort, description) VALUES (?,?,?)" (name report, effort report, description report)
          writeJSON report
        Nothing -> do 
          logError . pack .show . jsonErrors $ view
          badRequest . pack .show . jsonErrors $ view
    Nothing -> badRequest "unable to parse json"