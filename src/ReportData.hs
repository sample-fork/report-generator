{-# LANGUAGE OverloadedStrings #-}

module ReportData where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.ToField

import Control.Monad
import Control.Applicative
import qualified Data.Text as Text

data Report = Report { name :: String
                     , description :: String
                     , amount :: Int} deriving (Show)

instance FromRow Report where
  fromRow = Report <$> field <*> field <*> field

instance ToRow Report where
  toRow d = [toField (name d), toField (description d), toField (amount d)]


getConnection ::  IO (Connection)
getConnection = do
  conn <- connect defaultConnectInfo {
    connectUser = "report",
    connectDatabase = "report"

  }
  return conn

getReports :: IO ([Report])
getReports = do
  conn <- getConnection
  reports <- (query_ conn "select name, description, effort from \"Reports\"" :: IO [Report])
  return reports