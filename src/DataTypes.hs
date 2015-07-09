{-# LANGUAGE TemplateHaskell #-}

module DataTypes where

import Control.Lens
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.ToField
import Snap.Snaplet
import Snap.Snaplet.Heist

data Report = Report { name :: String
                     , description :: String
                     , amount :: Int} deriving (Show)

instance FromRow Report where
  fromRow = Report <$> field <*> field <*> field

instance ToRow Report where
  toRow d = [toField (name d), toField (description d), toField (amount d)]


data App = App { _heist :: Snaplet (Heist App)}

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist
