{-# LANGUAGE OverloadedStrings #-}

module ReportData where

import Database.PostgreSQL.Simple
import DataTypes


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