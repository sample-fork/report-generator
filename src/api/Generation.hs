{-# LANGUAGE OverloadedStrings #-}

module Api.Generation where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Data.Aeson
import           Snap.Snaplet
import           DataTypes
import           Api.Utility
import           Api.DataTypes

generateReports :: Handler b Api ()
generateReports = do
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS "yes"