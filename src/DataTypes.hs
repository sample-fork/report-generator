{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module DataTypes where

import           Control.Lens
import           Database.PostgreSQL.Simple.FromRow
import           Database.PostgreSQL.Simple.ToRow
import           Database.PostgreSQL.Simple.ToField
import           Control.Monad.State.Class
import           Snap.Snaplet
import           Control.Monad.Reader
import           Control.Applicative
import           Control.Monad
import           Data.Aeson as A
import           Snap.Snaplet.Heist
import           Snap.Snaplet.PostgresqlSimple

data Report = Report { reportId :: Int
                     , name :: String
                     , description :: Maybe String
                     , effort :: Int} deriving (Show)

instance FromRow Report where
  fromRow = Report <$> field <*> field <*> field <*> field

instance ToRow Report where
  toRow d = [toField (reportId d), toField (name d), toField (description d), toField (effort d)]

instance ToJSON Report where
  toJSON (Report reportId name description effort) = object [ "id" A..= reportId, "name" A..= name, "description" A..= description, "effort" A..= effort ]

instance FromJSON Report where
  parseJSON (Object v) = Report <$>
                         v .: "id" <*>
                         v .: "name" <*>
                         v .:? "description" <*>
                         v .: "effort"
  parseJSON _ = mzero


data Api = Api { _pg :: Snaplet Postgres }

makeLenses ''Api

instance HasPostgres (Handler b Api) where
  getPostgresState = with pg get
  setLocalPostgresState s = local (set (pg . snapletValue) s)

data App = App { _heist :: Snaplet (Heist App), _api :: Snaplet Api}

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist
