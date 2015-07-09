{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module DataTypes where

import           Control.Lens
import           Database.PostgreSQL.Simple.FromRow
import           Database.PostgreSQL.Simple.ToRow
import           Database.PostgreSQL.Simple.ToField
import Control.Lens
import Control.Monad.State.Class
import Data.Aeson
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import           Snap.Snaplet
import           Data.Aeson as A
import           Snap.Snaplet.Heist
import           Snap.Snaplet.PostgresqlSimple

data Report = Report { name :: String
                     , description :: String
                     , effort :: Int} deriving (Show)

instance FromRow Report where
  fromRow = Report <$> field <*> field <*> field

instance ToRow Report where
  toRow d = [toField (name d), toField (description d), toField (effort d)]

instance ToJSON Report where
  toJSON (Report name description amount) = object [ "name" A..= name, "description" A..= description ]

data Api = Api { _pg :: Snaplet Postgres }

makeLenses ''Api

instance HasPostgres (Handler b Api) where
  getPostgresState = with pg get

data App = App { _heist :: Snaplet (Heist App), _api :: Snaplet Api}

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist
